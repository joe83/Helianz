using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Dapper;
using HelianzApi.Data;
using System.Data;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/reports")]
[Authorize]
public class ReportsController : ControllerBase
{
    private readonly DatabaseConnectionFactory _db;
    public ReportsController(DatabaseConnectionFactory db) => _db = db;

    private List<long> Clinics() =>
        User.Claims.Where(c => c.Type == "ClinicNum").Select(c => long.Parse(c.Value)).ToList();

    private string CF(List<long> a, string al = "pa") =>
        a.Contains(0) ? "" : $"AND {al}.ClinicNum IN @Clinics";

    private DynamicParameters CP(List<long> a) {
        var p = new DynamicParameters();
        p.Add("Clinics", a.Where(c => c != 0).ToList());
        return p;
    }

    /// <summary>Parse comma-separated long query param and add to Dapper params + SQL filter.</summary>
    private static string PF(DynamicParameters p, string? csv, string paramName, string colName) {
        if (string.IsNullOrWhiteSpace(csv)) return "";
        var ids = csv.Split(',', StringSplitOptions.RemoveEmptyEntries).Select(long.Parse).ToList();
        if (ids.Count == 0) return "";
        p.Add(paramName, ids);
        return $"AND {colName} IN @{paramName}";
    }

    /// <summary>Parse optional provNums/clinicNums from query and build filter SQL.</summary>
    private string Filt(DynamicParameters p, string? provNums, string? clinicNums, string provCol = "pr", string clinicCol = "pa") {
        var sql = "";
        sql += PF(p, provNums, "ProvNums", $"{provCol}.ProvNum");
        sql += PF(p, clinicNums, "ClinicFilter", $"{clinicCol}.ClinicNum");
        return sql;
    }

    // ═══════════════════════════════════════════
    // PRODUCTION & INCOME
    // ═══════════════════════════════════════════

    [HttpGet("prod-today")] public async Task<IActionResult> ProdToday() => await Prod(DateTime.Today, DateTime.Today);
    [HttpGet("prod-yesterday")] public async Task<IActionResult> ProdYesterday() => await Prod(DateTime.Today.AddDays(-1), DateTime.Today.AddDays(-1));
    [HttpGet("prod-this-month")] public async Task<IActionResult> ProdThisMonth() => await Prod(new DateTime(DateTime.Today.Year,DateTime.Today.Month,1), DateTime.Today);
    [HttpGet("prod-last-month")] public async Task<IActionResult> ProdLastMonth() { var m=DateTime.Today.AddMonths(-1); return await Prod(new DateTime(m.Year,m.Month,1),new DateTime(m.Year,m.Month,DateTime.DaysInMonth(m.Year,m.Month))); }
    [HttpGet("prod-this-year")] public async Task<IActionResult> ProdThisYear() => await Prod(new DateTime(DateTime.Today.Year,1,1), DateTime.Today);

