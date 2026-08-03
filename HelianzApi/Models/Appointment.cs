namespace HelianzApi.Models;

public class Appointment
{
    public long AptNum { get; set; }
    public long PatNum { get; set; }
    public string PatientName { get; set; } = "";
    public int AptStatus { get; set; }        // 1=Scheduled, 2=Complete, 3=UnschedList, etc.
    public long ClinicNum { get; set; }
    public long ProvNum { get; set; }          // Provider
    public long ProvHyg { get; set; }          // Hygienist
    public long OpNum { get; set; }            // Operatory
    public string? OpName { get; set; }
    public DateTime AptDateTime { get; set; }
    public int Length { get; set; }            // Minutes
    public string? Pattern { get; set; }
    public string? Note { get; set; }
    public long Confirmed { get; set; }
    public long AppointmentTypeNum { get; set; }
    public string? AppointmentTypeName { get; set; }
    public bool IsNewPatient { get; set; }
    public bool IsHygiene { get; set; }
    public string? ProvName { get; set; }
    public string? ProvHygName { get; set; }
    public string? PatientPhone { get; set; }
    public DateTime DateTStamp { get; set; }
}

public class AppointmentSearchRequest
{
    public DateTime? DateFrom { get; set; }
    public DateTime? DateTo { get; set; }
    public long? ProvNum { get; set; }
    public long? ClinicNum { get; set; }
    public long? PatNum { get; set; }
    public int? AptStatus { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 50;
}

public class AppointmentSearchResult
{
    public List<Appointment> Appointments { get; set; } = new();
    public int TotalCount { get; set; }
}

public class AppointmentCreateRequest
{
    public long PatNum { get; set; }
    public long ClinicNum { get; set; }
    public long ProvNum { get; set; }
    public long ProvHyg { get; set; }
    public long OpNum { get; set; }
    public DateTime AptDateTime { get; set; }
    public int Length { get; set; } = 30;     // default 30 minutes
    public string? Pattern { get; set; } = "/X/";
    public string? Note { get; set; }
    public long AppointmentTypeNum { get; set; }
    public bool IsNewPatient { get; set; }
    public bool IsHygiene { get; set; }
}

public class AppointmentUpdateRequest : AppointmentCreateRequest
{
    public int AptStatus { get; set; } = 1;
    public long Confirmed { get; set; }
}
