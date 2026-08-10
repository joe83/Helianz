import { RowDataPacket, ResultSetHeader } from 'mysql2';
import pool from '../config/database';
import {
  Prescription, PrescriptionSearchRequest, PrescriptionSearchResult,
  PrescriptionCreateRequest,
} from '../models';

function mapPrescription(r: any): Prescription {
  return {
    rxNum: r.RxNum,
    patNum: r.PatNum,
    patientName: r.PatientName || '',
    clinicNum: r.ClinicNum,
    provNum: r.ProvNum,
    provName: r.ProvName,
    drug: r.Drug || '',
    sig: r.Sig,
    disp: r.Disp,
    refills: r.Refills,
    note: r.Note,
    rxDate: r.RxDate instanceof Date ? r.RxDate.toISOString().substring(0, 10) : r.RxDate,
    isControlled: !!r.IsControlled,
    pharmacyNum: r.PharmacyNum,
    pharmacyName: r.PharmacyName,
    dateTStamp: r.DateTStamp instanceof Date ? r.DateTStamp.toISOString() : r.DateTStamp,
  };
}

export async function searchAsync(req: PrescriptionSearchRequest, allowedClinics: number[]): Promise<PrescriptionSearchResult> {
  const conn = await pool.getConnection();
  try {
    const conditions: string[] = [];
    const params: any[] = [];

    if (allowedClinics.length > 0) {
      conditions.push(`rx.ClinicNum IN (${allowedClinics.map(() => '?').join(',')})`);
      params.push(...allowedClinics);
    }
    if (req.patNum) { conditions.push('rx.PatNum = ?'); params.push(req.patNum); }
    if (req.clinicNum) { conditions.push('rx.ClinicNum = ?'); params.push(req.clinicNum); }
    if (req.dateFrom) { conditions.push('rx.RxDate >= ?'); params.push(req.dateFrom); }
    if (req.dateTo) { conditions.push('rx.RxDate < ?'); params.push(req.dateTo); }

    const where = conditions.length > 0 ? 'WHERE ' + conditions.join(' AND ') : '';

    const [countRows] = await conn.query<RowDataPacket[]>(
      `SELECT COUNT(*) AS cnt FROM rxpat rx ${where}`, params
    );
    const totalCount = countRows[0].cnt as number;

    const offset = (req.page - 1) * req.pageSize;
    const sqlParams = [...params, req.pageSize, offset];

    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT rx.RxNum, rx.PatNum,
              CONCAT(p.LName, ', ', p.FName) AS PatientName,
              rx.ClinicNum, rx.ProvNum, prov.Abbr AS ProvName,
              rx.Drug, rx.Sig, rx.Disp, rx.Refills, rx.Notes AS Note,
              rx.RxDate, rx.IsControlled,
              rx.PharmacyNum, ph.StoreName AS PharmacyName,
              rx.DateTStamp
       FROM rxpat rx
       LEFT JOIN patient p ON rx.PatNum = p.PatNum
       LEFT JOIN provider prov ON rx.ProvNum = prov.ProvNum
       LEFT JOIN pharmacy ph ON rx.PharmacyNum = ph.PharmacyNum
       ${where}
       ORDER BY rx.RxDate DESC
       LIMIT ? OFFSET ?`,
      sqlParams
    );

    return { prescriptions: rows.map(mapPrescription), totalCount };
  } finally {
    conn.release();
  }
}

export async function getByIdAsync(rxNum: number, allowedClinics: number[]): Promise<Prescription | null> {
  const conn = await pool.getConnection();
  try {
    const clinicFilter = allowedClinics.length > 0
      ? `AND rx.ClinicNum IN (${allowedClinics.map(() => '?').join(',')})` : '';
    const params: any[] = [rxNum];
    if (allowedClinics.length > 0) params.push(...allowedClinics);

    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT rx.RxNum, rx.PatNum,
              CONCAT(p.LName, ', ', p.FName) AS PatientName,
              rx.ClinicNum, rx.ProvNum, prov.Abbr AS ProvName,
              rx.Drug, rx.Sig, rx.Disp, rx.Refills, rx.Notes AS Note,
              rx.RxDate, rx.IsControlled,
              rx.PharmacyNum, ph.StoreName AS PharmacyName,
              rx.DateTStamp
       FROM rxpat rx
       LEFT JOIN patient p ON rx.PatNum = p.PatNum
       LEFT JOIN provider prov ON rx.ProvNum = prov.ProvNum
       LEFT JOIN pharmacy ph ON rx.PharmacyNum = ph.PharmacyNum
       WHERE rx.RxNum = ? ${clinicFilter}`,
      params
    );
    return rows.length > 0 ? mapPrescription(rows[0]) : null;
  } finally {
    conn.release();
  }
}

export async function createAsync(req: PrescriptionCreateRequest): Promise<number> {
  const conn = await pool.getConnection();
  try {
    const [result] = await conn.query<ResultSetHeader>(
      `INSERT INTO rxpat (
        PatNum, ClinicNum, ProvNum, Drug, Sig, Disp, Refills,
        Notes, RxDate, IsControlled, PharmacyNum, DateTStamp
       ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURDATE(), ?, ?, NOW())`,
      [req.PatNum, req.ClinicNum, req.ProvNum, req.Drug,
       req.Sig || null, req.Disp || null, req.Refills || null,
       req.Note || null, req.IsControlled, req.PharmacyNum]
    );
    return result.insertId;
  } finally {
    conn.release();
  }
}
