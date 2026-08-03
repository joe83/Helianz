using System.Data;
using Dapper;
using HelianzApi.Data;
using HelianzApi.Models;

namespace HelianzApi.Services;

public class AppointmentService
{
    private readonly DatabaseConnectionFactory _db;

    public AppointmentService(DatabaseConnectionFactory db) => _db = db;

    public async Task<AppointmentSearchResult> SearchAsync(AppointmentSearchRequest req, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var conditions = new List<string>();
        var parameters = new DynamicParameters();

        var effectiveClinics = allowedClinics.Where(c => c != 0).ToList();
        if (effectiveClinics.Count > 0)
        {
            conditions.Add("a.ClinicNum IN @AllowedClinics");
            parameters.Add("AllowedClinics", effectiveClinics);
        }
        if (req.DateFrom.HasValue)
        {
            conditions.Add("a.AptDateTime >= @DateFrom");
            parameters.Add("DateFrom", req.DateFrom.Value.Date);
        }
        if (req.DateTo.HasValue)
        {
            conditions.Add("a.AptDateTime < @DateTo");
            parameters.Add("DateTo", req.DateTo.Value.Date.AddDays(1));
        }
        if (req.ProvNum.HasValue)
        {
            conditions.Add("(a.ProvNum = @ProvNum OR a.ProvHyg = @ProvNum)");
            parameters.Add("ProvNum", req.ProvNum.Value);
        }
        if (req.ClinicNum.HasValue)
        {
            conditions.Add("a.ClinicNum = @ClinicNum");
            parameters.Add("ClinicNum", req.ClinicNum.Value);
        }
        if (req.PatNum.HasValue)
        {
            conditions.Add("a.PatNum = @PatNum");
            parameters.Add("PatNum", req.PatNum.Value);
        }
        if (req.AptStatus.HasValue)
        {
            conditions.Add("a.AptStatus = @AptStatus");
            parameters.Add("AptStatus", req.AptStatus.Value);
        }

        var where = conditions.Count > 0 ? "WHERE " + string.Join(" AND ", conditions) : "";

        var countSql = $"SELECT COUNT(*) FROM appointment a {where}";
        var totalCount = await conn.ExecuteScalarAsync<int>(countSql, parameters);

        parameters.Add("PageSize", req.PageSize);
        parameters.Add("Offset", (req.Page - 1) * req.PageSize);

        var sql = $@"
            SELECT a.AptNum, a.PatNum,
                   CONCAT(p.LName, ', ', p.FName) AS PatientName,
                   a.AptStatus, a.ClinicNum, a.ProvNum, a.ProvHyg,
                   a.Op AS OpNum, o.OpName,
                   a.AptDateTime, a.Pattern, 0 AS Length,
                   a.Note, a.Confirmed, a.AppointmentTypeNum,
                   at.AppointmentTypeName,
                   a.IsNewPatient, a.IsHygiene,
                   a.DateTStamp,
                   prov.Abbr AS ProvName,
                   provHyg.Abbr AS ProvHygName,
                   p.WirelessPhone AS PatientPhone
            FROM appointment a
            LEFT JOIN patient p ON a.PatNum = p.PatNum
            LEFT JOIN provider prov ON a.ProvNum = prov.ProvNum
            LEFT JOIN provider provHyg ON a.ProvHyg = provHyg.ProvNum
            LEFT JOIN operatory o ON a.Op = o.OperatoryNum
            LEFT JOIN appointmenttype at ON a.AppointmentTypeNum = at.AppointmentTypeNum
            {where}
            ORDER BY a.AptDateTime DESC
            LIMIT @PageSize OFFSET @Offset";

        var appointments = (await conn.QueryAsync<Appointment>(sql, parameters)).ToList();

        return new AppointmentSearchResult
        {
            Appointments = appointments,
            TotalCount = totalCount
        };
    }