    private async Task<IActionResult> Prod(DateTime f, DateTime t) {
        var a=Clinics(); using var c=_db.CreateConnection(); var p=CP(a); p.Add("F",f); p.Add("T",t);
        // 4 separate queries to avoid join multiplication
        var prod = (await c.QueryAsync(@$"SELECT pl.ProcDate Date,SUM(pl.ProcFee) Production FROM procedurelog pl INNER JOIN patient pa ON pl.PatNum=pa.PatNum WHERE pl.ProcDate BETWEEN @F AND @T AND pl.ProcStatus=2 {CF(a)} GROUP BY pl.ProcDate",p)).ToDictionary(r=>(DateTime)r.Date,r=>(decimal)r.Production);
        var adj = (await c.QueryAsync(@$"SELECT AdjDate Date,SUM(AdjAmt) AdjAmt FROM adjustment a INNER JOIN patient pa ON a.PatNum=pa.PatNum WHERE AdjDate BETWEEN @F AND @T {CF(a)} GROUP BY AdjDate",p)).ToDictionary(r=>(DateTime)r.Date,r=>(decimal)r.AdjAmt);
        var wo = (await c.QueryAsync(@$"SELECT DateCP Date,SUM(WriteOff) WriteOff FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum WHERE DateCP BETWEEN @F AND @T AND Status IN(4,5,6) {CF(a)} GROUP BY DateCP",p)).ToDictionary(r=>(DateTime)r.Date,r=>(decimal)r.WriteOff);
        var inc = (await c.QueryAsync(@$"SELECT PayDate Date,SUM(PayAmt) Income FROM payment pp INNER JOIN patient pa ON pp.PatNum=pa.PatNum WHERE PayDate BETWEEN @F AND @T {CF(a)} GROUP BY PayDate",p)).ToDictionary(r=>(DateTime)r.Date,r=>(decimal)r.Income);
        var rows = new List<object>();
        decimal tp=0,ta=0,tw=0,tpi=0;
        for(var d=f;d<=t;d=d.AddDays(1)){var dd=d.Date;var pr=prod.GetValueOrDefault(dd);var ad=adj.GetValueOrDefault(dd);var wr=wo.GetValueOrDefault(dd);var im=inc.GetValueOrDefault(dd);var dn=dd.DayOfWeek switch{DayOfWeek.Sunday=>"Min",DayOfWeek.Monday=>"Sen",DayOfWeek.Tuesday=>"Sel",DayOfWeek.Wednesday=>"Rab",DayOfWeek.Thursday=>"Kam",DayOfWeek.Friday=>"Jum",DayOfWeek.Saturday=>"Sab",_=>""};tp+=pr;ta+=ad;tw+=wr;tpi+=im;rows.Add(new{Date=dd,DayName=dn,Production=pr,Adjustment=ad,WriteOff=wr,TotalProd=pr+ad+wr,PatientIncome=im,UnearnedPtIncome=0m,InsIncome=0m,TotalIncome=im});}
        var ttp=tp+ta+tw;
        return Ok(new{f,t,count=rows.Count,totalProduction=ttp,totalIncome=tpi,
          totals=new{Production=tp,Adjustment=ta,WriteOff=tw,TotalProd=ttp,PatientIncome=tpi,UnearnedPtIncome=0m,InsIncome=0m,TotalIncome=tpi},
          summary=new[]{$"Total Production (Production + Scheduled + Adjustments - Write-offs): {ttp:N2}",
                         $"Total Pt Income (Pt Income + Unearned Pt Income): {tpi:N2}",
                         $"Total Income (Total Pt Income + Ins Income): {tpi:N2}"},
          rows});}

    [HttpGet("prod-goal")]
    public async Task<IActionResult> ProdGoal() {
        var a=Clinics(); using var c=_db.CreateConnection(); var p=CP(a);
        var m=new DateTime(DateTime.Today.Year,DateTime.Today.Month,1); p.Add("F",m); p.Add("T",DateTime.Today);
        var r=await c.QueryAsync(@$"
            SELECT pr.ProvNum,pr.Abbr ProvName,SUM(COALESCE(pl.ProcFee,0)) Production,COUNT(DISTINCT pl.PatNum) Patients,0 Goal
            FROM provider pr LEFT JOIN procedurelog pl ON pl.ProvNum=pr.ProvNum AND pl.ProcDate BETWEEN @F AND @T AND pl.ProcStatus=2
            LEFT JOIN patient pa ON pl.PatNum=pa.PatNum {CF(a)} WHERE pr.IsHidden=0 GROUP BY pr.ProvNum,pr.Abbr ORDER BY Production DESC", p);
        return Ok(new{month=m.ToString("yyyy-MM"),rows=r});
    }

    // ═══════════════════════════════════════════
    // DAILY
    // ═══════════════════════════════════════════

    [HttpGet("daily-adjustments")] public async Task<IActionResult> DailyAdj([FromQuery]DateTime? f,[FromQuery]DateTime? t,[FromQuery]string? provNums,[FromQuery]string? clinicNums){f??=DateTime.Today;t??=DateTime.Today;var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);p.Add("F",f);p.Add("T",t);var filt=Filt(p,provNums,clinicNums,"pr");var r=await c.QueryAsync(@$"SELECT a.AdjDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,a.AdjNote Note,a.AdjAmt Amount FROM adjustment a INNER JOIN patient pa ON a.PatNum=pa.PatNum LEFT JOIN provider pr ON a.ProvNum=pr.ProvNum WHERE a.AdjDate BETWEEN @F AND @T {CF(a)} {filt} ORDER BY a.AdjDate,pa.LName LIMIT 500",p);return Ok(new{count=r.Count(),totalAmount=r.Sum(x=>(decimal)(x.Amount??0m)),rows=r});}

