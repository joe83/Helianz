import { RowDataPacket, ResultSetHeader } from 'mysql2';
import pool from '../config/database';
import {
  Procedure, ProcedureSearchRequest, ProcedureSearchResult,
  ToothChart, ToothProcedure, ProcedureCreateRequest,
} from '../models';

function mapDate(d: any): string {
  if (d instanceof Date) return d.toISOString().substring(0, 10);
  return String(d || '');
}

function mapProcedure(r: any): Procedure {
  return {
    procNum: r.ProcNum,
    patNum: r.PatNum,
    patientName: r.PatientName || '',
    clinicNum: r.ClinicNum,
    provNum: r.ProvNum,
    provName: r.ProvName,
    codeNum: String(r.CodeNum || ''),
    procCode: r.ProcCode,
    descript: r.Descript,
    toothNum: r.ToothNum,
    surf: r.Surf,
    procStatus: r.ProcStatus,
    procDate: mapDate(r.ProcDate),
    dateEntryC: r.DateEntryC instanceof Date ? r.DateEntryC.toISOString() : r.DateEntryC,
    procFee: Number(r.ProcFee) || 0,
    priority: r.Priority || 0,
    note: r.Note,
    aptNum: r.AptNum || 0,
    dxNum: r.DxNum || 0,
    medicalOrderCodeNum: r.MedicalOrderCodeNum || 0,
    procStatusName: r.ProcStatusName,
  };
}

const STATUS_NAME_CASE = `
  CASE pl.ProcStatus
    WHEN 1 THEN 'Treatment Plan'
    WHEN 2 THEN 'Complete'
    WHEN 3 THEN 'Existing Current'
    WHEN 4 THEN 'Existing Other'
    WHEN 5 THEN 'Referred'
    WHEN 6 THEN 'Deleted'
    ELSE 'Unknown'
  END AS ProcStatusName
`;

