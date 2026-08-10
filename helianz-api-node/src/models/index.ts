// ── Patient ──────────────────────────────────────────
export interface Patient {
  patNum: number;
  lName: string;
  fName: string;
  middleI?: string | null;
  preferred?: string | null;
  gender: number;           // 0=Male, 1=Female, 2=Unknown
  birthdate: string;        // ISO date
  ssn?: string | null;      // NIK for Indonesia
  address?: string | null;
  address2?: string | null;
  city?: string | null;
  state?: string | null;
  zip?: string | null;
  hmPhone?: string | null;
  wkPhone?: string | null;
  wirelessPhone?: string | null;
  email?: string | null;
  clinicNum: number;
  patientStatus: number;    // 0=Patient, 1=NonPatient
  dateFirstVisit: string;
  priProv: number;
  chartNumber?: string | null;
  medicalUrgency?: string | null;
  country?: string | null;
  hasIns: boolean;
  balanceTotal: number;
  insEstTotal: number;
}

export interface PatientSearchRequest {
  query?: string | null;
  clinicNum?: number | null;
  page: number;
  pageSize: number;
}

export interface PatientSearchResult {
  patients: Patient[];
  totalCount: number;
  page: number;
  pageSize: number;
}

export interface PatientCreateRequest {
  LName: string;
  FName: string;
  MiddleI?: string | null;
  Preferred?: string | null;
  Gender: number;
  Birthdate: string;
  SSN?: string | null;
  Address?: string | null;
  Address2?: string | null;
  City?: string | null;
  State?: string | null;
  Zip?: string | null;
  HmPhone?: string | null;
  WkPhone?: string | null;
  WirelessPhone?: string | null;
  Email?: string | null;
  ClinicNum: number;
  PriProv?: number;
  ChartNumber?: string | null;
  Country?: string | null;
}

export interface PatientUpdateRequest extends Partial<PatientCreateRequest> {}

// ── Appointment ──────────────────────────────────────
export interface Appointment {
  aptNum: number;
  patNum: number;
  patientName: string;
  aptStatus: number;        // 1=Scheduled, 2=Complete, 3=UnschedList
  clinicNum: number;
  provNum: number;
  provHyg: number;
  opNum: number;
  opName?: string | null;
  aptDateTime: string;
  length: number;
  pattern?: string | null;
  note?: string | null;
  confirmed: number;
  appointmentTypeNum: number;
  appointmentTypeName?: string | null;
  isNewPatient: boolean;
  isHygiene: boolean;
  provName?: string | null;
  provHygName?: string | null;
  patientPhone?: string | null;
  dateTStamp: string;
}

export interface AppointmentSearchRequest {
  dateFrom?: string | null;
  dateTo?: string | null;
  provNum?: number | null;
  clinicNum?: number | null;
  patNum?: number | null;
  aptStatus?: number | null;
  page: number;
  pageSize: number;
}

export interface AppointmentSearchResult {
  appointments: Appointment[];
  totalCount: number;
}

export interface AppointmentCreateRequest {
  PatNum: number;
  ClinicNum: number;
  ProvNum: number;
  ProvHyg: number;
  OpNum: number;
  AptDateTime: string;
  Length: number;
  Pattern?: string | null;
  Note?: string | null;
  AppointmentTypeNum: number;
  IsNewPatient: boolean;
  IsHygiene: boolean;
}

export interface AppointmentUpdateRequest extends AppointmentCreateRequest {
  AptStatus: number;
  Confirmed: number;
}

// ── Procedure ────────────────────────────────────────
export interface Procedure {
  procNum: number;
  patNum: number;
  patientName: string;
  clinicNum: number;
  provNum: number;
  provName?: string | null;
  codeNum: string;
  procCode?: string | null;
  descript?: string | null;
  toothNum?: string | null;
  surf?: string | null;
  procStatus: number;
  procDate: string;
  dateEntryC: string;
  procFee: number;
  priority: number;
  note?: string | null;
  aptNum: number;
  dxNum: number;
  medicalOrderCodeNum: number;
  procStatusName?: string | null;
}

export interface ToothProcedure {
  toothNum: string;
  procedures: Procedure[];
}

export interface ToothChart {
  patNum: number;
  patientName: string;
  teeth: ToothProcedure[];
}

export interface ProcedureSearchRequest {
  patNum?: number | null;
  clinicNum?: number | null;
  provNum?: number | null;
  dateFrom?: string | null;
  dateTo?: string | null;
  procStatus?: number | null;
  page: number;
  pageSize: number;
}

export interface ProcedureSearchResult {
  procedures: Procedure[];
  totalCount: number;
}

export interface ProcedureCreateRequest {
  PatNum: number;
  ClinicNum: number;
  ProvNum: number;
  CodeNum: string;
  ToothNum?: string | null;
  Surf?: string | null;
  ProcStatus: number;
  ProcDate: string;
  ProcFee: number;
  Priority: number;
  Note?: string | null;
  AptNum: number;
  DxNum: number;
}

// ── Payment ──────────────────────────────────────────
export interface PaySplit {
  splitNum: number;
  payNum: number;
  patNum: number;
  provNum: number;
  clinicNum: number;
  datePay: string;
  splitAmt: number;
  procNum: number;
  procCode?: string | null;
  procDescript?: string | null;
}