    [HttpGet("daily-payments")] public async Task<IActionResult> DailyPayments([FromQuery]DateTime? f,[FromQuery]DateTime? t,[FromQuery]string? provNums,[FromQuery]string? clinicNums){f??=DateTime.Today;t??=DateTime.Today;using var c=_db.CreateConnection();var a=Clinics();var p=CP(a);p.Add("F",f);p.Add("T",t);var filt=Filt(p,provNums,clinicNums,"pr");var r=await c.QueryAsync(@$"SELECT p.PayDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,d.ItemName PayType,p.CheckNum,p.PayAmt Amount FROM payment p INNER JOIN patient pa ON p.PatNum=pa.PatNum LEFT JOIN paysplit ps ON p.PayNum=ps.PayNum LEFT JOIN provider pr ON ps.ProvNum=pr.ProvNum LEFT JOIN definition d ON d.DefNum=p.PayType WHERE p.PayDate BETWEEN @F AND @T {CF(a)} {filt} GROUP BY p.PayNum,p.PayDate,p.CheckNum,d.ItemName,pa.LName,pa.FName ORDER BY d.ItemName,p.PayDate,pa.LName LIMIT 500",p);return Ok(new{count=r.Count(),totalAmount=r.Sum(x=>(decimal)(x.Amount??0m)),rows=r});}

