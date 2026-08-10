import { Router, Request, Response } from 'express';
import { authenticate, getAllowedClinics } from '../middleware/auth';
import pool from '../config/database';
import { RowDataPacket } from 'mysql2';

const router = Router();
router.use(authenticate);

function clinicFilter(allowed: number[], alias = 'pa'): string {
  const e = allowed.filter(c => c !== 0);
  return e.length > 0 ? `AND ${alias}.ClinicNum IN (${e.map(() => '?').join(',')})` : '';
}
function clinicParams(allowed: number[]): number[] { return allowed.filter(c => c !== 0); }
function parseIds(csv?: string): number[] { if (!csv) return []; return csv.split(',').map(Number).filter(n => !isNaN(n)); }
function provFilter(pn?: string, col = 'pr'): string { const ids = parseIds(pn); return ids.length ? `AND ${col}.ProvNum IN (${ids.map(() => '?').join(',')})` : ''; }
function clinFilterEx(cn?: string, col = 'pa'): string { const ids = parseIds(cn); return ids.length ? `AND ${col}.ClinicNum IN (${ids.map(() => '?').join(',')})` : ''; }
const DAYS: Record<number, string> = { 0: 'Min', 1: 'Sen', 2: 'Sel', 3: 'Rab', 4: 'Kam', 5: 'Jum', 6: 'Sab' };
function td(): string { return new Date().toISOString().substring(0, 10); }
function addD(d: string, n: number): string { const dt = new Date(d); dt.setDate(dt.getDate() + n); return dt.toISOString().substring(0, 10); }
function addM(d: string, n: number): string { const dt = new Date(d); dt.setMonth(dt.getMonth() + n); return dt.toISOString().substring(0, 10); }
function ms(d: string): string { return d.substring(0, 7) + '-01'; }
function me(d: string): string { const dt = new Date(d); return new Date(dt.getFullYear(), dt.getMonth() + 1, 0).toISOString().substring(0, 10); }
function ys(d: string): string { return d.substring(0, 4) + '-01-01'; }
function ds(d: any): string { return d instanceof Date ? d.toISOString().substring(0, 10) : String(d).substring(0, 10); }

// ═══ PRODUCTION & INCOME ═══
router.get('/prod-today', async (rq, rs) => prod(rq, rs, td(), td()));
router.get('/prod-yesterday', async (rq, rs) => prod(rq, rs, addD(td(), -1), addD(td(), -1)));
router.get('/prod-this-month', async (rq, rs) => prod(rq, rs, ms(td()), td()));
router.get('/prod-last-month', async (rq, rs) => { const m = addM(td(), -1); return prod(rq, rs, ms(m), me(m)); });
router.get('/prod-this-year', async (rq, rs) => prod(rq, rs, ys(td()), td()));