    public async Task<Appointment?> GetByIdAsync(long aptNum, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var effectiveClinics = allowedClinics.Where(c => c != 0).ToList();
        var clinicFilter = effectiveClinics.Count > 0
            ? "AND a.ClinicNum IN @AllowedClinics" : "";

        return await conn.QueryFirstOrDefaultAsync<Appointment>($@"
            SELECT a.AptNum, a.PatNum,
                   CONCAT(p.LName, ', ', p.FName) AS PatientName,
                   a.AptStatus, a.ClinicNum, a.ProvNum, a.ProvHyg,
                   a.Op AS OpNum, o.OpName,
                   a.AptDateTime, a.Pattern, 0 AS Length,
                   a.Note, a.Confirmed, a.AppointmentTypeNum,
                   at.AppointmentTypeName,
                   a.IsNewPatient, a.IsHygiene, a.DateTStamp,
                   prov.Abbr AS ProvName,
                   provHyg.Abbr AS ProvHygName,
                   p.WirelessPhone AS PatientPhone
            FROM appointment a
            LEFT JOIN patient p ON a.PatNum = p.PatNum
            LEFT JOIN provider prov ON a.ProvNum = prov.ProvNum
            LEFT JOIN provider provHyg ON a.ProvHyg = provHyg.ProvNum
            LEFT JOIN operatory o ON a.Op = o.OperatoryNum
            LEFT JOIN appointmenttype at ON a.AppointmentTypeNum = at.AppointmentTypeNum
            WHERE a.AptNum = @AptNum {clinicFilter}",
            new { AptNum = aptNum, AllowedClinics = effectiveClinics });
    }

    public async Task<long> CreateAsync(AppointmentCreateRequest req)
    {
        using var conn = _db.CreateConnection();

        var aptNum = await conn.ExecuteScalarAsync<long>(@"
            INSERT INTO appointment (
                PatNum, AptStatus, ClinicNum, ProvNum, ProvHyg,
                Op, AptDateTime, Pattern,
                Note, Confirmed, AppointmentTypeNum,
                IsNewPatient, IsHygiene, DateTStamp
            ) VALUES (
                @PatNum, 1, @ClinicNum, @ProvNum, @ProvHyg,
                @OpNum, @AptDateTime, @Pattern,
                @Note, 0, @AppointmentTypeNum,
                @IsNewPatient, @IsHygiene, NOW()
            );
            SELECT LAST_INSERT_ID();",
            req);

        return aptNum;
    }

    public async Task<bool> UpdateAsync(long aptNum, AppointmentUpdateRequest req, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var effectiveClinics = allowedClinics.Where(c => c != 0).ToList();
        var clinicFilter = effectiveClinics.Count > 0
            ? "AND ClinicNum IN @AllowedClinics" : "";

        var rows = await conn.ExecuteAsync($@"
            UPDATE appointment SET
                PatNum = @PatNum, AptStatus = @AptStatus,
                ClinicNum = @ClinicNum, ProvNum = @ProvNum,
                ProvHyg = @ProvHyg, Op = @OpNum,
                AptDateTime = @AptDateTime, Pattern = @Pattern,
                Note = @Note,
                Confirmed = @Confirmed,
                AppointmentTypeNum = @AppointmentTypeNum,
                IsNewPatient = @IsNewPatient, IsHygiene = @IsHygiene
            WHERE AptNum = @AptNum {clinicFilter}",
            new { req.PatNum, req.AptStatus, req.ClinicNum, req.ProvNum,
                  req.ProvHyg, req.OpNum, req.AptDateTime, req.Pattern,
                  req.Note, req.Confirmed, req.AppointmentTypeNum,
                  req.IsNewPatient, req.IsHygiene,
                  AptNum = aptNum, AllowedClinics = effectiveClinics });

        return rows > 0;
    }

    /// <summary>Set appointment as complete (AptStatus=2)</summary>
    public async Task<bool> SetCompleteAsync(long aptNum, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();
        var effectiveClinics = allowedClinics.Where(c => c != 0).ToList();
        var clinicFilter = effectiveClinics.Count > 0
            ? "AND ClinicNum IN @AllowedClinics" : "";

        var rows = await conn.ExecuteAsync($@"
            UPDATE appointment SET AptStatus = 2
            WHERE AptNum = @AptNum {clinicFilter}",
            new { AptNum = aptNum, AllowedClinics = effectiveClinics });

        return rows > 0;
    }

    /// <summary>Get today's appointments for a clinic/provider</summary>
    public async Task<List<Appointment>> GetTodayAsync(long? clinicNum, long? provNum, List<long> allowedClinics)
    {
        var today = DateTime.UtcNow.Date;
        var tomorrow = today.AddDays(1);

        var req = new AppointmentSearchRequest
        {
            DateFrom = today,
            DateTo = tomorrow,
            ClinicNum = clinicNum,
            ProvNum = provNum,
            AptStatus = 1, // Scheduled only
            PageSize = 500
        };
        var result = await SearchAsync(req, allowedClinics);
        return result.Appointments;
    }
}
