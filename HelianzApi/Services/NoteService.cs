using System.Data;
using Dapper;
using HelianzApi.Data;
using HelianzApi.Models;

namespace HelianzApi.Services;

public class NoteService
{
    private readonly DatabaseConnectionFactory _db;

    public NoteService(DatabaseConnectionFactory db) => _db = db;

    public async Task<NoteSearchResult> SearchAsync(NoteSearchRequest req, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        var conditions = new List<string>();
        var parameters = new DynamicParameters();

        // commlog has no ClinicNum column — filter by patient only
        if (req.PatNum.HasValue)
        {
            conditions.Add("c.PatNum = @PatNum");
            parameters.Add("PatNum", req.PatNum.Value);
        }
        if (req.DateFrom.HasValue)
        {
            conditions.Add("c.CommDateTime >= @DateFrom");
            parameters.Add("DateFrom", req.DateFrom.Value.Date);
        }
        if (req.DateTo.HasValue)
        {
            conditions.Add("c.CommDateTime < @DateTo");
            parameters.Add("DateTo", req.DateTo.Value.Date.AddDays(1));
        }

        var where = conditions.Count > 0 ? "WHERE " + string.Join(" AND ", conditions) : "";

        var countSql = $"SELECT COUNT(*) FROM commlog c {where}";
        var totalCount = await conn.ExecuteScalarAsync<int>(countSql, parameters);

        parameters.Add("PageSize", req.PageSize);
        parameters.Add("Offset", (req.Page - 1) * req.PageSize);

        var sql = $@"
            SELECT c.CommlogNum, c.PatNum,
                   CONCAT(p.LName, ', ', p.FName) AS PatientName,
                   0 AS ClinicNum, 0 AS ProvNum, '' AS ProvName,
                   c.CommDateTime, c.CommType,
                   def.ItemName AS CommTypeName,
                   c.Note, c.UserNum,
                   u.UserName,
                   c.DateTStamp, 0 AS AptNum
            FROM commlog c
            LEFT JOIN patient p ON c.PatNum = p.PatNum
            LEFT JOIN definition def ON c.CommType = def.DefNum
            LEFT JOIN userod u ON c.UserNum = u.UserNum
            {where}
            ORDER BY c.CommDateTime DESC
            LIMIT @PageSize OFFSET @Offset";

        var notes = (await conn.QueryAsync<ClinicalNote>(sql, parameters)).ToList();

        return new NoteSearchResult { Notes = notes, TotalCount = totalCount };
    }

    public async Task<ClinicalNote?> GetByIdAsync(long commlogNum, List<long> allowedClinics)
    {
        using var conn = _db.CreateConnection();

        return await conn.QueryFirstOrDefaultAsync<ClinicalNote>(@"
            SELECT c.CommlogNum, c.PatNum,
                   CONCAT(p.LName, ', ', p.FName) AS PatientName,
                   0 AS ClinicNum, 0 AS ProvNum, '' AS ProvName,
                   c.CommDateTime, c.CommType,
                   def.ItemName AS CommTypeName,
                   c.Note, c.UserNum,
                   u.UserName,
                   c.DateTStamp, 0 AS AptNum
            FROM commlog c
            LEFT JOIN patient p ON c.PatNum = p.PatNum
            LEFT JOIN definition def ON c.CommType = def.DefNum
            LEFT JOIN userod u ON c.UserNum = u.UserNum
            WHERE c.CommlogNum = @CommlogNum",
            new { CommlogNum = commlogNum });
    }

    public async Task<long> CreateAsync(NoteCreateRequest req, long userId)
    {
        using var conn = _db.CreateConnection();

        return await conn.ExecuteScalarAsync<long>(@"
            INSERT INTO commlog (
                PatNum, CommDateTime, CommType, Note,
                UserNum, DateTStamp
            ) VALUES (
                @PatNum, NOW(), @CommType, @Note,
                @UserNum, NOW()
            );
            SELECT LAST_INSERT_ID();",
            new { req.PatNum, req.CommType, req.Note, UserNum = userId });
    }
}