async function prod(req: Request, res: Response, f: string, t: string) {
  try { const a = getAllowedClinics(req), cf = clinicFilter(a), cp = clinicParams(a), c = await pool.getConnection();
    try { const [pr] = await c.query<RowDataPacket[]>(`SELECT pl.ProcDate Date,SUM(pl.ProcFee) Production FROM procedurelog pl INNER JOIN patient pa ON pl.PatNum=pa.PatNum WHERE pl.ProcDate BETWEEN ? AND ? AND pl.ProcStatus=2 ${cf} GROUP BY pl.ProcDate`,[f,t,...cp]);
      const [ad] = await c.query<RowDataPacket[]>(`SELECT AdjDate Date,SUM(AdjAmt) AdjAmt FROM adjustment a INNER JOIN patient pa ON a.PatNum=pa.PatNum WHERE AdjDate BETWEEN ? AND ? ${cf} GROUP BY AdjDate`,[f,t,...cp]);
      const [wo] = await c.query<RowDataPacket[]>(`SELECT DateCP Date,SUM(WriteOff) WriteOff FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum WHERE DateCP BETWEEN ? AND ? AND Status IN(4,5,6) ${cf} GROUP BY DateCP`,[f,t,...cp]);
      const [inc] = await c.query<RowDataPacket[]>(`SELECT PayDate Date,SUM(PayAmt) Income FROM payment pp INNER JOIN patient pa ON pp.PatNum=pa.PatNum WHERE PayDate BETWEEN ? AND ? ${cf} GROUP BY PayDate`,[f,t,...cp]);
      const pm=new Map<string,number>(),am=new Map<string,number>(),wm=new Map<string,number>(),im=new Map<string,number>();
      for(const r of pr) pm.set(ds(r.Date),Number(r.Production)); for(const r of ad) am.set(ds(r.Date),Number(r.AdjAmt));
      for(const r of wo) wm.set(ds(r.Date),Number(r.WriteOff)); for(const r of inc) im.set(ds(r.Date),Number(r.Income));
      const rows:any[]=[];let tp=0,ta=0,tw=0,ti=0;const df=new Date(f),dt=new Date(t);
      for(let d=new Date(df);d<=dt;d=new Date(d.getTime()+86400000)){const dd=ds(d),prv=pm.get(dd)||0,adv=am.get(dd)||0,wrv=wm.get(dd)||0,imv=im.get(dd)||0,dn=DAYS[d.getDay()];tp+=prv;ta+=adv;tw+=wrv;ti+=imv;rows.push({Date:dd,DayName:dn,Production:prv,Adjustment:adv,WriteOff:wrv,TotalProd:prv+adv+wrv,PatientIncome:imv,UnearnedPtIncome:0,InsIncome:0,TotalIncome:imv})}
      const ttp=tp+ta+tw;res.json({f,t,count:rows.length,totalProduction:ttp,totalIncome:ti,totals:{Production:tp,Adjustment:ta,WriteOff:tw,TotalProd:ttp,PatientIncome:ti,UnearnedPtIncome:0,InsIncome:0,TotalIncome:ti},summary:[`Total Production: ${ttp.toFixed(2)}`,`Total Income: ${ti.toFixed(2)}`],rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
}

router.get('/prod-goal', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),m=ms(td()),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT pr.ProvNum,pr.Abbr ProvName,SUM(COALESCE(pl.ProcFee,0)) Production,COUNT(DISTINCT pl.PatNum) Patients,0 Goal FROM provider pr LEFT JOIN procedurelog pl ON pl.ProvNum=pr.ProvNum AND pl.ProcDate BETWEEN ? AND ? AND pl.ProcStatus=2 LEFT JOIN patient pa ON pl.PatNum=pa.PatNum WHERE pr.IsHidden=0 ${cf?cf.replace(/pa\./g,'pa.'):''} GROUP BY pr.ProvNum,pr.Abbr ORDER BY Production DESC`,[m,td(),...cp]);
      res.json({month:m,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

// ═══ DAILY ═══
router.get('/daily-adjustments', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),f=(req.query.f as string)||td(),t=(req.query.t as string)||td(),pf=provFilter(req.query.provNums as string),cxf=clinFilterEx(req.query.clinicNums as string),params:any[]=[f,t,...clinicParams(a),...parseIds(req.query.provNums as string),...parseIds(req.query.clinicNums as string)],c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT a.AdjDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,a.AdjNote Note,a.AdjAmt Amount FROM adjustment a INNER JOIN patient pa ON a.PatNum=pa.PatNum LEFT JOIN provider pr ON a.ProvNum=pr.ProvNum WHERE a.AdjDate BETWEEN ? AND ? ${cf} ${pf} ${cxf} ORDER BY a.AdjDate,pa.LName LIMIT 500`,params);
      res.json({count:rows.length,totalAmount:rows.reduce((s:number,r:any)=>s+(Number(r.Amount)||0),0),rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/daily-payments', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),f=(req.query.f as string)||td(),t=(req.query.t as string)||td(),pf=provFilter(req.query.provNums as string),cxf=clinFilterEx(req.query.clinicNums as string),params:any[]=[f,t,...clinicParams(a),...parseIds(req.query.provNums as string),...parseIds(req.query.clinicNums as string)],c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT p.PayDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,d.ItemName PayType,p.CheckNum,p.PayAmt Amount FROM payment p INNER JOIN patient pa ON p.PatNum=pa.PatNum LEFT JOIN paysplit ps ON p.PayNum=ps.PayNum LEFT JOIN provider pr ON ps.ProvNum=pr.ProvNum LEFT JOIN definition d ON d.DefNum=p.PayType AND d.Category=9 WHERE p.PayDate BETWEEN ? AND ? ${cf} ${pf} ${cxf} GROUP BY p.PayNum,p.PayDate,p.CheckNum,d.ItemName,pa.LName,pa.FName ORDER BY d.ItemName,p.PayDate,pa.LName LIMIT 500`,params);
      res.json({count:rows.length,totalAmount:rows.reduce((s:number,r:any)=>s+(Number(r.Amount)||0),0),rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/daily-procedures', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),f=(req.query.f as string)||td(),t=(req.query.t as string)||td(),pf=provFilter(req.query.provNums as string),cxf=clinFilterEx(req.query.clinicNums as string),params:any[]=[f,t,...clinicParams(a),...parseIds(req.query.provNums as string),...parseIds(req.query.clinicNums as string)],c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT pl.ProcDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode Code,pl.ToothNum ToothArea,pc.Descript Description,pr.Abbr ProvName,pl.ProcFee Fee,COALESCE(ps.ShareAmt,0) Share FROM procedurelog pl INNER JOIN patient pa ON pl.PatNum=pa.PatNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum INNER JOIN provider pr ON pl.ProvNum=pr.ProvNum LEFT JOIN (SELECT ProcNum,SUM(SplitAmt) ShareAmt FROM paysplit WHERE ProcNum!=0 GROUP BY ProcNum) ps ON ps.ProcNum=pl.ProcNum WHERE pl.ProcDate BETWEEN ? AND ? AND pl.ProcStatus=2 ${cf} ${pf} ${cxf} ORDER BY pl.ProcDate,pa.LName LIMIT 500`,params);
      res.json({count:rows.length,totalFee:rows.reduce((s:number,r:any)=>s+(Number(r.Fee)||0),0),totalShare:rows.reduce((s:number,r:any)=>s+(Number(r.Share)||0),0),rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/daily-writeoffs', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),f=(req.query.f as string)||td(),t=(req.query.t as string)||td(),pf=provFilter(req.query.provNums as string),cxf=clinFilterEx(req.query.clinicNums as string),params:any[]=[f,t,...clinicParams(a),...parseIds(req.query.provNums as string),...parseIds(req.query.clinicNums as string)],c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,ca.CarrierName Insurance,cp.WriteOff Amount FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum LEFT JOIN provider pr ON cp.ProvNum=pr.ProvNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.WriteOff!=0 AND cp.DateCP BETWEEN ? AND ? ${cf} ${pf} ${cxf} ORDER BY cp.DateCP,pa.LName LIMIT 500`,params);
      res.json({count:rows.length,totalAmount:rows.reduce((s:number,r:any)=>s+(Number(r.Amount)||0),0),rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/daily-incomplete-notes', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),f=(req.query.f as string)||addD(td(),-30),t=(req.query.t as string)||td(),pf=provFilter(req.query.provNums as string),cxf=clinFilterEx(req.query.clinicNums as string),params:any[]=[f,t,...clinicParams(a),...parseIds(req.query.provNums as string),...parseIds(req.query.clinicNums as string)],c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT pl.ProcDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode,pc.Descript,pl.ToothNum,pl.Surf,pl.ProcFee,pr.Abbr ProvName FROM procedurelog pl INNER JOIN patient pa ON pl.PatNum=pa.PatNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum INNER JOIN provider pr ON pl.ProvNum=pr.ProvNum LEFT JOIN procnote pn ON pl.ProcNum=pn.ProcNum WHERE pl.ProcDate BETWEEN ? AND ? AND pl.ProcStatus=2 AND pn.ProcNum IS NULL ${cf} ${pf} ${cxf} ORDER BY pl.ProcDate,pa.LName LIMIT 200`,params);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/daily-unfinalized-ins', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),f=(req.query.f as string)||addD(td(),-60),t=(req.query.t as string)||td(),pf=provFilter(req.query.provNums as string),cxf=clinFilterEx(req.query.clinicNums as string),params:any[]=[f,t,...clinicParams(a),...parseIds(req.query.provNums as string),...parseIds(req.query.clinicNums as string)],c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT cp.ProcNum,cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,cp.InsPayEst EstAmt,cp.InsPayAmt PaidAmt,cp.WriteOff,cp.Status FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.Status=1 AND cp.DateCP BETWEEN ? AND ? ${cf} ${pf} ${cxf} ORDER BY cp.DateCP,pa.LName LIMIT 500`,params);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

// ═══ MONTHLY ═══
router.get('/mo-ar-aging', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT CASE WHEN DATEDIFF(CURDATE(),pa.DateFirstVisit)<=30 THEN '0-30' WHEN DATEDIFF(CURDATE(),pa.DateFirstVisit)<=60 THEN '31-60' WHEN DATEDIFF(CURDATE(),pa.DateFirstVisit)<=90 THEN '61-90' ELSE '90+' END AgingBucket,COUNT(*) PatientCount,SUM(COALESCE(pl.ProcFee,0))-SUM(COALESCE(ps.Paid,0)) Balance FROM patient pa LEFT JOIN procedurelog pl ON pl.PatNum=pa.PatNum AND pl.ProcStatus=2 LEFT JOIN (SELECT ProcNum,SUM(SplitAmt) Paid FROM paysplit WHERE ProcNum!=0 GROUP BY ProcNum) ps ON ps.ProcNum=pl.ProcNum WHERE pa.PatStatus=0 ${cf} GROUP BY AgingBucket ORDER BY AgingBucket`,cp);
      res.json({rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/mo-claims-not-sent', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT cp.ProcNum,cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,pc.ProcCode,cp.InsPayEst EstAmt FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum INNER JOIN procedurelog pl ON cp.ProcNum=pl.ProcNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.Status=0 ${cf} ORDER BY cp.DateCP LIMIT 500`,cp);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/mo-outstanding-ins-claims', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT cp.ProcNum,cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,pc.ProcCode,cp.InsPayEst EstAmt,DATEDIFF(CURDATE(),cp.DateCP) DaysOut FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum INNER JOIN procedurelog pl ON cp.ProcNum=pl.ProcNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.Status IN(1,4) AND cp.InsPayAmt=0 ${cf} ORDER BY DaysOut DESC LIMIT 500`,cp);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/mo-proc-not-billed', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT pl.ProcNum,pl.ProcDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode,pc.Descript,pl.ProcFee FROM procedurelog pl INNER JOIN patient pa ON pl.PatNum=pa.PatNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum LEFT JOIN claimproc cp ON cp.ProcNum=pl.ProcNum WHERE pl.ProcStatus=2 AND cp.ProcNum IS NULL AND pl.ProcFee>0 AND pl.ProcDate>=DATE_SUB(CURDATE(),INTERVAL 6 MONTH) ${cf} ORDER BY pl.ProcDate DESC LIMIT 500`,cp);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/mo-ppo-writeoffs', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,pc.ProcCode,cp.WriteOff Amount FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum INNER JOIN procedurelog pl ON cp.ProcNum=pl.ProcNum INNER JOIN procedurecode pc ON pl.CodeNum=pc.CodeNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.WriteOff>0 AND cp.DateCP>=DATE_SUB(CURDATE(),INTERVAL 12 MONTH) ${cf} ORDER BY cp.DateCP DESC LIMIT 500`,cp);
      res.json({count:rows.length,totalAmount:rows.reduce((s:number,r:any)=>s+(Number(r.Amount)||0),0),rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/mo-ins-overpaid', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT cp.ProcNum,cp.DateCP Date,CONCAT(pa.LName,', ',pa.FName) PatientName,ca.CarrierName Insurance,cp.InsPayAmt Paid,cp.InsPayEst Estimated,cp.InsPayAmt-cp.InsPayEst Overpaid FROM claimproc cp INNER JOIN patient pa ON cp.PatNum=pa.PatNum LEFT JOIN insplan ip ON cp.PlanNum=ip.PlanNum LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum WHERE cp.InsPayAmt>cp.InsPayEst AND cp.InsPayEst>0 ${cf} ORDER BY Overpaid DESC LIMIT 200`,cp);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/mo-treatplan-prod', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT tp.Priority,tp.DateTP DatePlan,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode,pc.Descript,tp.ProcFee Fee,pr.Abbr ProvName FROM procedurelog tp INNER JOIN patient pa ON tp.PatNum=pa.PatNum INNER JOIN procedurecode pc ON tp.CodeNum=pc.CodeNum INNER JOIN provider pr ON tp.ProvNum=pr.ProvNum WHERE tp.ProcStatus=1 ${cf} ORDER BY tp.Priority,tp.DateTP LIMIT 500`,cp);
      res.json({count:rows.length,totalFee:rows.reduce((s:number,r:any)=>s+(Number(r.Fee)||0),0),rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

// ═══ LISTS ═══
router.get('/list-active-patients', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT pa.PatNum,CONCAT(pa.LName,', ',pa.FName) PatientName,pa.Birthdate,pa.HmPhone,pa.WirelessPhone,pa.DateFirstVisit,pa.PatStatus FROM patient pa WHERE pa.PatStatus=0 ${cf} ORDER BY pa.LName,pa.FName LIMIT 1000`,cp);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/list-appointments', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),f=(req.query.f as string)||td(),t=(req.query.t as string)||addD(td(),7),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT a.AptDateTime Date,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,a.AptStatus,op.OpName Operatory,atype.AppointmentTypeName FROM appointment a INNER JOIN patient pa ON a.PatNum=pa.PatNum LEFT JOIN provider pr ON a.ProvNum=pr.ProvNum LEFT JOIN operatory op ON a.Op=op.OperatoryNum LEFT JOIN appointmenttype atype ON a.AppointmentTypeNum=atype.AppointmentTypeNum WHERE a.AptDateTime BETWEEN ? AND ? ${cf} ORDER BY a.AptDateTime LIMIT 1000`,[f,t,...cp]);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/list-birthdays', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT pa.PatNum,CONCAT(pa.LName,', ',pa.FName) PatientName,pa.Birthdate,MONTH(pa.Birthdate) BirthMonth,DAY(pa.Birthdate) BirthDay FROM patient pa WHERE pa.PatStatus=0 AND pa.Birthdate IS NOT NULL ${cf} ORDER BY MONTH(pa.Birthdate),DAY(pa.Birthdate) LIMIT 500`,cp);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/list-broken-appointments', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),f=(req.query.f as string)||addD(td(),-30),t=(req.query.t as string)||td(),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT a.AptDateTime Date,a.AptStatus,CONCAT(pa.LName,', ',pa.FName) PatientName,pr.Abbr ProvName,op.OpName Operatory FROM appointment a INNER JOIN patient pa ON a.PatNum=pa.PatNum LEFT JOIN provider pr ON a.ProvNum=pr.ProvNum LEFT JOIN operatory op ON a.Op=op.OperatoryNum WHERE a.AptDateTime BETWEEN ? AND ? AND a.AptStatus IN(3,4) ${cf} ORDER BY a.AptDateTime LIMIT 500`,[f,t,...cp]);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.json({count:0,error:e.message,rows:[]}); }
});

router.get('/list-new-patients', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),fm=ms(td()),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT pa.PatNum,CONCAT(pa.LName,', ',pa.FName) PatientName,pa.DateFirstVisit,pa.Birthdate,pa.HmPhone,pa.WirelessPhone FROM patient pa WHERE pa.DateFirstVisit>=? ${cf} ORDER BY pa.DateFirstVisit DESC LIMIT 500`,[fm,...cp]);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/list-patient-notes', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),f=(req.query.f as string)||addD(td(),-30),t=(req.query.t as string)||td(),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT c.CommDateTime Date,CONCAT(pa.LName,', ',pa.FName) PatientName,c.CommType,c.Note,uo.UserName FROM commlog c INNER JOIN patient pa ON c.PatNum=pa.PatNum LEFT JOIN userod uo ON c.UserNum=uo.UserNum WHERE c.CommDateTime BETWEEN ? AND ? ${cf} ORDER BY c.CommDateTime DESC LIMIT 500`,[f,t,...cp]);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/list-prescriptions', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),f=(req.query.f as string)||addD(td(),-90),t=(req.query.t as string)||td(),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT r.RxDate Date,CONCAT(pa.LName,', ',pa.FName) PatientName,r.Drug,r.Sig,r.Disp,r.Refills,pr.Abbr ProvName FROM rxpat r INNER JOIN patient pa ON r.PatNum=pa.PatNum LEFT JOIN provider pr ON r.ProvNum=pr.ProvNum WHERE r.RxDate BETWEEN ? AND ? ${cf} ORDER BY r.RxDate DESC LIMIT 500`,[f,t,...cp]);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

router.get('/list-proc-fee-sched', async (_req, res) => { try { const c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT CodeNum,ProcCode,Descript,AbbrDesc,ProcCat FROM procedurecode ORDER BY ProcCode LIMIT 500`);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.json({count:0,error:e.message,rows:[]}); }
});

router.get('/list-treatment-finder', async (req, res) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();
    try { const [rows]=await c.query<RowDataPacket[]>(`SELECT tp.Priority,tp.DateTP DatePlan,CONCAT(pa.LName,', ',pa.FName) PatientName,pc.ProcCode,pc.Descript,tp.ProcFee Fee,pr.Abbr ProvName FROM procedurelog tp INNER JOIN patient pa ON tp.PatNum=pa.PatNum INNER JOIN procedurecode pc ON tp.CodeNum=pc.CodeNum INNER JOIN provider pr ON tp.ProvNum=pr.ProvNum WHERE tp.ProcStatus=1 ${cf} ORDER BY tp.Priority,tp.DateTP LIMIT 500`,cp);
      res.json({count:rows.length,rows});
    } finally { c.release(); }
  } catch(e:any) { res.status(500).json({error:e.message}); }
});

// Stubs
router.get('/mo-finance-charge', (_rq, rs) => rs.json({count:0,rows:[]}));
router.get('/mo-payment-plans', (_rq, rs) => rs.json({count:0,note:'Not verified',rows:[]}));
router.get('/mo-receivables-breakdown', (_rq, rs) => rs.json({count:0,rows:[]}));
router.get('/mo-unearned-income', (_rq, rs) => rs.json({count:0,rows:[]}));
router.get('/list-ins-plans', async (_rq, rs) => { try { const c=await pool.getConnection();try{const[rows]=await c.query<RowDataPacket[]>(`SELECT ip.PlanNum,ca.CarrierName Insurance,ip.GroupName,ip.GroupNum,ip.PlanType,CONCAT(pa.LName,', ',pa.FName) Subscriber FROM insplan ip LEFT JOIN carrier ca ON ip.CarrierNum=ca.CarrierNum LEFT JOIN inssub sub ON ip.PlanNum=sub.PlanNum LEFT JOIN patient pa ON sub.Subscriber=pa.PatNum WHERE ip.IsHidden=0 ORDER BY ca.CarrierName LIMIT 500`);rs.json({count:rows.length,rows});}finally{c.release();}}catch(e:any){rs.status(500).json({error:e.message});} });
router.get('/list-patients-raw', async (req, rs) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),c=await pool.getConnection();try{const[rows]=await c.query<RowDataPacket[]>(`SELECT * FROM patient pa WHERE pa.PatStatus=0 ${cf} ORDER BY pa.LName,pa.FName LIMIT 1000`,cp);rs.json({count:rows.length,rows});}finally{c.release();}}catch(e:any){rs.status(500).json({error:e.message});} });
router.get('/list-web-sched-appts', async (req, rs) => { try { const a=getAllowedClinics(req),cf=clinicFilter(a),cp=clinicParams(a),f=(req.query.f as string)||td(),t=(req.query.t as string)||addD(td(),7),c=await pool.getConnection();try{const[rows]=await c.query<RowDataPacket[]>(`SELECT a.AptDateTime Date,CONCAT(pa.LName,', ',pa.FName) PatientName,a.IsNewPatient,a.AptStatus FROM appointment a INNER JOIN patient pa ON a.PatNum=pa.PatNum WHERE a.AptDateTime BETWEEN ? AND ? AND a.AptStatus=7 ${cf} ORDER BY a.AptDateTime LIMIT 500`,[f,t,...cp]);rs.json({count:rows.length,rows});}finally{c.release();}}catch(e:any){rs.status(500).json({error:e.message});} });
router.get('/list-referrals-raw', (_rq, rs) => rs.json({count:0,note:'Not implemented',rows:[]}));
router.get('/list-referral-analysis', (_rq, rs) => rs.json({count:0,rows:[]}));
router.get('/list-ref-proc-tracking', (_rq, rs) => rs.json({count:0,rows:[]}));
router.get('/ph-screening-data', (_rq, rs) => rs.json({count:0,rows:[]}));
router.get('/ph-population-data', (_rq, rs) => rs.json({count:0,rows:[]}));
router.get('/ph-fqhc-sealant', (_rq, rs) => rs.json({count:0,rows:[]}));

export default router;
