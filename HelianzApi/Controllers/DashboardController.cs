using System.Data;
using Dapper;
using HelianzApi.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/dashboard")]
[Authorize]
public class DashboardController : ControllerBase
{
    private readonly DatabaseConnectionFactory _db;

    public DashboardController(DatabaseConnectionFactory db) => _db = db;

    [HttpGet("kpis")]
    public async Task<IActionResult> GetKpis()
    {
        using var conn = _db.CreateConnection();

        // Today's appointments count
        var todayAppts = await conn.ExecuteScalarAsync<int>(@"
            SELECT COUNT(*) FROM appointment
            WHERE AptDateTime >= CURDATE() AND AptDateTime < DATE_ADD(CURDATE(), INTERVAL 1 DAY)
              AND AptStatus IN (1, 6)");

        // Waiting room (appointments seated/arrived today)
        var waitingRoom = await conn.ExecuteScalarAsync<int>(@"
            SELECT COUNT(*) FROM appointment
            WHERE AptDateTime >= CURDATE() AND AptDateTime < DATE_ADD(CURDATE(), INTERVAL 1 DAY)
              AND AptStatus = 6");

        // Today's production (completed procedures)
        var todayProd = await conn.ExecuteScalarAsync<decimal>(@"
            SELECT IFNULL(SUM(ProcFee), 0) FROM procedurelog
            WHERE ProcDate >= CURDATE() AND ProcDate < DATE_ADD(CURDATE(), INTERVAL 1 DAY)
              AND ProcStatus = 2");

        // Pending prescriptions (today)
        var pendingRx = await conn.ExecuteScalarAsync<int>(@"
            SELECT COUNT(*) FROM rxpat WHERE RxDate >= CURDATE()");

        // Active patients
        var activePatients = await conn.ExecuteScalarAsync<int>(@"
            SELECT COUNT(*) FROM patient WHERE PatStatus = 0");

        // Month revenue
        var monthRevenue = await conn.ExecuteScalarAsync<decimal>(@"
            SELECT IFNULL(SUM(PayAmt), 0) FROM payment
            WHERE PayDate >= DATE_FORMAT(CURDATE(), '%Y-%m-01')");

        return Ok(new
        {
            todayAppointments = todayAppts,
            waitingRoom = waitingRoom,
            todayProduction = todayProd,
            pendingRx = pendingRx,
            activePatients = activePatients,
            monthRevenue = monthRevenue
        });
    }

    [HttpGet("revenue/trends")]
    public async Task<IActionResult> GetRevenueTrends(
        [FromQuery] string? startDate, [FromQuery] string? endDate)
    {
        using var conn = _db.CreateConnection();
        var start = startDate ?? DateTime.UtcNow.AddMonths(-6).ToString("yyyy-MM-01");
        var end = endDate ?? DateTime.UtcNow.ToString("yyyy-MM-dd");

        var items = await conn.QueryAsync(@"
            SELECT
                DATE_FORMAT(ProcDate, '%Y-%m') AS Period,
                SUM(CASE WHEN ProcStatus = 2 THEN ProcFee ELSE 0 END) AS Production,
                SUM(CASE WHEN ProcStatus = 2 THEN ProcFee ELSE 0 END) AS Collections,
                0 AS Adjustments
            FROM procedurelog
            WHERE ProcDate >= @Start AND ProcDate < DATE_ADD(@End, INTERVAL 1 DAY)
            GROUP BY DATE_FORMAT(ProcDate, '%Y-%m')
            ORDER BY Period",
            new { Start = start, End = end });

        return Ok(items);
    }

    [HttpGet("providers")]
    public async Task<IActionResult> GetProviders()
    {
        using var conn = _db.CreateConnection();

        var items = await conn.QueryAsync(@"
            SELECT
                p.ProvNum, p.Abbr AS ProvName,
                IFNULL(SUM(pl.ProcFee), 0) AS Production,
                COUNT(DISTINCT pl.PatNum) AS Patients
            FROM provider p
            LEFT JOIN procedurelog pl ON p.ProvNum = pl.ProvNum
                AND pl.ProcDate >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
                AND pl.ProcStatus = 2
            WHERE p.IsHidden = 0
            GROUP BY p.ProvNum, p.Abbr
            ORDER BY Production DESC");

        return Ok(items);
    }

    [HttpGet("ar")]
    public async Task<IActionResult> GetArAging()
    {
        using var conn = _db.CreateConnection();

        // AR aging — simplified: patients with balance
        var items = await conn.QueryAsync(@"
            SELECT
                CASE
                    WHEN DateFirstVisit >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN '0-30 days'
                    WHEN DateFirstVisit >= DATE_SUB(CURDATE(), INTERVAL 60 DAY) THEN '31-60 days'
                    WHEN DateFirstVisit >= DATE_SUB(CURDATE(), INTERVAL 90 DAY) THEN '61-90 days'
                    ELSE '90+ days'
                END AS `Range`,
                COUNT(*) AS Count,
                0 AS Amount
            FROM patient
            WHERE PatStatus = 0
            GROUP BY `Range`
            ORDER BY `Range`");

        return Ok(items);
    }
}
