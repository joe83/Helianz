namespace HelianzApi.Models;

public class Payment
{
    public long PayNum { get; set; }
    public long PatNum { get; set; }
    public string PatientName { get; set; } = "";
    public long ClinicNum { get; set; }
    public DateTime PayDate { get; set; }
    public double PayAmt { get; set; }
    public long PayType { get; set; }            // payment type definition
    public string? PayTypeName { get; set; }
    public string? CheckNum { get; set; }
    public string? BankBranch { get; set; }
    public string? Note { get; set; }
    public long ProvNum { get; set; }
    public string? ProvName { get; set; }
    public long SecUserNumEntry { get; set; }
    public DateTime DateEntry { get; set; }
    public long PayGroupNum { get; set; }

    // Payment splits (allocations to procedures)
    public List<PaySplit> Splits { get; set; } = new();
}

public class PaySplit
{
    public long SplitNum { get; set; }
    public long PayNum { get; set; }
    public long PatNum { get; set; }
    public long ProvNum { get; set; }
    public long ClinicNum { get; set; }
    public DateTime DatePay { get; set; }
    public double SplitAmt { get; set; }
    public long ProcNum { get; set; }
    public string? ProcCode { get; set; }
    public string? ProcDescript { get; set; }
}

public class PaymentSearchRequest
{
    public long? PatNum { get; set; }
    public long? ClinicNum { get; set; }
    public DateTime? DateFrom { get; set; }
    public DateTime? DateTo { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 50;
}

public class PaymentSearchResult
{
    public List<Payment> Payments { get; set; } = new();
    public int TotalCount { get; set; }
    public double TotalAmount { get; set; }
}

public class PaymentCreateRequest
{
    public long PatNum { get; set; }
    public long ClinicNum { get; set; }
    public DateTime PayDate { get; set; } = DateTime.UtcNow;
    public double PayAmt { get; set; }
    public long PayType { get; set; }
    public string? CheckNum { get; set; }
    public string? Note { get; set; }
    public long ProvNum { get; set; }

    /// <summary>Allocate payment to specific procedures</summary>
    public List<PaySplitRequest> Splits { get; set; } = new();
}

public class PaySplitRequest
{
    public long ProcNum { get; set; }
    public double SplitAmt { get; set; }
}
