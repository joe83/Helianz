namespace HelianzApi.Models;

public class Prescription
{
    public long RxNum { get; set; }
    public long PatNum { get; set; }
    public string PatientName { get; set; } = "";
    public long ClinicNum { get; set; }
    public long ProvNum { get; set; }
    public string? ProvName { get; set; }
    public string Drug { get; set; } = "";
    public string? Sig { get; set; }              // Directions (Signa)
    public string? Disp { get; set; }             // Dispense amount
    public string? Refills { get; set; }
    public string? Note { get; set; }
    public DateTime DateRx { get; set; }
    public bool IsControlled { get; set; }
    public long PharmacyNum { get; set; }
    public string? PharmacyName { get; set; }
    public DateTime DateTStamp { get; set; }
}

public class PrescriptionSearchRequest
{
    public long? PatNum { get; set; }
    public long? ClinicNum { get; set; }
    public DateTime? DateFrom { get; set; }
    public DateTime? DateTo { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}

public class PrescriptionCreateRequest
{
    public long PatNum { get; set; }
    public long ClinicNum { get; set; }
    public long ProvNum { get; set; }
    public string Drug { get; set; } = "";
    public string? Sig { get; set; }
    public string? Disp { get; set; }
    public string? Refills { get; set; }
    public string? Note { get; set; }
    public long PharmacyNum { get; set; }
    public bool IsControlled { get; set; }
}
