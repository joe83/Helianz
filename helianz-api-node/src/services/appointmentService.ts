import { RowDataPacket, ResultSetHeader } from 'mysql2';
import pool from '../config/database';
import {
  Appointment, AppointmentSearchRequest, AppointmentSearchResult,
  AppointmentCreateRequest, AppointmentUpdateRequest,
} from '../models';

function mapAppointment(r: any): Appointment {
  return {
    aptNum: r.AptNum,
    patNum: r.PatNum,
    patientName: r.PatientName || '',
    aptStatus: r.AptStatus,
    clinicNum: r.ClinicNum,
    provNum: r.ProvNum,
    provHyg: r.ProvHyg,
    opNum: r.OpNum,
    opName: r.OpName,
    aptDateTime: r.AptDateTime instanceof Date ? r.AptDateTime.toISOString() : r.AptDateTime,
    length: r.Length || 0,
    pattern: r.Pattern,
    note: r.Note,
    confirmed: r.Confirmed,
    appointmentTypeNum: r.AppointmentTypeNum,
    appointmentTypeName: r.AppointmentTypeName,
    isNewPatient: !!r.IsNewPatient,
    isHygiene: !!r.IsHygiene,
    provName: r.ProvName,
    provHygName: r.ProvHygName,
    patientPhone: r.PatientPhone,
    dateTStamp: r.DateTStamp instanceof Date ? r.DateTStamp.toISOString() : r.DateTStamp,
  };
}

const BASE_SELECT = `
  SELECT a.AptNum, a.PatNum,
         CONCAT(p.LName, ', ', p.FName) AS PatientName,
         a.AptStatus, a.ClinicNum, a.ProvNum, a.ProvHyg,
         a.Op AS OpNum, o.OpName,
         a.AptDateTime, a.Pattern, 0 AS Length,
         a.Note, a.Confirmed, a.AppointmentTypeNum,
         at.AppointmentTypeName,
         a.IsNewPatient, a.IsHygiene, a.DateTStamp,
         prov.Abbr AS ProvName, provHyg.Abbr AS ProvHygName,
         p.WirelessPhone AS PatientPhone
  FROM appointment a
  LEFT JOIN patient p ON a.PatNum = p.PatNum
  LEFT JOIN provider prov ON a.ProvNum = prov.ProvNum
  LEFT JOIN provider provHyg ON a.ProvHyg = provHyg.ProvNum
  LEFT JOIN operatory o ON a.Op = o.OperatoryNum
  LEFT JOIN appointmenttype at ON a.AppointmentTypeNum = at.AppointmentTypeNum
`;

export async function searchAsync(req: AppointmentSearchRequest, allowedClinics: number[]): Promise<AppointmentSearchResult> {
  const conn = await pool.getConnection();
  try {
    const conditions: string[] = [];
    const params: any[] = [];

    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    if (effectiveClinics.length > 0) {
      conditions.push(`a.ClinicNum IN (${effectiveClinics.map(() => '?').join(',')})`);
      params.push(...effectiveClinics);
    }
    if (req.dateFrom) { conditions.push('a.AptDateTime >= ?'); params.push(req.dateFrom); }
    if (req.dateTo) { conditions.push('a.AptDateTime < ?'); params.push(req.dateTo); }
    if (req.provNum) { conditions.push('(a.ProvNum = ? OR a.ProvHyg = ?)'); params.push(req.provNum, req.provNum); }
    if (req.clinicNum) { conditions.push('a.ClinicNum = ?'); params.push(req.clinicNum); }
    if (req.patNum) { conditions.push('a.PatNum = ?'); params.push(req.patNum); }
    if (req.aptStatus !== undefined && req.aptStatus !== null) { conditions.push('a.AptStatus = ?'); params.push(req.aptStatus); }

    const where = conditions.length > 0 ? 'WHERE ' + conditions.join(' AND ') : '';

    const [countRows] = await conn.query<RowDataPacket[]>(
      `SELECT COUNT(*) AS cnt FROM appointment a ${where}`, params
    );
    const totalCount = countRows[0].cnt as number;

    const offset = (req.page - 1) * req.pageSize;
    const sqlParams = [...params, req.pageSize, offset];

    const [rows] = await conn.query<RowDataPacket[]>(
      `${BASE_SELECT} ${where} ORDER BY a.AptDateTime DESC LIMIT ? OFFSET ?`,
      sqlParams
    );

    return {
      appointments: rows.map(mapAppointment),
      totalCount,
    };
  } finally {
    conn.release();
  }
}