export interface Payment {
  payNum: number;
  patNum: number;
  patientName: string;
  clinicNum: number;
  payDate: string;
  payAmt: number;
  payType: number;
  payTypeName?: string | null;
  checkNum?: string | null;
  bankBranch?: string | null;
  note?: string | null;
  provNum: number;
  provName?: string | null;
  secUserNumEntry: number;
  dateEntry: string;
  payGroupNum: number;
  splits: PaySplit[];
}

export interface PaymentSearchRequest {
  patNum?: number | null;
  clinicNum?: number | null;
  dateFrom?: string | null;
  dateTo?: string | null;
  page: number;
  pageSize: number;
}

export interface PaymentSearchResult {
  payments: Payment[];
  totalCount: number;
  totalAmount: number;
}

export interface PaySplitRequest {
  ProcNum: number;
  SplitAmt: number;
}

export interface PaymentCreateRequest {
  PatNum: number;
  ClinicNum: number;
  PayDate: string;
  PayAmt: number;
  PayType: number;
  CheckNum?: string | null;
  Note?: string | null;
  ProvNum: number;
  Splits: PaySplitRequest[];
}

// ── Prescription ─────────────────────────────────────
export interface Prescription {
  rxNum: number;
  patNum: number;
  patientName: string;
  clinicNum: number;
  provNum: number;
  provName?: string | null;
  drug: string;
  sig?: string | null;
  disp?: string | null;
  refills?: string | null;
  note?: string | null;
  rxDate: string;
  isControlled: boolean;
  pharmacyNum: number;
  pharmacyName?: string | null;
  dateTStamp: string;
}

export interface PrescriptionSearchRequest {
  patNum?: number | null;
  clinicNum?: number | null;
  dateFrom?: string | null;
  dateTo?: string | null;
  page: number;
  pageSize: number;
}

export interface PrescriptionSearchResult {
  prescriptions: Prescription[];
  totalCount: number;
}

export interface PrescriptionCreateRequest {
  PatNum: number;
  ClinicNum: number;
  ProvNum: number;
  Drug: string;
  Sig?: string | null;
  Disp?: string | null;
  Refills?: string | null;
  Note?: string | null;
  PharmacyNum: number;
  IsControlled: boolean;
}

// ── Clinical Note ────────────────────────────────────
export interface ClinicalNote {
  commlogNum: number;
  patNum: number;
  patientName: string;
  clinicNum: number;
  provNum: number;
  provName?: string | null;
  commDateTime: string;
  commType: number;
  commTypeName?: string | null;
  note?: string | null;
  userNum: number;
  userName?: string | null;
  dateTStamp: string;
  aptNum: number;
}

export interface NoteSearchRequest {
  patNum?: number | null;
  clinicNum?: number | null;
  dateFrom?: string | null;
  dateTo?: string | null;
  page: number;
  pageSize: number;
}

export interface NoteSearchResult {
  notes: ClinicalNote[];
  totalCount: number;
}

export interface NoteCreateRequest {
  PatNum: number;
  ClinicNum: number;
  ProvNum: number;
  CommType: number;
  Note: string;
  AptNum: number;
}

// ── Reference Data ───────────────────────────────────
export interface Provider {
  provNum: number;
  abbr: string;
  fName: string;
  lName: string;
  clinicNum: number;
  isHidden: boolean;
  isSecondary: boolean;
  specialty?: string | null;
}

export interface Operatory {
  operatoryNum: number;
  opName: string;
  clinicNum: number;
  provDentist: number;
  provHygienist: number;
  isHidden: boolean;
  setOrder: number;
}

export interface ProcedureCode {
  codeNum: number;
  procCode: string;
  descript: string;
  abbrDesc?: string | null;
  procCat: number;
  procCatName?: string | null;
  procFee: number;
  isHygiene: boolean;
  paintType?: string | null;
  treatmentArea?: string | null;
}

export interface AppointmentType {
  appointmentTypeNum: number;
  appointmentTypeName: string;
  pattern?: string | null;
  codeStr?: string | null;
  codeStrRequired?: string | null;
  length: number;
}

export interface Definition {
  defNum: number;
  itemName: string;
  category: number;
  itemOrder: number;
}

export interface ClinicInfo {
  clinicNum: number;
  description: string;
  address?: string | null;
  city?: string | null;
  phone?: string | null;
  isHidden: boolean;
}

export interface ReferenceData {
  providers: Provider[];
  operatories: Operatory[];
  procedureCodes: ProcedureCode[];
  appointmentTypes: AppointmentType[];
  paymentTypes: Definition[];
  commTypes: Definition[];
  clinics: ClinicInfo[];
}

// ── Auth ─────────────────────────────────────────────
export interface LoginRequest {
  Username: string;
  Password: string;
}

export interface UserPermission {
  permType: number;
  name: string;
  fKey: number;
  newerDate: string;
  newerDays: number;
}

export interface LoginResponse {
  token: string;
  displayName: string;
  userNum: number;
  clinicNum: number;
  clinicNums: number[];
  userGroupNums: number[];
  permissions: UserPermission[];
}

// ── JWT Payload ──────────────────────────────────────
export interface JwtPayload {
  sub: string;        // UserNum
  name: string;       // UserName
  ClinicNum: string[]; // clinic access list
  UserGroupNum: string[];
  [key: `Perm_${number}`]: string; // permission claims
  iat: number;
  exp: number;
}
