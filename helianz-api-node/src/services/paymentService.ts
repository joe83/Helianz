import { RowDataPacket, ResultSetHeader } from 'mysql2';
import pool from '../config/database';
import {
  Payment, PaySplit, PaymentSearchRequest, PaymentSearchResult,
  PaymentCreateRequest,
} from '../models';

function mapPayment(r: any): Payment {
  return {
    payNum: r.PayNum,
    patNum: r.PatNum,
    patientName: r.PatientName || '',
    clinicNum: r.ClinicNum,
    payDate: r.PayDate instanceof Date ? r.PayDate.toISOString().substring(0, 10) : r.PayDate,
    payAmt: Number(r.PayAmt) || 0,
    payType: r.PayType,
    payTypeName: r.PayTypeName,
    checkNum: r.CheckNum,
    bankBranch: r.BankBranch,
    note: r.Note,
    provNum: r.ProvNum || 0,
    provName: r.ProvName || '',
    secUserNumEntry: r.SecUserNumEntry || 0,
    dateEntry: r.DateEntry instanceof Date ? r.DateEntry.toISOString() : r.DateEntry,
    payGroupNum: r.PayGroupNum || 0,
    splits: [],
  };
}

export async function searchAsync(req: PaymentSearchRequest, allowedClinics: number[]): Promise<PaymentSearchResult> {
  const conn = await pool.getConnection();
  try {
    const conditions: string[] = [];
    const params: any[] = [];

    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    if (effectiveClinics.length > 0) {
      conditions.push(`p.ClinicNum IN (${effectiveClinics.map(() => '?').join(',')})`);
      params.push(...effectiveClinics);
    }
    if (req.patNum) { conditions.push('p.PatNum = ?'); params.push(req.patNum); }
    if (req.clinicNum) { conditions.push('p.ClinicNum = ?'); params.push(req.clinicNum); }
    if (req.dateFrom) { conditions.push('p.PayDate >= ?'); params.push(req.dateFrom); }
    if (req.dateTo) { conditions.push('p.PayDate < ?'); params.push(req.dateTo); }

    const where = conditions.length > 0 ? 'WHERE ' + conditions.join(' AND ') : '';

    const [countRows] = await conn.query<RowDataPacket[]>(
      `SELECT COUNT(*) AS cnt FROM payment p ${where}`, params
    );
    const totalCount = countRows[0].cnt as number;

    const [sumRows] = await conn.query<RowDataPacket[]>(
      `SELECT IFNULL(SUM(p.PayAmt), 0) AS total FROM payment p ${where}`, params
    );
    const totalAmount = Number(sumRows[0].total) || 0;

    const offset = (req.page - 1) * req.pageSize;
    const sqlParams = [...params, req.pageSize, offset];

    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT p.PayNum, p.PatNum,
              CONCAT(pat.LName, ', ', pat.FName) AS PatientName,
              p.ClinicNum, p.PayDate, p.PayAmt, p.PayType,
              def.ItemName AS PayTypeName,
              p.CheckNum, p.BankBranch, p.PayNote AS Note,
              0 AS ProvNum, '' AS ProvName,
              p.SecUserNumEntry, p.DateEntry
       FROM payment p
       LEFT JOIN patient pat ON p.PatNum = pat.PatNum
       LEFT JOIN definition def ON p.PayType = def.DefNum
       ${where}
       ORDER BY p.PayDate DESC
       LIMIT ? OFFSET ?`,
      sqlParams
    );

    return {
      payments: rows.map(mapPayment),
      totalCount,
      totalAmount,
    };
  } finally {
    conn.release();
  }
}

export async function getByIdAsync(payNum: number, allowedClinics: number[]): Promise<Payment | null> {
  const conn = await pool.getConnection();
  try {
    const clinicFilter = allowedClinics.length > 0
      ? `AND p.ClinicNum IN (${allowedClinics.map(() => '?').join(',')})` : '';
    const params: any[] = [payNum];
    if (allowedClinics.length > 0) params.push(...allowedClinics);

    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT p.PayNum, p.PatNum,
              CONCAT(pat.LName, ', ', pat.FName) AS PatientName,
              p.ClinicNum, p.PayDate, p.PayAmt, p.PayType,
              def.ItemName AS PayTypeName,
              p.CheckNum, p.BankBranch, p.PayNote AS Note,
              0 AS ProvNum, '' AS ProvName,
              p.SecUserNumEntry, p.DateEntry
       FROM payment p
       LEFT JOIN patient pat ON p.PatNum = pat.PatNum
       LEFT JOIN definition def ON p.PayType = def.DefNum
       WHERE p.PayNum = ? ${clinicFilter}`,
      params
    );

    if (rows.length === 0) return null;
    const payment = mapPayment(rows[0]);

    // Load splits
    const [splitRows] = await conn.query<RowDataPacket[]>(
      `SELECT ps.SplitNum, ps.PayNum, ps.PatNum, ps.ProvNum,
              ps.ClinicNum, ps.DatePay, ps.SplitAmt, ps.ProcNum,
              pc.ProcCode, pc.Descript AS ProcDescript
       FROM paysplit ps
       LEFT JOIN procedurelog pl ON ps.ProcNum = pl.ProcNum
       LEFT JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
       WHERE ps.PayNum = ?`,
      [payNum]
    );
    payment.splits = splitRows.map((r: any) => ({
      splitNum: r.SplitNum,
      payNum: r.PayNum,
      patNum: r.PatNum,
      provNum: r.ProvNum,
      clinicNum: r.ClinicNum,
      datePay: r.DatePay instanceof Date ? r.DatePay.toISOString() : r.DatePay,
      splitAmt: Number(r.SplitAmt) || 0,
      procNum: r.ProcNum,
      procCode: r.ProcCode,
      procDescript: r.ProcDescript,
    }));

    return payment;
  } finally {
    conn.release();
  }
}

export async function createAsync(req: PaymentCreateRequest, userId: number): Promise<number> {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [result] = await conn.query<ResultSetHeader>(
      `INSERT INTO payment (
        PatNum, ClinicNum, PayDate, PayAmt, PayType,
        CheckNum, PayNote, SecUserNumEntry, DateEntry
       ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())`,
      [req.PatNum, req.ClinicNum, req.PayDate, req.PayAmt, req.PayType,
       req.CheckNum || null, req.Note || null, userId]
    );
    const payNum = result.insertId;

    for (const split of req.Splits) {
      await conn.query(
        `INSERT INTO paysplit (PayNum, PatNum, ClinicNum, ProvNum, DatePay, SplitAmt, ProcNum)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [payNum, req.PatNum, req.ClinicNum, req.ProvNum,
         req.PayDate, split.SplitAmt, split.ProcNum]
      );
    }

    await conn.commit();
    return payNum;
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}
