namespace HelianzApi.Models;

public class Patient
{
    public long PatNum { get; set; }
    public string LName { get; set; } = "";
    public string FName { get; set; } = "";
    public string? MiddleI { get; set; }
    public string? Preferred { get; set; }
    public int Gender { get; set; }           // 0=Male, 1=Female, 2=Unknown
    public DateTime Birthdate { get; set; }
    public string? SSN { get; set; }          // NIK for Indonesia
    public string? Address { get; set; }
    public string? Address2 { get; set; }
    public string? City { get; set; }
    public string? State { get; set; }
    public string? Zip { get; set; }
    public string? HmPhone { get; set; }
    public string? WkPhone { get; set; }
    public string? WirelessPhone { get; set; }
    public string? Email { get; set; }
    public long ClinicNum { get; set; }
    public int PatientStatus { get; set; }    // 0=Patient, 1=NonPatient, etc.
    public DateTime DateFirstVisit { get; set; }
    public long PriProv { get; set; }          // Primary provider
    public string? ChartNumber { get; set; }
    public string? MedicalUrgency { get; set; }
    public string? Country { get; set; }
    public bool HasIns { get; set; }
    public double BalanceTotal { get; set; }
    public double InsEstTotal { get; set; }
    public int Age => DateTime.UtcNow.Year - Birthdate.Year -
        (DateTime.UtcNow.DayOfYear < Birthdate.DayOfYear ? 1 : 0);
}

public class PatientSearchRequest
{
    public string? Query { get; set; }
    public long? ClinicNum { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}

public class PatientSearchResult
{
    public List<Patient> Patients { get; set; } = new();
    public int TotalCount { get; set; }
    public int Page { get; set; }
    public int PageSize { get; set; }
}

public class PatientCreateRequest
{
    public string LName { get; set; } = "";
    public string FName { get; set; } = "";
    public string? MiddleI { get; set; }
    public string? Preferred { get; set; }
    public int Gender { get; set; }
    public DateTime Birthdate { get; set; }
    public string? SSN { get; set; }
    public string? Address { get; set; }
    public string? Address2 { get; set; }
    public string? City { get; set; }
    public string? State { get; set; }
    public string? Zip { get; set; }
    public string? HmPhone { get; set; }
    public string? WkPhone { get; set; }
    public string? WirelessPhone { get; set; }
    public string? Email { get; set; }
    public long ClinicNum { get; set; }
    public long PriProv { get; set; }
    public string? Country { get; set; } = "Indonesia";
}

public class PatientUpdateRequest : PatientCreateRequest
{
    // Same fields, used for PUT
}
