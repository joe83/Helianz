using System.Data;
using Dapper;
using HelianzApi.Data;
using HelianzApi.Models;

namespace HelianzApi.Services;

public class PaymentService
{
    private readonly DatabaseConnectionFactory _db;

    public PaymentService(DatabaseConnectionFactory db) => _db = db;

    public async Task<PaymentSearchResult> SearchAsync(PaymentSearchRequest req, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var conditions = new List<string>();
        var parameters = new DynamicParameters();

        if (allowedClinics.Count > 0)
        {
            conditions.Add("p.ClinicNum IN @AllowedClinics");
            parameters.Add("AllowedClinics", allowedClinics);
        }
        if (req.PatNum.HasValue)
        {
            conditions.Add("p.PatNum = @PatNum");
            parameters.Add("PatNum", req.PatNum.Value);
        }
        if (req.ClinicNum.HasValue)
        {
            conditions.Add("p.ClinicNum = @ClinicNum");
            parameters.Add("ClinicNum", req.ClinicNum.Value);
        }
        if (req.DateFrom.HasValue)
        {
            conditions.Add("p.PayDate >= @DateFrom");
            parameters.Add("DateFrom", req.DateFrom.Value.Date);
        }
        if (req.DateTo.HasValue)
        {
            conditions.Add("p.PayDate < @DateTo");
            parameters.Add("DateTo", req.DateTo.Value.Date.AddDays(1));
        }

        var where = conditions.Count > 0 ? "WHERE " + string.Join(" AND ", conditions) : "";

        var countSql = $"SELECT COUNT(*) FROM payment p {where}";
        var totalCount = await conn.ExecuteScalarAsync<int>(countSql, parameters);

        var sumSql = $"SELECT IFNULL(SUM(p.PayAmt), 0) FROM payment p {where}";
        var totalAmount = await conn.ExecuteScalarAsync<double>(sumSql, parameters);

        parameters.Add("PageSize", req.PageSize);
        parameters.Add("Offset", (req.Page - 1) * req.PageSize);

        var sql = $@"
            SELECT p.PayNum, p.PatNum,
                   CONCAT(pat.LName, ', ', pat.FName) AS PatientName,
                   p.ClinicNum, p.PayDate, p.PayAmt, p.PayType,
                   def.ItemName AS PayTypeName,
                   p.CheckNum, p.BankBranch, p.PayNote AS Note,
                   p.ProvNum, prov.Abbr AS ProvName,
                   p.SecUserNumEntry, p.DateEntry
            FROM payment p
            LEFT JOIN patient pat ON p.PatNum = pat.PatNum
            LEFT JOIN provider prov ON p.ProvNum = prov.ProvNum
            LEFT JOIN definition def ON p.PayType = def.DefNum
            {where}
            ORDER BY p.PayDate DESC
            LIMIT @PageSize OFFSET @Offset";

        var payments = (await conn.QueryAsync<Payment>(sql, parameters)).ToList();

        return new PaymentSearchResult
        {
            Payments = payments,
            TotalCount = totalCount,
            TotalAmount = totalAmount
        };
    }

    public async Task<Payment?> GetByIdAsync(long payNum, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();
        var clinicFilter = allowedClinics.Count > 0
            ? "AND p.ClinicNum IN @AllowedClinics" : "";

        var payment = await conn.QueryFirstOrDefaultAsync<Payment>($@"
            SELECT p.PayNum, p.PatNum,
                   CONCAT(pat.LName, ', ', pat.FName) AS PatientName,
                   p.ClinicNum, p.PayDate, p.PayAmt, p.PayType,
                   def.ItemName AS PayTypeName,
                   p.CheckNum, p.BankBranch, p.PayNote AS Note,
                   p.ProvNum, prov.Abbr AS ProvName,
                   p.SecUserNumEntry, p.DateEntry
            FROM payment p
            LEFT JOIN patient pat ON p.PatNum = pat.PatNum
            LEFT JOIN provider prov ON p.ProvNum = prov.ProvNum
            LEFT JOIN definition def ON p.PayType = def.DefNum
            WHERE p.PayNum = @PayNum {clinicFilter}",
            new { PayNum = payNum, AllowedClinics = allowedClinics });

        if (payment != null)
        {
            payment.Splits = (await conn.QueryAsync<PaySplit>($@"
                SELECT ps.SplitNum, ps.PayNum, ps.PatNum, ps.ProvNum,
                       ps.ClinicNum, ps.DatePay, ps.SplitAmt, ps.ProcNum,
                       pc.ProcCode, pc.Descript AS ProcDescript
                FROM paysplit ps
                LEFT JOIN procedurelog pl ON ps.ProcNum = pl.ProcNum
                LEFT JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
                WHERE ps.PayNum = @PayNum",
                new { PayNum = payNum })).ToList();
        }

        return payment;
    }

    public async Task<long> CreateAsync(PaymentCreateRequest req, long userId)
    {
        using var conn = _db.CreateConnection();
        using var tx = conn.BeginTransaction();

        try
        {
            // Insert payment header
            var payNum = await conn.ExecuteScalarAsync<long>(@"
                INSERT INTO payment (
                    PatNum, ClinicNum, PayDate, PayAmt, PayType,
                    CheckNum, PayNote, ProvNum, SecUserNumEntry, DateEntry
                ) VALUES (
                    @PatNum, @ClinicNum, @PayDate, @PayAmt, @PayType,
                    @CheckNum, @Note, @ProvNum, @SecUserNumEntry, NOW()
                );
                SELECT LAST_INSERT_ID();",
                new
                {
                    req.PatNum, req.ClinicNum, req.PayDate,
                    req.PayAmt, req.PayType, req.CheckNum,
                    req.Note, req.ProvNum,
                    SecUserNumEntry = userId
                }, tx);

            // Insert pay splits (allocations)
            foreach (var split in req.Splits)
            {
                await conn.ExecuteAsync(@"
                    INSERT INTO paysplit (
                        PayNum, PatNum, ProvNum, ClinicNum,
                        DatePay, SplitAmt, ProcNum
                    ) VALUES (
                        @PayNum, @PatNum, @ProvNum, @ClinicNum,
                        @DatePay, @SplitAmt, @ProcNum
                    )",
                    new
                    {
                        PayNum = payNum, req.PatNum, req.ProvNum,
                        req.ClinicNum, DatePay = req.PayDate,
                        split.SplitAmt, split.ProcNum
                    }, tx);
            }

            tx.Commit();
            return payNum;
        }
        catch
        {
            tx.Rollback();
            throw;
        }
    }
}