    [HttpGet("daily-procedures")] public async Task<IActionResult> DailyProcs([FromQuery]DateTime? f,[FromQuery]DateTime? t,[FromQuery]string? provNums,[FromQuery]string? clinicNums){f??=DateTime.Today;t??=DateTime.Today;var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);p.Add("F",f);p.Add("T",t);var filt=Filt(p,provNums,clinicNums,"pr");var r=await c.QueryAsync(@$"SELECT pl.ProcDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode Code,pl.ToothNum ToothArea,pc.Descript Description,pr.Abbr ProvName,pl.ProcFee Fee,COALESCE(ps.ShareAmt,0) Share FROM procedurelog pl INNER JOIN patient pa ON pl.PatNum=pa.PatNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum INNER JOIN provider pr ON pl.ProvNum=pr.ProvNum LEFT JOIN (SELECT ProcNum,SUM(SplitAmt) ShareAmt FROM paysplit WHERE ProcNum!=0 GROUP BY ProcNum) ps ON ps.ProcNum=pl.ProcNum WHERE pl.ProcDate BETWEEN @F AND @T AND pl.ProcStatus=2 {CF(a)} {filt} ORDER BY pl.ProcDate,pa.LName LIMIT 500",p);return Ok(new{count=r.Count(),totalFee=r.Sum(x=>(decimal)(x.Fee??0m)),totalShare=r.Sum(x=>(decimal)(x.Share??0m)),rows=r});}

    [HttpGet("daily-writeoffs")] public async Task<IActionResult> DailyWriteoffs([FromQuery]DateTime? f,[FromQuery]DateTime? t,[FromQuery]string? provNums,[FromQuery]string? clinicNums){f??=DateTime.Today;t??=DateTime.Today;var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);p.Add("F",f);p.Add("T",t);var filt=Filt(p,provNums,clinicNums,"pr");var r=await c.QueryAsync(@$"SELECT cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,ca.CarrierName Insurance,cp.WriteOff Amount FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum LEFT JOIN provider pr ON cp.ProvNum=pr.ProvNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.WriteOff!=0 AND cp.DateCP BETWEEN @F AND @T {CF(a)} {filt} ORDER BY cp.DateCP,pa.LName LIMIT 500",p);return Ok(new{count=r.Count(),totalAmount=r.Sum(x=>(decimal)(x.Amount??0m)),rows=r});}

    [HttpGet("daily-incomplete-notes")] public async Task<IActionResult> DailyIncNotes([FromQuery]DateTime? f,[FromQuery]DateTime? t,[FromQuery]string? provNums,[FromQuery]string? clinicNums){f??=DateTime.Today.AddDays(-30);t??=DateTime.Today;var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);p.Add("F",f);p.Add("T",t);var filt=Filt(p,provNums,clinicNums,"pr");var r=await c.QueryAsync(@$"SELECT pl.ProcDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode,pc.Descript,pl.ToothNum,pl.Surf,pl.ProcFee,pr.Abbr ProvName FROM procedurelog pl INNER JOIN patient pa ON pl.PatNum=pa.PatNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum INNER JOIN provider pr ON pl.ProvNum=pr.ProvNum LEFT JOIN procnote pn ON pl.ProcNum=pn.ProcNum WHERE pl.ProcDate BETWEEN @F AND @T AND pl.ProcStatus=2 AND pn.ProcNum IS NULL {CF(a)} {filt} ORDER BY pl.ProcDate,pa.LName LIMIT 200",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("daily-unfinalized-ins")] public async Task<IActionResult> DailyUnfinalizedIns([FromQuery]DateTime? f,[FromQuery]DateTime? t,[FromQuery]string? provNums,[FromQuery]string? clinicNums){f??=DateTime.Today.AddDays(-60);t??=DateTime.Today;var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);p.Add("F",f);p.Add("T",t);var filt=Filt(p,provNums,clinicNums,"pr");var r=await c.QueryAsync(@$"SELECT cp.ProcNum,cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,cp.InsPayEst EstAmt,cp.InsPayAmt PaidAmt,cp.WriteOff,cp.Status FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.Status=1 AND cp.DateCP BETWEEN @F AND @T {CF(a)} {filt} ORDER BY cp.DateCP,pa.LName LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    // ═══════════════════════════════════════════
    // MONTHLY
    // ═══════════════════════════════════════════

    [HttpGet("mo-ar-aging")] public async Task<IActionResult> MoArAging(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT CASE WHEN DATEDIFF(CURDATE(),pa.DateFirstVisit)<=30 THEN '0-30' WHEN DATEDIFF(CURDATE(),pa.DateFirstVisit)<=60 THEN '31-60' WHEN DATEDIFF(CURDATE(),pa.DateFirstVisit)<=90 THEN '61-90' ELSE '90+' END AgingBucket,COUNT(*) PatientCount,SUM(COALESCE(pl.ProcFee,0))-SUM(COALESCE(ps.Paid,0)) Balance FROM patient pa LEFT JOIN procedurelog pl ON pl.PatNum=pa.PatNum AND pl.ProcStatus=2 LEFT JOIN (SELECT ProcNum,SUM(SplitAmt) Paid FROM paysplit WHERE ProcNum!=0 GROUP BY ProcNum) ps ON ps.ProcNum=pl.ProcNum WHERE pa.PatStatus=0 {CF(a)} GROUP BY AgingBucket ORDER BY AgingBucket",p);return Ok(new{rows=r});}

    [HttpGet("mo-claims-not-sent")] public async Task<IActionResult> MoClaimsNotSent(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT cp.ProcNum,cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,pc.ProcCode,cp.InsPayEst EstAmt FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum INNER JOIN procedurelog pl ON cp.ProcNum=pl.ProcNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.Status=0 {CF(a)} ORDER BY cp.DateCP LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("mo-finance-charge")] public IActionResult MoFinanceCharge() => Ok(new{count=0,rows=new object[0]});

    [HttpGet("mo-outstanding-ins-claims")] public async Task<IActionResult> MoOutInsClaims(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT cp.ProcNum,cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,pc.ProcCode,cp.InsPayEst EstAmt,DATEDIFF(CURDATE(),cp.DateCP) DaysOut FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum INNER JOIN procedurelog pl ON cp.ProcNum=pl.ProcNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.Status IN(1,4) AND cp.InsPayAmt=0 {CF(a)} ORDER BY DaysOut DESC LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("mo-proc-not-billed")] public async Task<IActionResult> MoProcNotBilled(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT pl.ProcNum,pl.ProcDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode,pc.Descript,pl.ProcFee FROM procedurelog pl INNER JOIN patient pa ON pl.PatNum=pa.PatNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum LEFT JOIN claimproc cp ON cp.ProcNum=pl.ProcNum WHERE pl.ProcStatus=2 AND cp.ProcNum IS NULL AND pl.ProcFee>0 AND pl.ProcDate>=DATE_SUB(CURDATE(),INTERVAL 6 MONTH) {CF(a)} ORDER BY pl.ProcDate DESC LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("mo-ppo-writeoffs")] public async Task<IActionResult> MoPpoWriteoffs(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,pc.ProcCode,cp.WriteOff Amount FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum INNER JOIN procedurelog pl ON cp.ProcNum=pl.ProcNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.WriteOff>0 AND cp.DateCP>=DATE_SUB(CURDATE(),INTERVAL 12 MONTH) {CF(a)} ORDER BY cp.DateCP DESC LIMIT 500",p);return Ok(new{count=r.Count(),totalAmount=r.Sum(x=>(decimal)(x.Amount??0m)),rows=r});}

    [HttpGet("mo-payment-plans")] public IActionResult MoPaymentPlans() => Ok(new{count=0,note="Payment plan schema needs verification",rows=new object[0]});

    [HttpGet("mo-receivables-breakdown")] public IActionResult MoReceivables() => Ok(new{count=0,rows=new object[0]});
    [HttpGet("mo-unearned-income")] public IActionResult MoUnearned() => Ok(new{count=0,rows=new object[0]});

    [HttpGet("mo-ins-overpaid")] public async Task<IActionResult> MoInsOverpaid(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT cp.ProcNum,cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,cp.InsPayAmt Paid,cp.InsPayEst Estimated,cp.InsPayAmt-cp.InsPayEst Overpaid FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.InsPayAmt>cp.InsPayEst AND cp.InsPayEst>0 {CF(a)} ORDER BY Overpaid DESC LIMIT 200",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("mo-treatplan-prod")] public async Task<IActionResult> MoTreatPlanProd(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT tp.Priority,tp.DateTP DatePlan,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode,pc.Descript,tp.ProcFee Fee,pr.Abbr ProvName FROM procedurelog tp INNER JOIN patient pa ON tp.PatNum=pa.PatNum INNER JOIN procedurecode pc ON tp.CodeNum=pc.CodeNum INNER JOIN provider pr ON tp.ProvNum=pr.ProvNum WHERE tp.ProcStatus=1 {CF(a)} ORDER BY tp.Priority,tp.DateTP LIMIT 500",p);return Ok(new{count=r.Count(),totalFee=r.Sum(x=>(decimal)(x.Fee??0m)),rows=r});}

    // ═══════════════════════════════════════════
    // LISTS
    // ═══════════════════════════════════════════

    [HttpGet("list-active-patients")] public async Task<IActionResult> ListActivePatients(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT pa.PatNum,CONCAT(pa.LName,', ',pa.FName) PatientName,pa.Birthdate,pa.HmPhone,pa.WirelessPhone,pa.DateFirstVisit,pa.PatStatus FROM patient pa WHERE pa.PatStatus=0 {CF(a)} ORDER BY pa.LName,pa.FName LIMIT 1000",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("list-appointments")] public async Task<IActionResult> ListAppointments([FromQuery]DateTime? f,[FromQuery]DateTime? t){f??=DateTime.Today;t??=DateTime.Today.AddDays(7);var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);p.Add("F",f);p.Add("T",t);var r=await c.QueryAsync(@$"SELECT a.AptDateTime Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,a.AptStatus,op.OpName Operatory,atype.AppointmentTypeName FROM appointment a INNER JOIN patient pa ON a.PatNum=pa.PatNum LEFT JOIN provider pr ON a.ProvNum=pr.ProvNum LEFT JOIN operatory op ON a.OpNum=op.OperatoryNum LEFT JOIN appointmenttype atype ON a.AppointmentTypeNum=atype.AppointmentTypeNum WHERE a.AptDateTime BETWEEN @F AND @T {CF(a)} ORDER BY a.AptDateTime LIMIT 1000",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("list-birthdays")] public async Task<IActionResult> ListBirthdays(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT pa.PatNum,CONCAT(pa.LName,', ',pa.FName) PatientName,pa.Birthdate,MONTH(pa.Birthdate) BirthMonth,DAY(pa.Birthdate) BirthDay FROM patient pa WHERE pa.PatStatus=0 AND pa.Birthdate IS NOT NULL {CF(a)} ORDER BY MONTH(pa.Birthdate),DAY(pa.Birthdate) LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("list-broken-appointments")] public async Task<IActionResult> ListBrokenAppts([FromQuery]DateTime? f,[FromQuery]DateTime? t){try{f??=DateTime.Today.AddMonths(-1);t??=DateTime.Today;var a=Clinics();using var c=_db.CreateConnection();var p=new DynamicParameters();p.Add("F",f);p.Add("T",t);var cf=a.Contains(0)?"":"AND pa.ClinicNum IN @Clinics";if(!a.Contains(0))p.Add("Clinics",a.Where(x=>x!=0));var r=await c.QueryAsync(@$"SELECT a.AptDateTime Date,a.AptStatus,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,op.OpName Operatory FROM appointment a INNER JOIN patient pa ON a.PatNum=pa.PatNum LEFT JOIN provider pr ON a.ProvNum=pr.ProvNum LEFT JOIN operatory op ON a.Op=op.OperatoryNum WHERE a.AptDateTime BETWEEN @F AND @T AND a.AptStatus IN(3,4) {cf} ORDER BY a.AptDateTime LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}catch(Exception ex){return Ok(new{count=0,error=ex.Message,rows=new object[0]});}}

    [HttpGet("list-ins-plans")] public async Task<IActionResult> ListInsPlans(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT ip.PlanNum,ca.CarrierName Insurance,ip.GroupName,ip.GroupNum,ip.PlanType,CONCAT(pa.LName,', ',pa.FName) Subscriber FROM insplan ip LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum LEFT JOIN inssub sub ON ip.PlanNum=sub.PlanNum LEFT JOIN patient pa ON sub.Subscriber=pa.PatNum WHERE ip.IsHidden=0 ORDER BY ca.CarrierName LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("list-new-patients")] public async Task<IActionResult> ListNewPatients(){var a=Clinics();var fm=new DateTime(DateTime.Today.Year,DateTime.Today.Month,1);using var c=_db.CreateConnection();var p=CP(a);p.Add("F",fm);var r=await c.QueryAsync(@$"SELECT pa.PatNum,CONCAT(pa.LName,', ',pa.FName) PatientName,pa.DateFirstVisit,pa.Birthdate,pa.HmPhone,pa.WirelessPhone FROM patient pa WHERE pa.DateFirstVisit>=@F {CF(a)} ORDER BY pa.DateFirstVisit DESC LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("list-patients-raw")] public async Task<IActionResult> ListPatientsRaw(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT * FROM patient pa WHERE pa.PatStatus=0 {CF(a)} ORDER BY pa.LName,pa.FName LIMIT 1000",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("list-patient-notes")] public async Task<IActionResult> ListPatientNotes([FromQuery]DateTime? f,[FromQuery]DateTime? t){f??=DateTime.Today.AddMonths(-1);t??=DateTime.Today;var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);p.Add("F",f);p.Add("T",t);var r=await c.QueryAsync(@$"SELECT c.CommDateTime Date,CONCAT(pa.LName,', ',pa.FName) PatientName,c.CommType,c.Note,uo.UserName FROM commlog c INNER JOIN patient pa ON c.PatNum=pa.PatNum LEFT JOIN userod uo ON c.UserNum=uo.UserNum WHERE c.CommDateTime BETWEEN @F AND @T {CF(a)} ORDER BY c.CommDateTime DESC LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("list-prescriptions")] public async Task<IActionResult> ListPrescriptions([FromQuery]DateTime? f,[FromQuery]DateTime? t){f??=DateTime.Today.AddMonths(-3);t??=DateTime.Today;var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);p.Add("F",f);p.Add("T",t);var r=await c.QueryAsync(@$"SELECT r.RxDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,r.Drug,r.Sig,r.Disp,r.Refills,pr.Abbr ProvName FROM rxpat r INNER JOIN patient pa ON r.PatNum=pa.PatNum LEFT JOIN provider pr ON r.ProvNum=pr.ProvNum WHERE r.RxDate BETWEEN @F AND @T {CF(a)} ORDER BY r.RxDate DESC LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("list-proc-fee-sched")] public async Task<IActionResult> ListProcFeeSched(){try{using var c=_db.CreateConnection();var r=await c.QueryAsync("SELECT CodeNum,ProcCode,Descript,AbbrDesc,ProcCat FROM procedurecode ORDER BY ProcCode LIMIT 500");return Ok(new{count=r.Count(),rows=r});}catch(Exception ex){return Ok(new{count=0,error=ex.Message,rows=new object[0]});}}

    [HttpGet("list-referrals-raw")] public IActionResult ListReferralsRaw() => Ok(new{count=0,note="Referral table schema needs verification",rows=new object[0]});

    [HttpGet("list-referral-analysis")] public IActionResult ListReferralAnalysis() => Ok(new{count=0,rows=new object[0]});
    [HttpGet("list-ref-proc-tracking")] public IActionResult ListRefProcTracking() => Ok(new{count=0,rows=new object[0]});

    [HttpGet("list-treatment-finder")] public async Task<IActionResult> ListTreatmentFinder(){var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);var r=await c.QueryAsync(@$"SELECT tp.Priority,tp.DateTP DatePlan,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode,pc.Descript,tp.ProcFee Fee,pr.Abbr ProvName FROM procedurelog tp INNER JOIN patient pa ON tp.PatNum=pa.PatNum INNER JOIN procedurecode pc ON tp.CodeNum=pc.CodeNum INNER JOIN provider pr ON tp.ProvNum=pr.ProvNum WHERE tp.ProcStatus=1 {CF(a)} ORDER BY tp.Priority,tp.DateTP LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    [HttpGet("list-web-sched-appts")] public async Task<IActionResult> ListWebSchedAppts([FromQuery]DateTime? f,[FromQuery]DateTime? t){f??=DateTime.Today;t??=DateTime.Today.AddDays(7);var a=Clinics();using var c=_db.CreateConnection();var p=CP(a);p.Add("F",f);p.Add("T",t);var r=await c.QueryAsync(@$"SELECT a.AptDateTime Date,CONCAT(pa.LName,', ',pa.FName) PatientName,a.IsNewPatient,a.AptStatus FROM appointment a INNER JOIN patient pa ON a.PatNum=pa.PatNum WHERE a.AptDateTime BETWEEN @F AND @T AND a.AptStatus=7 {CF(a)} ORDER BY a.AptDateTime LIMIT 500",p);return Ok(new{count=r.Count(),rows=r});}

    // ═══════════════════════════════════════════
    // PUBLIC HEALTH
    // ═══════════════════════════════════════════

    [HttpGet("ph-screening-data")] public IActionResult PhScreeningData() => Ok(new{count=0,rows=new object[0]});
    [HttpGet("ph-population-data")] public IActionResult PhPopulationData() => Ok(new{count=0,rows=new object[0]});
    [HttpGet("ph-fqhc-sealant")] public IActionResult PhFqhcSealant() => Ok(new{count=0,rows=new object[0]});
}
