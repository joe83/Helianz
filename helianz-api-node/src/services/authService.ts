import { createHash } from 'crypto';
import jwt from 'jsonwebtoken';
import pool from '../config/database';
import { LoginRequest, LoginResponse, UserPermission, JwtPayload } from '../models';
import pino from 'pino';

const logger = pino({ name: 'auth-service' });
const JWT_KEY = process.env.JWT_KEY || 'HelianzDevKey-ChangeInProduction-Min32Chars!';
const JWT_EXPIRY_HOURS = parseInt(process.env.JWT_EXPIRY_HOURS || '24', 10);

interface UserRow {
  UserNum: number;
  UserName: string;
  Password: string;
  UserGroupNum: number;
  ClinicNum: number;
  EmployeeNum: number;
  IsHidden: number;
}

/**
 * Verify password against OpenDental hash formats:
 *   SHA3_512: Unicode(salt+pass) → SHA3-512 → Base64
 *   MD5:      Unicode(pass) → MD5 → Base64 (24 chars, ends with ==)
 *   MD5_ECW:  ASCII(pass) → MD5 → hex lowercase (32 chars)
 *
 * Stored format: HashType$Salt$Hash
 */
function verifyPassword(plaintext: string, storedHash: string): boolean {
  if (!storedHash) return !plaintext;

  // Parse HashType$Salt$Hash
  const parts = storedHash.split('$');
  let hashType: string;
  let salt: string;
  let hash: string;

  if (parts.length === 3 || (parts.length === 2 && ['None', 'MD5', 'MD5_ECW', 'SHA3_512', 'SHA512'].includes(parts[0]))) {
    hashType = parts[0];
    salt = parts.length === 3 ? parts[1] : '';
    hash = parts[parts.length - 1];
  } else if (storedHash.length === 24 && storedHash.endsWith('==') && !storedHash.includes('$')) {
    // Legacy MD5 base64 hash (24 chars, no $ separator)
    hashType = 'MD5';
    salt = '';
    hash = storedHash;
  } else {
    return plaintext === storedHash;
  }

  let computed: string;
  switch (hashType) {
    case 'SHA3_512':
    case 'SHA512':
      computed = hashSHA3_512(salt + plaintext);
      break;
    case 'MD5':
      computed = hashMD5(plaintext);
      break;
    case 'MD5_ECW':
      computed = hashMD5_ECW(plaintext);
      break;
    case 'None':
      computed = plaintext;
      break;
    default:
      computed = plaintext;
  }

  return constantEquals(computed, hash);
}

function hashSHA3_512(input: string): string {
  if (!input) return '';
  const buf = Buffer.from(input, 'utf16le'); // UTF-16 LE = Unicode in .NET
  return createHash('sha3-512').update(buf).digest('base64');
}

function hashMD5(input: string): string {
  if (!input) return '';
  const buf = Buffer.from(input, 'utf16le');
  return createHash('md5').update(buf).digest('base64');
}

function hashMD5_ECW(input: string): string {
  if (!input) return '';
  const buf = Buffer.from(input, 'ascii');
  return createHash('md5').update(buf).digest('hex').toLowerCase();
}

function constantEquals(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) {
    diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return diff === 0;
}

function generateToken(
  userNum: number,
  username: string,
  clinicNums: number[],
  userGroupNums: number[],
  permissions: UserPermission[]
): string {
  const claims: Record<string, string | string[]> = {
    sub: userNum.toString(),
    name: username,
    ClinicNum: clinicNums.map(String),
    UserGroupNum: userGroupNums.map(String),
  };

  // Store permission types as claims: Perm_<type> = "fkey1,fkey2,..."
  const permGroups = new Map<number, number[]>();
  for (const p of permissions) {
    const arr = permGroups.get(p.permType) || [];
    arr.push(p.fKey);
    permGroups.set(p.permType, arr);
  }
  for (const [permType, fkeys] of permGroups) {
    claims[`Perm_${permType}`] = fkeys.join(',');
  }

  const payload: Omit<JwtPayload, 'iat' | 'exp'> = {
    sub: userNum.toString(),
    name: username,
    ClinicNum: clinicNums.map(String),
    UserGroupNum: userGroupNums.map(String),
  };
  // Add dynamic Perm_ keys
  for (const [k, v] of Object.entries(claims)) {
    if (k.startsWith('Perm_')) {
      (payload as any)[k] = v;
    }
  }

  return jwt.sign(payload, JWT_KEY, {
    expiresIn: `${JWT_EXPIRY_HOURS}h`,
    algorithm: 'HS256',
  });
}

export async function loginAsync(request: LoginRequest): Promise<LoginResponse | null> {
  const conn = await pool.getConnection();
  try {
    logger.info({ user: request.Username }, 'Login attempt');

    const [users] = await conn.query<any[]>(
      `SELECT UserNum, UserName, Password, UserGroupNum, ClinicNum, EmployeeNum, IsHidden
       FROM userod WHERE UserName = ? AND IsHidden = 0`,
      [request.Username]
    );
    const user: UserRow | undefined = users[0];

    if (!user) {
      logger.warn({ user: request.Username }, 'User not found');
      return null;
    }

    if (!verifyPassword(request.Password, user.Password)) {
      logger.warn({ user: request.Username }, 'Invalid password');
      return null;
    }

    // Get clinic access
    const [clinicRows] = await conn.query<any[]>(
      `SELECT ClinicNum FROM userclinic WHERE UserNum = ?`,
      [user.UserNum]
    );
    const clinicNums: number[] = clinicRows.map((r: any) => r.ClinicNum);
    if (clinicNums.length === 0) clinicNums.push(user.ClinicNum);

    // Get user groups
    const [groupRows] = await conn.query<any[]>(
      `SELECT UserGroupNum FROM usergroupattach WHERE UserNum = ?`,
      [user.UserNum]
    );
    const userGroupNums: number[] = groupRows.map((r: any) => r.UserGroupNum);

    // Get permissions
    let permissions: UserPermission[] = [];
    if (userGroupNums.length > 0) {
      const placeholders = userGroupNums.map(() => '?').join(',');
      const [permRows] = await conn.query<any[]>(
        `SELECT DISTINCT gp.PermType, gp.FKey, gp.NewerDate, gp.NewerDays
         FROM grouppermission gp
         WHERE gp.UserGroupNum IN (${placeholders})
         ORDER BY gp.PermType, gp.FKey`,
        userGroupNums
      );
      permissions = permRows.map((r: any) => ({
        permType: r.PermType,
        name: '',
        fKey: r.FKey,
        newerDate: r.NewerDate,
        newerDays: r.NewerDays,
      }));
    }

    const token = generateToken(user.UserNum, user.UserName, clinicNums, userGroupNums, permissions);

    return {
      token,
      displayName: user.UserName,
      userNum: user.UserNum,
      clinicNum: user.ClinicNum,
      clinicNums,
      userGroupNums,
      permissions,
    };
  } catch (err) {
    logger.error({ err, user: request.Username }, 'Login failed');
    throw err;
  } finally {
    conn.release();
  }
}

export function generateDebugToken(userNum: number, username: string, clinicNums: number[]): string {
  return generateToken(userNum, username, clinicNums, [], []);
}
