using System.Data;
using Dapper;
using HelianzApi.Data;
using HelianzApi.Models;

namespace HelianzApi.Services;

public class ProcedureService
{
    private readonly DatabaseConnectionFactory _db;

    public ProcedureService(DatabaseConnectionFactory db) => _db = db;

    public async Task<ProcedureSearchResult> SearchAsync(ProcedureSearchRequest req, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var conditions = new List<string>();
        var parameters = new DynamicParameters();

        if (allowedClinics.Count > 0)
        {
            conditions.Add("pl.ClinicNum IN @AllowedClinics");
            parameters.Add("AllowedClinics", allowedClinics);
        }
        if (req.PatNum.HasValue)
        {
            conditions.Add("pl.PatNum = @PatNum");
            parameters.Add("PatNum", req.PatNum.Value);
        }
        if (req.ClinicNum.HasValue)
        {
            conditions.Add("pl.ClinicNum = @ClinicNum");
            parameters.Add("ClinicNum", req.ClinicNum.Value);
        }
        if (req.ProvNum.HasValue)
        {
            conditions.Add("pl.ProvNum = @ProvNum");
            parameters.Add("ProvNum", req.ProvNum.Value);
        }
        if (req.DateFrom.HasValue)
        {
            conditions.Add("pl.ProcDate >= @DateFrom");
            parameters.Add("DateFrom", req.DateFrom.Value.Date);
        }
        if (req.DateTo.HasValue)
        {
            conditions.Add("pl.ProcDate < @DateTo");
            parameters.Add("DateTo", req.DateTo.Value.Date.AddDays(1));
        }
        if (req.ProcStatus.HasValue)
        {
            conditions.Add("pl.ProcStatus = @ProcStatus");
            parameters.Add("ProcStatus", req.ProcStatus.Value);
        }

        var where = conditions.Count > 0 ? "WHERE " + string.Join(" AND ", conditions) : "";

        var countSql = $"SELECT COUNT(*) FROM procedurelog pl {where}";
        var totalCount = await conn.ExecuteScalarAsync<int>(countSql, parameters);

        parameters.Add("PageSize", req.PageSize);
        parameters.Add("Offset", (req.Page - 1) * req.PageSize);

        var sql = $@"
            SELECT pl.ProcNum, pl.PatNum,
                   CONCAT(p.LName, ', ', p.FName) AS PatientName,
                   pl.ClinicNum, pl.ProvNum,
                   prov.Abbr AS ProvName,
                   pl.CodeNum, pc.ProcCode, pc.Descript,
                   pl.ToothNum, pl.Surf,
                   pl.ProcStatus, pl.ProcDate, pl.DateEntryC,
                   pl.ProcFee, pl.Priority, pl.Note,
                   pl.AptNum, pl.DxNum, pl.MedicalOrderCodeNum,
                   CASE pl.ProcStatus
                       WHEN 1 THEN 'Treatment Plan'
                       WHEN 2 THEN 'Complete'
                       WHEN 3 THEN 'Existing Current'
                       WHEN 4 THEN 'Existing Other'
                       WHEN 5 THEN 'Referred'
                       WHEN 6 THEN 'Deleted'
                       ELSE 'Unknown'
                   END AS ProcStatusName
            FROM procedurelog pl
            LEFT JOIN patient p ON pl.PatNum = p.PatNum
            LEFT JOIN provider prov ON pl.ProvNum = prov.ProvNum
            LEFT JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
            {where}
            ORDER BY pl.ProcDate DESC, pl.ProcNum DESC
            LIMIT @PageSize OFFSET @Offset";

        var procedures = (await conn.QueryAsync<Procedure>(sql, parameters)).ToList();

        return new ProcedureSearchResult { Procedures = procedures, TotalCount = totalCount };
    }

    public async Task<ToothChart> GetToothChartAsync(long patNum, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var clinicFilter = allowedClinics.Count > 0
            ? "AND pl.ClinicNum IN @AllowedClinics" : "";

        var patient = await conn.QueryFirstOrDefaultAsync<(string name, long patNum)>($@"
            SELECT CONCAT(LName, ', ', FName), PatNum FROM patient
            WHERE PatNum = @PatNum {clinicFilter}",
            new { PatNum = patNum, AllowedClinics = allowedClinics });

        if (patient.patNum == 0)
            return new ToothChart();

        var procedures = (await conn.QueryAsync<Procedure>($@"
            SELECT pl.ProcNum, pl.PatNum, '' AS PatientName,
                   pl.ClinicNum, pl.ProvNum, prov.Abbr AS ProvName,
                   pl.CodeNum, pc.ProcCode, pc.Descript,
                   pl.ToothNum, pl.Surf,
                   pl.ProcStatus, pl.ProcDate, pl.DateEntryC,
                   pl.ProcFee, pl.Priority, pl.Note,
                   pl.AptNum, pl.DxNum, pl.MedicalOrderCodeNum,
                   CASE pl.ProcStatus
                       WHEN 1 THEN 'Treatment Plan'
                       WHEN 2 THEN 'Complete'
                       WHEN 3 THEN 'Existing Current'
                       WHEN 4 THEN 'Existing Other'
                       ELSE 'Unknown'
                   END AS ProcStatusName
            FROM procedurelog pl
            LEFT JOIN provider prov ON pl.ProvNum = prov.ProvNum
            LEFT JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
            WHERE pl.PatNum = @PatNum {clinicFilter}
              AND pl.ProcStatus IN (1, 2, 3, 4)
            ORDER BY pl.ToothNum, pl.ProcDate DESC",
            new { PatNum = patNum, AllowedClinics = allowedClinics })).ToList();

        var chart = new ToothChart
        {
            PatNum = patNum,
            PatientName = patient.name,
            Teeth = procedures
                .GroupBy(p => p.ToothNum ?? "")
                .Select(g => new ToothProcedure { ToothNum = g.Key, Procedures = g.ToList() })
                .OrderBy(t => t.ToothNum)
                .ToList()
        };

        return chart;
    }

    public async Task<long> CreateAsync(ProcedureCreateRequest req)
    {
        using var conn = _db.CreateConnection();

        return await conn.ExecuteScalarAsync<long>(@"
            INSERT INTO procedurelog (
                PatNum, ClinicNum, ProvNum,
                CodeNum, ToothNum, Surf,
                ProcStatus, ProcDate, DateEntryC,
                ProcFee, Priority, ClaimNote, AptNum, Dx
            ) VALUES (
                @PatNum, @ClinicNum, @ProvNum,
                @CodeNum, @ToothNum, @Surf,
                @ProcStatus, @ProcDate, NOW(),
                @ProcFee, @Priority, @Note, @AptNum, @DxNum
            );
            SELECT LAST_INSERT_ID();",
            req);
    }

    /// <summary>Set procedure status to Complete (2)</summary>
    public async Task<bool> SetCompleteAsync(long procNum, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();
        var clinicFilter = allowedClinics.Count > 0
            ? "AND ClinicNum IN @AllowedClinics" : "";

        var rows = await conn.ExecuteAsync($@"
            UPDATE procedurelog SET ProcStatus = 2
            WHERE ProcNum = @ProcNum {clinicFilter}",
            new { ProcNum = procNum, AllowedClinics = allowedClinics });
        return rows > 0;
    }
}
