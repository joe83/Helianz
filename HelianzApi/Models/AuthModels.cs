namespace HelianzApi.Models;

public class LoginRequest
{
    public string Username { get; set; } = "";
    public string Password { get; set; } = "";
}

public class LoginResponse
{
    public string Token { get; set; } = "";
    public string DisplayName { get; set; } = "";
    public long UserNum { get; set; }
    public long ClinicNum { get; set; }
    public List<long> ClinicNums { get; set; } = new();
    public List<long> UserGroupNums { get; set; } = new();
    public List<UserPermission> Permissions { get; set; } = new();
}

public class UserPermission
{
    /// <summary>EnumPermType numeric value matching Helianz desktop enum.</summary>
    public int PermType { get; set; }
    /// <summary>Display name of the permission.</summary>
    public string Name { get; set; } = "";
    /// <summary>FKey: 0=access to all items of this type, otherwise specific item ID (e.g. report DisplayReportNum).</summary>
    public long FKey { get; set; }
    /// <summary>Only granted if newer than this date (MinValue = no restriction).</summary>
    public DateTime NewerDate { get; set; }
    /// <summary>Only granted if item is newer than this many days (0 = no restriction).</summary>
    public int NewerDays { get; set; }
}

/// <summary>Maps to Helianz EnumPermType values from the desktop client.</summary>
public static class PermType
{
    public const int AppointmentsModule = 1;
    public const int FamilyModule = 2;
    public const int AccountModule = 3;
    public const int TPModule = 4;
    public const int ChartModule = 5;
    public const int ImagingModule = 6;
    public const int ManageModule = 7;
    public const int Setup = 8;
    public const int RxCreate = 9;
    public const int ProcComplEdit = 10;
    public const int Schedules = 12;
    public const int Blockouts = 13;
    public const int ClaimSentEdit = 14;
    public const int PaymentCreate = 15;
    public const int PaymentEdit = 16;
    public const int AdjustmentCreate = 17;
    public const int AdjustmentEdit = 18;
    public const int Reports = 22;
    public const int ProcComplCreate = 23;
    public const int SecurityAdmin = 24;
    public const int AppointmentCreate = 25;
    public const int AppointmentMove = 26;
    public const int AppointmentEdit = 27;
    public const int AppointmentCompleteEdit = 96;
    public const int InsPayCreate = 36;
    public const int InsPayEdit = 37;
    public const int TreatPlanEdit = 38;
    public const int ProcDelete = 49;
    public const int PatientCreate = 106;
    public const int PatientEdit = 108;
    public const int MobileWeb = 127;
    public const int RxEdit = 76;
    public const int Billing = 62;
    public const int ReportProdInc = 39;
    public const int ReportDaily = 133;
    public const int ReportProdIncAllProviders = 132;
    public const int ReportDailyAllProviders = 134;
    public const int GraphicalReports = 59;
    public const int CommlogEdit = 43;
    public const int Accounting = 33;
    public const int ClaimSend = 104;
    public const int InsPlanChangeSubsc = 55;
    public const int ReferralAdd = 54;
    public const int RefAttachAdd = 56;
    public const int InsPlanAddPat = 113;
    public const int ProcedureNoteFull = 53;
    public const int SheetEdit = 42;
    public const int SheetDelete = 136;
    public const int ImageEdit = 89;
    public const int ImageDelete = 44;
    public const int PerioEdit = 45;
    public const int OrthoChartEditFull = 79;
    public const int PatPriProvEdit = 129;
    public const int PatientBillingEdit = 131;
    public const int PatientApptRestrict = 135;
    public const int ClaimDelete = 118;
    public const int ClaimProcReceivedEdit = 125;
    public const int InsWriteOffEdit = 119;
    public const int ApptConfirmStatusEdit = 120;
    public const int TreatPlanPresenterEdit = 123;
    public const int ProcEdit = 100;
    public const int ProcFeeEdit = 64;
    public const int ProcEditShowFee = 46;
    public const int TaskNoteEdit = 66;
    public const int TaskEdit = 84;
    public const int TaskListCreate = 105;
    public const int EmailSend = 85;
    public const int EServicesSetup = 91;
    public const int ProviderEdit = 51;
    public const int FeeSchedEdit = 92;
    public const int CarrierCreate = 58;
    public const int DepositSlips = 30;
    public const int Backup = 28;
    public const int TimecardsEditAll = 29;
    public const int AuditTrail = 122;
    public const int PatientMerge = 94;
    public const int ReferralMerge = 99;
    public const int ProviderMerge = 101;
    public const int PatientPortal = 75;
    public const int AdjustmentTypeDeny = 200;
    public const int DashboardWidget = 201;
}
