using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using CodeBase;
using DataConnectionBase;

namespace HelianzBusiness {
	public class ProcedureDoctorShares {

		///<summary>Scans completed procedures within date range where the stored procedurelog.Share does not match
		///the performing provider's fee schedule ProviderShare (e.g. Share = 0 due to specialist primary provider override).</summary>
		public static DataTable GetMismatchedShares(DateTime dateFrom,DateTime dateTo,List<long> listClinicNums,List<long> listProvNums,bool hasAllProvs,bool hasClinicsEnabled) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetTable(MethodBase.GetCurrentMethod(),dateFrom,dateTo,listClinicNums,listProvNums,hasAllProvs,hasClinicsEnabled);
			}
			string query=@"
				SELECT 
					pl.ProcNum,
					pl.ProcDate,
					pl.PatNum,
					CONCAT(p.LName, ', ', p.FName, ' ', p.MiddleI) AS PatName,
					pc.CodeNum,
					pc.ProcCode,
					pc.Descript,
					pl.ToothNum,
					pl.Surf AS Area,
					pl.ProcFee,
					pl.ProvNum AS ProcProvNum,
					pr.Abbr AS ProcProvAbbr,
					pr.FeeSched AS ProcProvFS,
					fs.Description AS FeeSchedDesc,
					p.PriProv AS PatPriProvNum,
					pr_pat.Abbr AS PatPriProvAbbr,
					pl.ClinicNum,
					COALESCE(cl.Abbr, 'Unassigned') AS ClinicAbbr,
					pl.Share AS CurrentShare,
					COALESCE(f_exact.ProviderShare, f_prov.ProviderShare, f_clinic.ProviderShare, f_hq.ProviderShare, 0) AS ExpectedShare
				FROM procedurelog pl
				INNER JOIN patient p ON pl.PatNum = p.PatNum
				INNER JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
				INNER JOIN provider pr ON pl.ProvNum = pr.ProvNum
				LEFT JOIN feesched fs ON pr.FeeSched = fs.FeeSchedNum
				LEFT JOIN provider pr_pat ON p.PriProv = pr_pat.ProvNum
				LEFT JOIN clinic cl ON pl.ClinicNum = cl.ClinicNum
				/* 1. Exact match (FeeSched + Clinic + Prov) */
				LEFT JOIN fee f_exact ON f_exact.CodeNum = pl.CodeNum 
					AND f_exact.FeeSched = pr.FeeSched 
					AND f_exact.ClinicNum = pl.ClinicNum 
					AND f_exact.ProvNum = pl.ProvNum
				/* 2. Prov override (FeeSched + Prov + Clinic 0) */
				LEFT JOIN fee f_prov ON f_prov.CodeNum = pl.CodeNum 
					AND f_prov.FeeSched = pr.FeeSched 
					AND f_prov.ClinicNum = 0 
					AND f_prov.ProvNum = pl.ProvNum
				/* 3. Clinic override (FeeSched + Clinic + Prov 0) */
				LEFT JOIN fee f_clinic ON f_clinic.CodeNum = pl.CodeNum 
					AND f_clinic.FeeSched = pr.FeeSched 
					AND f_clinic.ClinicNum = pl.ClinicNum 
					AND f_clinic.ProvNum = 0
				/* 4. HQ standard (FeeSched + Clinic 0 + Prov 0) */
				LEFT JOIN fee f_hq ON f_hq.CodeNum = pl.CodeNum 
					AND f_hq.FeeSched = pr.FeeSched 
					AND f_hq.ClinicNum = 0 
					AND f_hq.ProvNum = 0
				WHERE pl.ProcStatus = "+POut.Int((int)ProcStat.C)+@"
				  AND pl.ProcFee > 0
				  AND pl.ProcDate >= "+POut.Date(dateFrom)+@"
				  AND pl.ProcDate <= "+POut.Date(dateTo)+@"
				  AND pl.Share = 0
				  AND COALESCE(f_exact.ProviderShare, f_prov.ProviderShare, f_clinic.ProviderShare, f_hq.ProviderShare, 0) > 0 ";
			if(!hasAllProvs && listProvNums.Count > 0) {
				query+="AND pl.ProvNum IN ("+String.Join(",",listProvNums)+") ";
			}
			if(hasClinicsEnabled && listClinicNums.Count > 0) {
				query+="AND pl.ClinicNum IN ("+String.Join(",",listClinicNums)+") ";
			}
			query+="ORDER BY pl.ProcDate, PatName, pc.ProcCode";
			return Db.GetTable(query);
		}

		///<summary>Batch updates the Share on the given procedures to match their performing doctor's ProviderShare from the fee table.</summary>
		public static int FixProcedureShares(List<long> listProcNums,long userNum) {
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetInt(MethodBase.GetCurrentMethod(),listProcNums,userNum);
			}
			if(listProcNums==null || listProcNums.Count==0) {
				return 0;
			}
			string command=@"
				UPDATE procedurelog pl
				INNER JOIN provider pr ON pl.ProvNum = pr.ProvNum
				LEFT JOIN fee f_exact ON f_exact.CodeNum = pl.CodeNum 
					AND f_exact.FeeSched = pr.FeeSched 
					AND f_exact.ClinicNum = pl.ClinicNum 
					AND f_exact.ProvNum = pl.ProvNum
				LEFT JOIN fee f_prov ON f_prov.CodeNum = pl.CodeNum 
					AND f_prov.FeeSched = pr.FeeSched 
					AND f_prov.ClinicNum = 0 
					AND f_prov.ProvNum = pl.ProvNum
				LEFT JOIN fee f_clinic ON f_clinic.CodeNum = pl.CodeNum 
					AND f_clinic.FeeSched = pr.FeeSched 
					AND f_clinic.ClinicNum = pl.ClinicNum 
					AND f_clinic.ProvNum = 0
				LEFT JOIN fee f_hq ON f_hq.CodeNum = pl.CodeNum 
					AND f_hq.FeeSched = pr.FeeSched 
					AND f_hq.ClinicNum = 0 
					AND f_hq.ProvNum = 0
				SET pl.Share = COALESCE(f_exact.ProviderShare, f_prov.ProviderShare, f_clinic.ProviderShare, f_hq.ProviderShare, 0)
				WHERE pl.ProcNum IN ("+String.Join(",",listProcNums)+@")
				  AND COALESCE(f_exact.ProviderShare, f_prov.ProviderShare, f_clinic.ProviderShare, f_hq.ProviderShare, 0) > 0";
			long rowsAffected=Db.NonQ(command);
			SecurityLogs.MakeLogEntry(EnumPermType.ProcComplCreate,0,$"Fixed procedure doctor shares for {rowsAffected} procedure(s).");
			return (int)rowsAffected;
		}

	}
}
