namespace HelianzApi.Models;

public class Provider
{
    public long ProvNum { get; set; }
    public string Abbr { get; set; } = "";
    public string FName { get; set; } = "";
    public string LName { get; set; } = "";
    public long ClinicNum { get; set; }
    public bool IsHidden { get; set; }
    public bool IsSecondary { get; set; }
    public string? Specialty { get; set; }
}

public class Operatory
{
    public long OperatoryNum { get; set; }
    public string OpName { get; set; } = "";
    public long ClinicNum { get; set; }
    public long ProvDentist { get; set; }
    public long ProvHygienist { get; set; }
    public bool IsHidden { get; set; }
    public int SetOrder { get; set; }
}

public class ProcedureCode
{
    public long CodeNum { get; set; }
    public string ProcCode { get; set; } = "";
    public string Descript { get; set; } = "";
    public string? AbbrDesc { get; set; }
    public int ProcCat { get; set; }
    public string? ProcCatName { get; set; }
    public double ProcFee { get; set; }
    public bool IsHygiene { get; set; }
    public string? PaintType { get; set; }
    public string? TreatmentArea { get; set; }
}

public class AppointmentType
{
    public long AppointmentTypeNum { get; set; }
    public string AppointmentTypeName { get; set; } = "";
    public string? Pattern { get; set; }
    public string? CodeStr { get; set; }
    public string? CodeStrRequired { get; set; }
    public int Length { get; set; }
}

public class Definition
{
    public long DefNum { get; set; }
    public string ItemName { get; set; } = "";
    public int Category { get; set; }
    public int ItemOrder { get; set; }
}

public class ClinicInfo
{
    public long ClinicNum { get; set; }
    public string Description { get; set; } = "";
    public string? Address { get; set; }
    public string? City { get; set; }
    public string? Phone { get; set; }
    public bool IsHidden { get; set; }
}

public class ReferenceData
{
    public List<Provider> Providers { get; set; } = new();
    public List<Operatory> Operatories { get; set; } = new();
    public List<ProcedureCode> ProcedureCodes { get; set; } = new();
    public List<AppointmentType> AppointmentTypes { get; set; } = new();
    public List<Definition> PaymentTypes { get; set; } = new();
    public List<Definition> CommTypes { get; set; } = new();
    public List<Definition> ConfirmedStatuses { get; set; } = new();
    public List<ClinicInfo> Clinics { get; set; } = new();
}