export async function searchAsync(req: ProcedureSearchRequest, allowedClinics: number[]): Promise<ProcedureSearchResult> {
  const conn = await pool.getConnection();
  try {
    const conditions: string[] = [];
    const params: any[] = [];

    if (allowedClinics.length > 0) {
      conditions.push(`pl.ClinicNum IN (${allowedClinics.map(() => '?').join(',')})`);
      params.push(...allowedClinics);
    }
    if (req.patNum) { conditions.push('pl.PatNum = ?'); params.push(req.patNum); }
    if (req.clinicNum) { conditions.push('pl.ClinicNum = ?'); params.push(req.clinicNum); }
    if (req.provNum) { conditions.push('pl.ProvNum = ?'); params.push(req.provNum); }
    if (req.dateFrom) { conditions.push('pl.ProcDate >= ?'); params.push(req.dateFrom); }
    if (req.dateTo) { conditions.push('pl.ProcDate < ?'); params.push(req.dateTo); }
    if (req.procStatus !== undefined && req.procStatus !== null) {
      conditions.push('pl.ProcStatus = ?'); params.push(req.procStatus);
    }

    const where = conditions.length > 0 ? 'WHERE ' + conditions.join(' AND ') : '';

    const [countRows] = await conn.query<RowDataPacket[]>(
      `SELECT COUNT(*) AS cnt FROM procedurelog pl ${where}`, params
    );
    const totalCount = countRows[0].cnt as number;

    const offset = (req.page - 1) * req.pageSize;
    const sqlParams = [...params, req.pageSize, offset];

    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT pl.ProcNum, pl.PatNum,
              CONCAT(p.LName, ', ', p.FName) AS PatientName,
              pl.ClinicNum, pl.ProvNum, prov.Abbr AS ProvName,
              pl.CodeNum, pc.ProcCode, pc.Descript,
              pl.ToothNum, pl.Surf,
              pl.ProcStatus, pl.ProcDate, pl.DateEntryC,
              pl.ProcFee, pl.Priority, pl.ClaimNote AS Note,
              pl.AptNum, pl.Dx AS DxNum, 0 AS MedicalOrderCodeNum,
              ${STATUS_NAME_CASE}
       FROM procedurelog pl
       LEFT JOIN patient p ON pl.PatNum = p.PatNum
       LEFT JOIN provider prov ON pl.ProvNum = prov.ProvNum
       LEFT JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
       ${where}
       ORDER BY pl.ProcDate DESC, pl.ProcNum DESC
       LIMIT ? OFFSET ?`,
      sqlParams
    );

    return { procedures: rows.map(mapProcedure), totalCount };
  } finally {
    conn.release();
  }
}

export async function getToothChartAsync(patNum: number, allowedClinics: number[]): Promise<ToothChart> {
  const conn = await pool.getConnection();
  try {
    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    const clinicFilter = effectiveClinics.length > 0
      ? `AND pl.ClinicNum IN (${effectiveClinics.map(() => '?').join(',')})` : '';

    const [patRows] = await conn.query<RowDataPacket[]>(
      `SELECT CONCAT(LName, ', ', FName) AS name, PatNum FROM patient WHERE PatNum = ?`, [patNum]
    );
    if (patRows.length === 0) return { patNum: 0, patientName: '', teeth: [] };

    const params: any[] = [patNum];
    if (effectiveClinics.length > 0) params.push(...effectiveClinics);

    const [rows] = await conn.query<RowDataPacket[]>(
      `SELECT pl.ProcNum, pl.PatNum, '' AS PatientName,
              pl.ClinicNum, pl.ProvNum, prov.Abbr AS ProvName,
              pl.CodeNum, pc.ProcCode, pc.Descript,
              pl.ToothNum, pl.Surf,
              pl.ProcStatus, pl.ProcDate, pl.DateEntryC,
              pl.ProcFee, pl.Priority, pl.ClaimNote AS Note,
              pl.AptNum, pl.Dx, 0 AS MedicalOrderCodeNum,
              ${STATUS_NAME_CASE}
       FROM procedurelog pl
       LEFT JOIN provider prov ON pl.ProvNum = prov.ProvNum
       LEFT JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
       WHERE pl.PatNum = ? AND pl.ProcStatus IN (1,2,3,4) ${clinicFilter}
       ORDER BY pl.ToothNum, pl.ProcDate DESC`,
      params
    );

    const procedures = rows.map(mapProcedure);

    // Group by tooth number
    const toothMap = new Map<string, Procedure[]>();
    for (const p of procedures) {
      const key = p.toothNum || '';
      const arr = toothMap.get(key) || [];
      arr.push(p);
      toothMap.set(key, arr);
    }

    const teeth: ToothProcedure[] = Array.from(toothMap.entries())
      .map(([toothNum, procs]) => ({ toothNum, procedures: procs }))
      .sort((a, b) => a.toothNum.localeCompare(b.toothNum));

    return {
      patNum,
      patientName: patRows[0].name,
      teeth,
    };
  } finally {
    conn.release();
  }
}

export async function createAsync(req: ProcedureCreateRequest): Promise<number> {
  const conn = await pool.getConnection();
  try {
    const [result] = await conn.query<ResultSetHeader>(
      `INSERT INTO procedurelog (
        PatNum, ClinicNum, ProvNum, CodeNum, ToothNum, Surf,
        ProcStatus, ProcDate, ProcFee, Priority, Note, AptNum, DxNum, DateEntryC
       ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())`,
      [req.PatNum, req.ClinicNum, req.ProvNum, req.CodeNum,
       req.ToothNum || null, req.Surf || null, req.ProcStatus, req.ProcDate,
       req.ProcFee, req.Priority, req.Note || null, req.AptNum, req.DxNum]
    );
    return result.insertId;
  } finally {
    conn.release();
  }
}

export async function setCompleteAsync(procNum: number, allowedClinics: number[]): Promise<boolean> {
  const conn = await pool.getConnection();
  try {
    const effectiveClinics = allowedClinics.filter(c => c !== 0);
    const clinicFilter = effectiveClinics.length > 0
      ? `AND ClinicNum IN (${effectiveClinics.map(() => '?').join(',')})` : '';
    const params: any[] = [procNum];
    if (effectiveClinics.length > 0) params.push(...effectiveClinics);

    const [result] = await conn.query<ResultSetHeader>(
      `UPDATE procedurelog SET ProcStatus = 2 WHERE ProcNum = ? ${clinicFilter}`, params
    );
    return result.affectedRows > 0;
  } finally {
    conn.release();
  }
}
