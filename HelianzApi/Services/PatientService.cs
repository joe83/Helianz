using System.Data;
using Dapper;
using HelianzApi.Data;
using HelianzApi.Models;

namespace HelianzApi.Services;

public class PatientService
{
    private readonly DatabaseConnectionFactory _db;

    public PatientService(DatabaseConnectionFactory db) => _db = db;

    public async Task<PatientSearchResult> SearchAsync(PatientSearchRequest req, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        // ClinicNum=0 means "all clinics" in OpenDental — skip filtering
        var effectiveClinics = allowedClinics.Where(c => c != 0).ToList();
        var clinicFilter = effectiveClinics.Count > 0
            ? "AND p.ClinicNum IN @AllowedClinics"
            : "";
        var searchFilter = string.IsNullOrWhiteSpace(req.Query)
            ? ""
            : @"AND (p.LName LIKE @Query
                  OR p.FName LIKE @Query
                  OR p.WirelessPhone LIKE @Query
                  OR p.ChartNumber LIKE @Query
                  OR p.SSN LIKE @Query)";

        var queryParam = string.IsNullOrWhiteSpace(req.Query)
            ? "%" : $"%{req.Query}%";

        var countSql = $@"
            SELECT COUNT(*) FROM patient p
            WHERE p.PatStatus IN (0, 1)
            {clinicFilter} {searchFilter}";

        var totalCount = await conn.ExecuteScalarAsync<int>(countSql, new
        {
            req.ClinicNum,
            AllowedClinics = effectiveClinics,
            Query = queryParam
        });

        var offset = (req.Page - 1) * req.PageSize;
        var sql = $@"
            SELECT p.PatNum, p.LName, p.FName, p.MiddleI, p.Preferred,
                   p.Gender, p.Birthdate, p.SSN,
                   p.Address, p.Address2, p.City, p.State, p.Zip,
                   p.HmPhone, p.WkPhone, p.WirelessPhone, p.Email,
                   p.ClinicNum, p.PatStatus AS PatientStatus,
                   p.DateFirstVisit, p.PriProv, p.ChartNumber,
                   p.Country,
                   0 AS BalanceTotal,
                   0 AS InsEstTotal,
                   0 AS HasIns
            FROM patient p
            WHERE p.PatStatus IN (0, 1)
            {clinicFilter} {searchFilter}
            ORDER BY p.LName, p.FName
            LIMIT @PageSize OFFSET @Offset";

        var patients = (await conn.QueryAsync<Patient>(sql, new
        {
            req.ClinicNum,
            AllowedClinics = effectiveClinics,
            Query = queryParam,
            req.PageSize,
            Offset = offset
        })).ToList();

        return new PatientSearchResult
        {
            Patients = patients,
            TotalCount = totalCount,
            Page = req.Page,
            PageSize = req.PageSize
        };
    }

    public async Task<Patient?> GetByIdAsync(long patNum, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var effectiveClinics = allowedClinics.Where(c => c != 0).ToList();
        var clinicFilter = effectiveClinics.Count > 0
            ? "AND p.ClinicNum IN @AllowedClinics" : "";

        return await conn.QueryFirstOrDefaultAsync<Patient>($@"
            SELECT p.PatNum, p.LName, p.FName, p.MiddleI, p.Preferred,
                   p.Gender, p.Birthdate, p.SSN,
                   p.Address, p.Address2, p.City, p.State, p.Zip,
                   p.HmPhone, p.WkPhone, p.WirelessPhone, p.Email,
                   p.ClinicNum, p.PatStatus AS PatientStatus,
                   p.DateFirstVisit, p.PriProv, p.ChartNumber,
                   p.Country,
                   0 AS BalanceTotal,
                   0 AS InsEstTotal,
                   0 AS HasIns
            FROM patient p
            WHERE p.PatNum = @PatNum {clinicFilter}",
            new { PatNum = patNum, AllowedClinics = effectiveClinics });
    }

    public async Task<long> CreateAsync(PatientCreateRequest req)
    {
        using var conn = _db.CreateConnection();

        var patNum = await conn.ExecuteScalarAsync<long>(@"
            INSERT INTO patient (
                LName, FName, MiddleI, Preferred,
                Gender, Birthdate, SSN,
                Address, Address2, City, State, Zip,
                HmPhone, WkPhone, WirelessPhone, Email,
                ClinicNum, PriProv, Country,
                PatStatus, DateFirstVisit
            ) VALUES (
                @LName, @FName, @MiddleI, @Preferred,
                @Gender, @Birthdate, @SSN,
                @Address, @Address2, @City, @State, @Zip,
                @HmPhone, @WkPhone, @WirelessPhone, @Email,
                @ClinicNum, @PriProv, @Country,
                0, NOW()
            );
            SELECT LAST_INSERT_ID();",
            req);

        return patNum;
    }

    public async Task<bool> UpdateAsync(long patNum, PatientUpdateRequest req, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var effectiveClinics = allowedClinics.Where(c => c != 0).ToList();
        var clinicFilter = effectiveClinics.Count > 0
            ? "AND ClinicNum IN @AllowedClinics" : "";

        var rows = await conn.ExecuteAsync($@"
            UPDATE patient SET
                LName = @LName, FName = @FName, MiddleI = @MiddleI,
                Preferred = @Preferred, Gender = @Gender,
                Birthdate = @Birthdate, SSN = @SSN,
                Address = @Address, Address2 = @Address2,
                City = @City, State = @State, Zip = @Zip,
                HmPhone = @HmPhone, WkPhone = @WkPhone,
                WirelessPhone = @WirelessPhone, Email = @Email,
                ClinicNum = @ClinicNum, PriProv = @PriProv,
                Country = @Country
            WHERE PatNum = @PatNum {clinicFilter}",
            new { req.LName, req.FName, req.MiddleI, req.Preferred,
                  req.Gender, req.Birthdate, req.SSN,
                  req.Address, req.Address2, req.City, req.State, req.Zip,
                  req.HmPhone, req.WkPhone, req.WirelessPhone, req.Email,
                  req.ClinicNum, req.PriProv, req.Country,
                  PatNum = patNum, AllowedClinics = effectiveClinics });

        return rows > 0;
    }
}
