import { RowDataPacket, ResultSetHeader } from 'mysql2';
import pool from '../config/database';
import { ClinicalNote, NoteSearchRequest, NoteSearchResult, NoteCreateRequest } from '../models';

function mapNote(r: any): ClinicalNote {
  return {
    commlogNum: r.CommlogNum,
    patNum: r.PatNum,
    patientName: r.PatientName || '',
    clinicNum: r.ClinicNum || 0,
    provNum: r.ProvNum || 0,
    provName: r.ProvName || '',
    commDateTime: r.CommDateTime instanceof Date ? r.CommDateTime.toISOString() : r.CommDateTime,
    commType: r.CommType,
    commTypeName: r.CommTypeName,
    note: r.Note,
    userNum: r.UserNum,
    userName: r.UserName,
    dateTStamp: r.DateTStamp instanceof Date ? r.DateTStamp.toISOString() : r.DateTStamp,
    aptNum: r.AptNum || 0,
  };
}

export async function searchAsync(req: NoteSearchRequest, _allowedClinics: number[]): Promise<NoteSearchResult> {
  const conn = await pool.getConnection();
  try {
    // commlog has no ClinicNum — filter by patient/dates only
    const conditions: string[] = [];
    const params: any[] = [];

    if (req.patNum) { conditions.push('c.PatNum = ?'); params.push(req.patNum); }
    if (req.dateFrom) { conditions.push('c.CommDateTime >= ?'); params.push(req.dateFrom); }
    if (req.dateTo) { conditions.push('c.CommDateTime < ?'); params.push(req.dateTo); }

    const where = conditions.length > 0 ? 'WHERE ' + conditions.join(' AND ') : '';

    const [countRows] = await conn.query<RowDataPacket[]>(
      `SELECT COUNT(*) AS cnt FROM commlog c ${where}`, params
    );
    const totalCount = countRows[0].cnt as number;

    const offset = (req.page - 1) * req.pageSize;
    const sqlParams = [...params, req.pageSize, offset];

    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT c.CommlogNum, c.PatNum,
              CONCAT(p.LName, ', ', p.FName) AS PatientName,
              0 AS ClinicNum, 0 AS ProvNum, '' AS ProvName,
              c.CommDateTime, c.CommType,
              def.ItemName AS CommTypeName,
              c.Note, c.UserNum, u.UserName,
              c.DateTStamp, 0 AS AptNum
       FROM commlog c
       LEFT JOIN patient p ON c.PatNum = p.PatNum
       LEFT JOIN definition def ON c.CommType = def.DefNum
       LEFT JOIN userod u ON c.UserNum = u.UserNum
       ${where}
       ORDER BY c.CommDateTime DESC
       LIMIT ? OFFSET ?`,
      sqlParams
    );

    return { notes: rows.map(mapNote), totalCount };
  } finally {
    conn.release();
  }
}

export async function getByIdAsync(commlogNum: number, _allowedClinics: number[]): Promise<ClinicalNote | null> {
  const conn = await pool.getConnection();
  try {
    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT c.CommlogNum, c.PatNum,
              CONCAT(p.LName, ', ', p.FName) AS PatientName,
              0 AS ClinicNum, 0 AS ProvNum, '' AS ProvName,
              c.CommDateTime, c.CommType,
              def.ItemName AS CommTypeName,
              c.Note, c.UserNum, u.UserName,
              c.DateTStamp, 0 AS AptNum
       FROM commlog c
       LEFT JOIN patient p ON c.PatNum = p.PatNum
       LEFT JOIN definition def ON c.CommType = def.DefNum
       LEFT JOIN userod u ON c.UserNum = u.UserNum
       WHERE c.CommlogNum = ?`,
      [commlogNum]
    );
    return rows.length > 0 ? mapNote(rows[0]) : null;
  } finally {
    conn.release();
  }
}

export async function createAsync(req: NoteCreateRequest, userId: number): Promise<number> {
  const conn = await pool.getConnection();
  try {
    const [result] = await conn.query<ResultSetHeader>(
      `INSERT INTO commlog (PatNum, CommDateTime, CommType, Note, UserNum, DateTStamp)
       VALUES (?, NOW(), ?, ?, ?, NOW())`,
      [req.PatNum, req.CommType, req.Note, userId]
    );
    return result.insertId;
  } finally {
    conn.release();
  }
}
