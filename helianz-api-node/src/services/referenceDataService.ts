import { RowDataPacket } from 'mysql2';
import pool from '../config/database';
import {
  Provider, Operatory, ProcedureCode, AppointmentType,
  Definition, ClinicInfo, ReferenceData,
} from '../models';

function mapProvider(r: any): Provider {
  return {
    provNum: r.ProvNum,
    abbr: r.Abbr,
    fName: r.FName,
    lName: r.LName,
    clinicNum: r.ClinicNum || 0,
    isHidden: !!r.IsHidden,
    isSecondary: !!r.IsSecondary,
    specialty: r.Specialty,
  };
}

function mapOperatory(r: any): Operatory {
  return {
    operatoryNum: r.OperatoryNum,
    opName: r.OpName,
    clinicNum: r.ClinicNum,
    provDentist: r.ProvDentist,
    provHygienist: r.ProvHygienist,
    isHidden: !!r.IsHidden,
    setOrder: r.SetOrder || r.ItemOrder || 0,
  };
}

function mapProcCode(r: any): ProcedureCode {
  return {
    codeNum: r.CodeNum,
    procCode: r.ProcCode,
    descript: r.Descript,
    abbrDesc: r.AbbrDesc,
    procCat: r.ProcCat,
    procCatName: r.ProcCatName,
    procFee: 0,
    isHygiene: !!r.IsHygiene,
    paintType: r.PaintType,
    treatmentArea: r.TreatmentArea || '',
  };
}

function mapApptType(r: any): AppointmentType {
  return {
    appointmentTypeNum: r.AppointmentTypeNum,
    appointmentTypeName: r.AppointmentTypeName,
    pattern: r.Pattern,
    codeStr: r.CodeStr,
    codeStrRequired: r.CodeStrRequired,
    length: r.Length || 0,
  };
}

function mapDef(r: any): Definition {
  return {
    defNum: r.DefNum,
    itemName: r.ItemName,
    category: r.Category,
    itemOrder: r.ItemOrder,
  };
}

function mapClinic(r: any): ClinicInfo {
  return {
    clinicNum: r.ClinicNum,
    description: r.Description,
    address: r.Address,
    city: r.City,
    phone: r.Phone,
    isHidden: !!r.IsHidden,
  };
}

export async function getAllAsync(_clinicNum: number): Promise<ReferenceData> {
  const conn = await pool.getConnection();
  try {
    const [providers] = await conn.query<RowDataPacket[]>(
      `SELECT ProvNum, Abbr, FName, LName, 0 AS ClinicNum, IsHidden, IsSecondary, Specialty
       FROM provider WHERE IsHidden = 0 ORDER BY LName`
    );

    const [operatories] = await conn.query<RowDataPacket[]>(
      `SELECT OperatoryNum, OpName, ClinicNum, ProvDentist, ProvHygienist, IsHidden, ItemOrder AS SetOrder
       FROM operatory WHERE IsHidden = 0 ORDER BY ItemOrder`
    );

    const [procedureCodes] = await conn.query<RowDataPacket[]>(
      `SELECT pc.CodeNum, pc.ProcCode, pc.Descript, pc.AbbrDesc,
              pc.ProcCat, def.ItemName AS ProcCatName, 0 AS ProcFee,
              pc.IsHygiene, pc.PaintType, '' AS TreatmentArea
       FROM procedurecode pc
       LEFT JOIN definition def ON pc.ProcCat = def.DefNum
       ORDER BY pc.ProcCode`
    );

    const [appointmentTypes] = await conn.query<RowDataPacket[]>(
      `SELECT AppointmentTypeNum, AppointmentTypeName, Pattern,
              CodeStr, CodeStrRequired, 0 AS Length
       FROM appointmenttype ORDER BY AppointmentTypeName`
    );

    const [paymentTypes] = await conn.query<RowDataPacket[]>(
      `SELECT DefNum, ItemName, Category, ItemOrder
       FROM definition WHERE Category = 3 ORDER BY ItemOrder`
    );

    const [commTypes] = await conn.query<RowDataPacket[]>(
      `SELECT DefNum, ItemName, Category, ItemOrder
       FROM definition WHERE Category = 2 ORDER BY ItemOrder`
    );

    const [clinics] = await conn.query<RowDataPacket[]>(
      `SELECT ClinicNum, Description, Address, City, Phone, IsHidden
       FROM clinic WHERE IsHidden = 0 ORDER BY Description`
    );

    return {
      providers: providers.map(mapProvider),
      operatories: operatories.map(mapOperatory),
      procedureCodes: procedureCodes.map(mapProcCode),
      appointmentTypes: appointmentTypes.map(mapApptType),
      paymentTypes: paymentTypes.map(mapDef),
      commTypes: commTypes.map(mapDef),
      clinics: clinics.map(mapClinic),
    };
  } finally {
    conn.release();
  }
}
