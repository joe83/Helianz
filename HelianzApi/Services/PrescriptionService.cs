using System.Data;
using Dapper;
using HelianzApi.Data;
using HelianzApi.Models;

namespace HelianzApi.Services;

public class PrescriptionService
{
    private readonly DatabaseConnectionFactory _db;

    public PrescriptionService(DatabaseConnectionFactory db) => _db = db;

    public async Task<PrescriptionSearchResult> SearchAsync(PrescriptionSearchRequest req, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var conditions = new List<string>();
        var parameters = new DynamicParameters();

        if (allowedClinics.Count > 0)
        {
            conditions.Add("rx.ClinicNum IN @AllowedClinics");
            parameters.Add("AllowedClinics", allowedClinics);
        }
        if (req.PatNum.HasValue)
        {
            conditions.Add("rx.PatNum = @PatNum");
            parameters.Add("PatNum", req.PatNum.Value);
        }
        if (req.ClinicNum.HasValue)
        {
            conditions.Add("rx.ClinicNum = @ClinicNum");
            parameters.Add("ClinicNum", req.ClinicNum.Value);
        }
        if (req.DateFrom.HasValue)
        {
            conditions.Add("rx.RxDate >= @DateFrom");
            parameters.Add("DateFrom", req.DateFrom.Value.Date);
        }
        if (req.DateTo.HasValue)
        {
            conditions.Add("rx.RxDate < @DateTo");
            parameters.Add("DateTo", req.DateTo.Value.Date.AddDays(1));
        }

        var where = conditions.Count > 0 ? "WHERE " + string.Join(" AND ", conditions) : "";

        var countSql = $"SELECT COUNT(*) FROM rxpat rx {where}";
        var totalCount = await conn.ExecuteScalarAsync<int>(countSql, parameters);

        parameters.Add("PageSize", req.PageSize);
        parameters.Add("Offset", (req.Page - 1) * req.PageSize);

        var sql = $@"
            SELECT rx.RxNum, rx.PatNum,
                   CONCAT(p.LName, ', ', p.FName) AS PatientName,
                   rx.ClinicNum, rx.ProvNum,
                   prov.Abbr AS ProvName,
                   rx.Drug, rx.Sig, rx.Disp, rx.Refills, rx.Notes AS Note,
                   rx.RxDate, rx.IsControlled,
                   rx.PharmacyNum, ph.StoreName AS PharmacyName,
                   rx.DateTStamp
            FROM rxpat rx
            LEFT JOIN patient p ON rx.PatNum = p.PatNum
            LEFT JOIN provider prov ON rx.ProvNum = prov.ProvNum
            LEFT JOIN pharmacy ph ON rx.PharmacyNum = ph.PharmacyNum
            {where}
            ORDER BY rx.RxDate DESC
            LIMIT @PageSize OFFSET @Offset";

        var prescriptions = (await conn.QueryAsync<Prescription>(sql, parameters)).ToList();

        return new PrescriptionSearchResult
        {
            Prescriptions = prescriptions,
            TotalCount = totalCount
        };
    }

    public async Task<Prescription?> GetByIdAsync(long rxNum, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();
        var clinicFilter = allowedClinics.Count > 0
            ? "AND rx.ClinicNum IN @AllowedClinics" : "";

        return await conn.QueryFirstOrDefaultAsync<Prescription>($@"
            SELECT rx.RxNum, rx.PatNum,
                   CONCAT(p.LName, ', ', p.FName) AS PatientName,
                   rx.ClinicNum, rx.ProvNum,
                   prov.Abbr AS ProvName,
                   rx.Drug, rx.Sig, rx.Disp, rx.Refills, rx.Notes AS Note,
                   rx.RxDate, rx.IsControlled,
                   rx.PharmacyNum, ph.StoreName AS PharmacyName,
                   rx.DateTStamp
            FROM rxpat rx
            LEFT JOIN patient p ON rx.PatNum = p.PatNum
            LEFT JOIN provider prov ON rx.ProvNum = prov.ProvNum
            LEFT JOIN pharmacy ph ON rx.PharmacyNum = ph.PharmacyNum
            WHERE rx.RxNum = @RxNum {clinicFilter}",
            new { RxNum = rxNum, AllowedClinics = allowedClinics });
    }

    public async Task<long> CreateAsync(PrescriptionCreateRequest req)
    {
        using var conn = _db.CreateConnection();

        return await conn.ExecuteScalarAsync<long>(@"
            INSERT INTO rxpat (
                PatNum, ClinicNum, ProvNum,
                Drug, Sig, Disp, Refills, Notes,
                RxDate, IsControlled, PharmacyNum, DateTStamp
            ) VALUES (
                @PatNum, @ClinicNum, @ProvNum,
                @Drug, @Sig, @Disp, @Refills, @Note,
                NOW(), @IsControlled, @PharmacyNum, NOW()
            );
            SELECT LAST_INSERT_ID();",
            req);
    }
}

// These types are defined inline; let's make them proper classes
public class PrescriptionSearchResult
{
    public List<Prescription> Prescriptions { get; set; } = new();
    public int TotalCount { get; set; }
}
