namespace HelianzApi.Models;

public class ClinicalNote
{
    public long CommlogNum { get; set; }
    public long PatNum { get; set; }
    public string PatientName { get; set; } = "";
    public long ClinicNum { get; set; }
    public long ProvNum { get; set; }
    public string? ProvName { get; set; }
    public DateTime CommDateTime { get; set; }
    public long CommType { get; set; }
    public string? CommTypeName { get; set; }
    public string? Note { get; set; }
    public long UserNum { get; set; }
    public string? UserName { get; set; }
    public DateTime DateTStamp { get; set; }
    public long AptNum { get; set; }
}

public class NoteSearchRequest
{
    public long? PatNum { get; set; }
    public long? ClinicNum { get; set; }
    public DateTime? DateFrom { get; set; }
    public DateTime? DateTo { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}

public class NoteSearchResult
{
    public List<ClinicalNote> Notes { get; set; } = new();
    public int TotalCount { get; set; }
}

public class NoteCreateRequest
{
    public long PatNum { get; set; }
    public long ClinicNum { get; set; }
    public long ProvNum { get; set; }
    public long CommType { get; set; }
    public string Note { get; set; } = "";
    public long AptNum { get; set; }
}
