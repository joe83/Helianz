import { Router, Request, Response } from 'express';
import { loginAsync, generateDebugToken } from '../services/authService';
import pool from '../config/database';
import { RowDataPacket } from 'mysql2';

const router = Router();

/**
 * @swagger
 * /api/auth/login:
 *   post:
 *     tags: [Auth]
 *     summary: Login with OpenDental credentials
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [Username, Password]
 *             properties:
 *               Username:
 *                 type: string
 *               Password:
 *                 type: string
 *     responses:
 *       200:
 *         description: JWT token + user info
 *       401:
 *         description: Invalid credentials
 */
router.post('/login', async (req: Request, res: Response) => {
  try {
    // Accept both PascalCase (C# convention) and camelCase (JS convention)
    const body = req.body;
    const loginRequest = {
      Username: body.Username || body.username || '',
      Password: body.Password || body.password || '',
    };
    const result = await loginAsync(loginRequest);
    if (!result) {
      return res.status(401).json({ error: 'Invalid username or password' });
    }
    res.json(result);
  } catch (err: any) {
    console.error('Login error:', err);
    res.status(500).json({ error: err.message });
  }
});

/**
 * @swagger
 * /api/auth/debug-token:
 *   get:
 *     tags: [Auth]
 *     summary: Auto-login as first active user (testing only)
 *     responses:
 *       200:
 *         description: JWT token for debug
 *       404:
 *         description: No users found
 */
router.get('/debug-token', async (_req: Request, res: Response) => {
  try {
    const conn = await pool.getConnection();
    try {
      const [users] = await conn.query<RowDataPacket[]>(
        `SELECT UserNum, UserName, ClinicNum FROM userod WHERE IsHidden = 0 LIMIT 1`
      );
      if (users.length === 0) {
        return res.status(404).json({ error: 'No users found' });
      }
      const user = users[0];

      const [clinicRows] = await conn.query<RowDataPacket[]>(
        `SELECT ClinicNum FROM userclinic WHERE UserNum = ?`, [user.UserNum]
      );
      const clinicNums: number[] = clinicRows.map((r: any) => r.ClinicNum);
      if (clinicNums.length === 0) clinicNums.push(user.ClinicNum);

      const [groupRows] = await conn.query<RowDataPacket[]>(
        `SELECT UserGroupNum FROM usergroupattach WHERE UserNum = ?`, [user.UserNum]
      );
      const userGroupNums: number[] = groupRows.map((r: any) => r.UserGroupNum);

      // Try real login first
      const loginResult = await loginAsync({ Username: user.UserName, Password: '' });
      if (loginResult) return res.json(loginResult);

      // Fallback: debug token
      const token = generateDebugToken(user.UserNum, user.UserName, clinicNums);
      res.json({
        token,
        displayName: user.UserName,
        userNum: user.UserNum,
        clinicNum: user.ClinicNum,
        clinicNums,
        userGroupNums,
        permissions: [],
      });
    } finally {
      conn.release();
    }
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
