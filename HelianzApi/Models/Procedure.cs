namespace HelianzApi.Models;

public class Procedure
{
    public long ProcNum { get; set; }
    public long PatNum { get; set; }
    public string PatientName { get; set; } = "";
    public long ClinicNum { get; set; }
    public long ProvNum { get; set; }
    public string? ProvName { get; set; }
    public string CodeNum { get; set; } = "";     // procedurecode.CodeNum
    public string? ProcCode { get; set; }          // e.g. D0120
    public string? Descript { get; set; }          // Procedure description
    public string? ToothNum { get; set; }          // Tooth number (1-32, A-T)
    public string? Surf { get; set; }              // Surfaces (MO, DOB, etc.)
    public int ProcStatus { get; set; }            // 1=TP, 2=C, 3=EC, 4=EO
    public DateTime ProcDate { get; set; }
    public DateTime DateEntryC { get; set; }
    public double ProcFee { get; set; }
    public int Priority { get; set; }
    public string? Note { get; set; }
    public long AptNum { get; set; }
    public long DxNum { get; set; }               // Diagnosis
    public long MedicalOrderCodeNum { get; set; }
    public string? ProcStatusName { get; set; }
}

/// <summary>Chart view: tooth-numbered grid of procedures for a patient</summary>
public class ToothChart
{
    public long PatNum { get; set; }
    public string PatientName { get; set; } = "";
    public List<ToothProcedure> Teeth { get; set; } = new();
}

public class ToothProcedure
{
    public string ToothNum { get; set; } = "";
    public List<Procedure> Procedures { get; set; } = new();
}

public class ProcedureSearchRequest
{
    public long? PatNum { get; set; }
    public long? ClinicNum { get; set; }
    public long? ProvNum { get; set; }
    public DateTime? DateFrom { get; set; }
    public DateTime? DateTo { get; set; }
    public int? ProcStatus { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 50;
}

public class ProcedureSearchResult
{
    public List<Procedure> Procedures { get; set; } = new();
    public int TotalCount { get; set; }
}

public class ProcedureCreateRequest
{
    public long PatNum { get; set; }
    public long ClinicNum { get; set; }
    public long ProvNum { get; set; }
    public string CodeNum { get; set; } = "";
    public string? ToothNum { get; set; }
    public string? Surf { get; set; }
    public int ProcStatus { get; set; } = 1;      // 1=Treatment Plan by default
    public DateTime ProcDate { get; set; } = DateTime.UtcNow;
    public double ProcFee { get; set; }
    public int Priority { get; set; }
    public string? Note { get; set; }
    public long AptNum { get; set; }
    public long DxNum { get; set; }
}
