import { RowDataPacket, ResultSetHeader } from 'mysql2';
import pool from '../config/database';
import {
  Patient, PatientSearchRequest, PatientSearchResult,
  PatientCreateRequest, PatientUpdateRequest,
} from '../models';

export async function searchAsync(req: PatientSearchRequest, allowedClinics: number[]): Promise<PatientSearchResult> {
  const conn = await pool.getConnection();
  try {
    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    const clinicFilter = effectiveClinics.length > 0
      ? 'AND p.ClinicNum IN (' + effectiveClinics.map(() => '?').join(',') + ')'
      : '';

    const hasQuery = req.query && req.query.trim().length > 0;
    const searchFilter = hasQuery
      ? `AND (p.LName LIKE ?
            OR p.FName LIKE ?
            OR p.WirelessPhone LIKE ?
            OR p.ChartNumber LIKE ?
            OR p.SSN LIKE ?)`
      : '';

    const queryParam = hasQuery ? `%${req.query!.trim()}%` : '%';

    const params: any[] = [];
    if (effectiveClinics.length > 0) params.push(...effectiveClinics);
    const countParams = [...params];
    if (hasQuery) countParams.push(queryParam, queryParam, queryParam, queryParam, queryParam);

    const [countRows] = await conn.query<RowDataPacket[]>(
      `SELECT COUNT(*) AS cnt FROM patient p WHERE p.PatStatus IN (0, 1) ${clinicFilter} ${searchFilter}`,
      countParams
    );
    const totalCount = countRows[0].cnt as number;

    const offset = (req.page - 1) * req.pageSize;
    const sqlParams = [...params];
    if (hasQuery) sqlParams.push(queryParam, queryParam, queryParam, queryParam, queryParam);
    sqlParams.push(req.pageSize, offset);

    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT p.PatNum, p.LName, p.FName, p.MiddleI, p.Preferred,
              p.Gender, p.Birthdate, p.SSN,
              p.Address, p.Address2, p.City, p.State, p.Zip,
              p.HmPhone, p.WkPhone, p.WirelessPhone, p.Email,
              p.ClinicNum, p.PatStatus AS PatientStatus,
              p.DateFirstVisit, p.PriProv, p.ChartNumber,
              p.Country,
              0 AS BalanceTotal, 0 AS InsEstTotal, 0 AS HasIns
       FROM patient p
       WHERE p.PatStatus IN (0, 1) ${clinicFilter} ${searchFilter}
       ORDER BY p.LName, p.FName
       LIMIT ? OFFSET ?`,
      sqlParams
    );

    return {
      patients: rows.map(mapPatient),
      totalCount,
      page: req.page,
      pageSize: req.pageSize,
    };
  } finally {
    conn.release();
  }
}

export async function getByIdAsync(patNum: number, allowedClinics: number[]): Promise<Patient | null> {
  const conn = await pool.getConnection();
  try {
    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    const clinicFilter = effectiveClinics.length > 0
      ? 'AND p.ClinicNum IN (' + effectiveClinics.map(() => '?').join(',') + ')'
      : '';

    const params: any[] = [patNum];
    if (effectiveClinics.length > 0) params.push(...effectiveClinics);

    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT p.PatNum, p.LName, p.FName, p.MiddleI, p.Preferred,
              p.Gender, p.Birthdate, p.SSN,
              p.Address, p.Address2, p.City, p.State, p.Zip,
              p.HmPhone, p.WkPhone, p.WirelessPhone, p.Email,
              p.ClinicNum, p.PatStatus AS PatientStatus,
              p.DateFirstVisit, p.PriProv, p.ChartNumber,
              p.Country,
              0 AS BalanceTotal, 0 AS InsEstTotal, 0 AS HasIns
       FROM patient p
       WHERE p.PatNum = ? ${clinicFilter}`,
      params
    );

    return rows.length > 0 ? mapPatient(rows[0]) : null;
  } finally {
    conn.release();
  }
}

export async function createAsync(req: PatientCreateRequest): Promise<number> {
  const conn = await pool.getConnection();
  try {
    const [result] = await conn.query<ResultSetHeader>(
      `INSERT INTO patient (
        LName, FName, MiddleI, Preferred, Gender, Birthdate, SSN,
        Address, Address2, City, State, Zip,
        HmPhone, WkPhone, WirelessPhone, Email,
        ClinicNum, PatStatus, PriProv, ChartNumber, Country, DateFirstVisit
       ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?, ?, NOW())`,
      [
        req.LName, req.FName, req.MiddleI || null, req.Preferred || null,
        req.Gender, req.Birthdate, req.SSN || null,
        req.Address || null, req.Address2 || null, req.City || null,
        req.State || null, req.Zip || null,
        req.HmPhone || null, req.WkPhone || null, req.WirelessPhone || null,
        req.Email || null,
        req.ClinicNum, req.PriProv || 0, req.ChartNumber || null, req.Country || null,
      ]
    );
    return result.insertId;
  } finally {
    conn.release();
  }
}

export async function updateAsync(patNum: number, req: PatientUpdateRequest, allowedClinics: number[]): Promise<boolean> {
  const conn = await pool.getConnection();
  try {
    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    const clinicFilter = effectiveClinics.length > 0
      ? 'AND ClinicNum IN (' + effectiveClinics.map(() => '?').join(',') + ')'
      : '';

    const sets: string[] = [];
    const params: any[] = [];

    for (const [key, val] of Object.entries(req)) {
      if (val !== undefined) {
        sets.push(`${key} = ?`);
        params.push(val);
      }
    }
    if (sets.length === 0) return false;

    params.push(patNum);
    if (effectiveClinics.length > 0) params.push(...effectiveClinics);

    const [result] = await conn.query<ResultSetHeader>(
      `UPDATE patient SET ${sets.join(', ')} WHERE PatNum = ? ${clinicFilter}`,
      params
    );
    return result.affectedRows > 0;
  } finally {
    conn.release();
  }
}

function mapPatient(r: any): Patient {
  return {
    patNum: r.PatNum,
    lName: r.LName,
    fName: r.FName,
    middleI: r.MiddleI,
    preferred: r.Preferred,
    gender: r.Gender,
    birthdate: r.Birthdate instanceof Date ? r.Birthdate.toISOString().substring(0, 10) : r.Birthdate,
    ssn: r.SSN,
    address: r.Address,
    address2: r.Address2,
    city: r.City,
    state: r.State,
    zip: r.Zip,
    hmPhone: r.HmPhone,
    wkPhone: r.WkPhone,
    wirelessPhone: r.WirelessPhone,
    email: r.Email,
    clinicNum: r.ClinicNum,
    patientStatus: r.PatientStatus,
    dateFirstVisit: r.DateFirstVisit instanceof Date ? r.DateFirstVisit.toISOString() : r.DateFirstVisit,
    priProv: r.PriProv,
    chartNumber: r.ChartNumber,
    country: r.Country,
    hasIns: !!r.HasIns,
    balanceTotal: Number(r.BalanceTotal) || 0,
    insEstTotal: Number(r.InsEstTotal) || 0,
    medicalUrgency: r.MedicalUrgency,
  };
}