export async function getByIdAsync(aptNum: number, allowedClinics: number[]): Promise<Appointment | null> {
  const conn = await pool.getConnection();
  try {
    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    const clinicFilter = effectiveClinics.length > 0
      ? `AND a.ClinicNum IN (${effectiveClinics.map(() => '?').join(',')})` : '';
    const params: any[] = [aptNum];
    if (effectiveClinics.length > 0) params.push(...effectiveClinics);

    const [rows] = await conn.query<RowDataPacket[]>(
      `${BASE_SELECT} WHERE a.AptNum = ? ${clinicFilter}`, params
    );
    return rows.length > 0 ? mapAppointment(rows[0]) : null;
  } finally {
    conn.release();
  }
}

export async function createAsync(req: AppointmentCreateRequest): Promise<number> {
  const conn = await pool.getConnection();
  try {
    const [result] = await conn.query<ResultSetHeader>(
      `INSERT INTO appointment (
        PatNum, AptStatus, ClinicNum, ProvNum, ProvHyg,
        Op, AptDateTime, Pattern, Note, Confirmed, AppointmentTypeNum,
        IsNewPatient, IsHygiene, DateTStamp
       ) VALUES (?, 1, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?, ?, NOW())`,
      [req.PatNum, req.ClinicNum, req.ProvNum, req.ProvHyg,
       req.OpNum, req.AptDateTime, req.Pattern || '/X/', req.Note || null,
       req.AppointmentTypeNum, req.IsNewPatient, req.IsHygiene]
    );
    return result.insertId;
  } finally {
    conn.release();
  }
}

export async function updateAsync(aptNum: number, req: AppointmentUpdateRequest, allowedClinics: number[]): Promise<boolean> {
  const conn = await pool.getConnection();
  try {
    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    const clinicFilter = effectiveClinics.length > 0
      ? `AND ClinicNum IN (${effectiveClinics.map(() => '?').join(',')})` : '';

    const params: any[] = [
      req.PatNum, req.AptStatus, req.ClinicNum, req.ProvNum, req.ProvHyg,
      req.OpNum, req.AptDateTime, req.Pattern || '/X/', req.Note || null,
      req.Confirmed, req.AppointmentTypeNum, req.IsNewPatient, req.IsHygiene,
      aptNum,
    ];
    if (effectiveClinics.length > 0) params.push(...effectiveClinics);

    const [result] = await conn.query<ResultSetHeader>(
      `UPDATE appointment SET
        PatNum = ?, AptStatus = ?, ClinicNum = ?, ProvNum = ?, ProvHyg = ?,
        Op = ?, AptDateTime = ?, Pattern = ?, Note = ?,
        Confirmed = ?, AppointmentTypeNum = ?,
        IsNewPatient = ?, IsHygiene = ?
       WHERE AptNum = ? ${clinicFilter}`,
      params
    );
    return result.affectedRows > 0;
  } finally {
    conn.release();
  }
}

export async function setCompleteAsync(aptNum: number, allowedClinics: number[]): Promise<boolean> {
  const conn = await pool.getConnection();
  try {
    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    const clinicFilter = effectiveClinics.length > 0
      ? `AND ClinicNum IN (${effectiveClinics.map(() => '?').join(',')})` : '';
    const params: any[] = [aptNum];
    if (effectiveClinics.length > 0) params.push(...effectiveClinics);

    const [result] = await conn.query<ResultSetHeader>(
      `UPDATE appointment SET AptStatus = 2 WHERE AptNum = ? ${clinicFilter}`, params
    );
    return result.affectedRows > 0;
  } finally {
    conn.release();
  }
}

export async function getTodayAsync(
  clinicNum: number | null, provNum: number | null, allowedClinics: number[]
): Promise<Appointment[]> {
  const conn = await pool.getConnection();
  try {
    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    const conditions: string[] = ['a.AptDateTime >= CURDATE()', 'a.AptDateTime < DATE_ADD(CURDATE(), INTERVAL 1 DAY)'];
    const params: any[] = [];

    if (effectiveClinics.length > 0) {
      conditions.push(`a.ClinicNum IN (${effectiveClinics.map(() => '?').join(',')})`);
      params.push(...effectiveClinics);
    }
    if (clinicNum) { conditions.push('a.ClinicNum = ?'); params.push(clinicNum); }
    if (provNum) { conditions.push('(a.ProvNum = ? OR a.ProvHyg = ?)'); params.push(provNum, provNum); }

    const [rows] = await conn.query<RowDataPacket[]>(
      `${BASE_SELECT} WHERE ${conditions.join(' AND ')} ORDER BY a.AptDateTime`,
      params
    );
    return rows.map(mapAppointment);
  } finally {
    conn.release();
  }
}
