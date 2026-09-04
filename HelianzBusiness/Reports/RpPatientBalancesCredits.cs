using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using CodeBase;
using DataConnectionBase;

namespace HelianzBusiness {
	public class RpPatientBalancesCredits {
		///<summary>Retrieves patient balances and credits based on selected criteria. Supports Middle Tier role.</summary>
		public static DataTable GetPatientBalancesCredits(
			List<long> listClinicNums,
			List<long> listProvNums,
			string statusFilter,
			double minThreshold,
			bool isGroupByFamily,
			bool excludeInactive) 
		{
			if(RemotingClient.MiddleTierRole==MiddleTierRole.ClientMT) {
				return Meth.GetTable(MethodBase.GetCurrentMethod(),
					listClinicNums,listProvNums,statusFilter,minThreshold,isGroupByFamily,excludeInactive);
			}
			bool hasClinicsEnabled=ReportsComplex.RunFuncOnReportServer(() => Prefs.HasClinicsEnabledNoCache);
			bool showPatNum=ReportsComplex.RunFuncOnReportServer(() => Prefs.GetBoolNoCache(PrefName.ReportsShowPatNum));
			List<long> listHiddenUnearnedDefNums=ReportsComplex.RunFuncOnReportServer(() => 
				Defs.GetDefsNoCache(DefCat.PaySplitUnearnedType).FindAll(x => !string.IsNullOrEmpty(x.ItemValue)).Select(x => x.DefNum).ToList()
			);

			string hiddenUnearnedFilter="";
			if(listHiddenUnearnedDefNums.Count>0) {
				hiddenUnearnedFilter=$"AND ps.UnearnedType NOT IN ({string.Join(",",listHiddenUnearnedDefNums)}) ";
			}

			string command="";
			if(isGroupByFamily) {
				command=$@"
					SELECT 
						guar.PatNum,
						guar.Guarantor,
						guar.LName,
						guar.FName,
						guar.Preferred,
						guar.HmPhone,
						guar.WirelessPhone,
						ROUND(SUM(p.BalTotal), 2) AS BalTotal,
						ROUND(COALESCE(unearned.TotalUnearned, 0), 2) AS UnearnedAmt,
						COALESCE(lastPay.DateLastPay, '0001-01-01') AS DateLastPay,
						COALESCE(clinic.Abbr, '') AS ClinicAbbr,
						COALESCE(provider.Abbr, '') AS ProvAbbr
					FROM patient guar
					INNER JOIN patient p ON p.Guarantor = guar.PatNum
					LEFT JOIN clinic ON clinic.ClinicNum = guar.ClinicNum
					LEFT JOIN provider ON provider.ProvNum = guar.PriProv
					LEFT JOIN (
						SELECT p2.Guarantor, SUM(ps.SplitAmt) AS TotalUnearned
						FROM paysplit ps
						INNER JOIN patient p2 ON p2.PatNum = ps.PatNum
						WHERE ps.UnearnedType != 0
						{hiddenUnearnedFilter}
						GROUP BY p2.Guarantor
					) unearned ON unearned.Guarantor = guar.PatNum
					LEFT JOIN (
						SELECT p3.Guarantor, MAX(ps2.DatePay) AS DateLastPay
						FROM paysplit ps2
						INNER JOIN payment pay ON pay.PayNum = ps2.PayNum
						INNER JOIN patient p3 ON p3.PatNum = ps2.PatNum
						WHERE pay.PayType != 0
						GROUP BY p3.Guarantor
						HAVING SUM(ps2.SplitAmt) != 0
					) lastPay ON lastPay.Guarantor = guar.PatNum
					WHERE guar.PatNum = guar.Guarantor ";

				if(excludeInactive) {
					command+="AND guar.PatStatus != "+POut.Int((int)PatientStatus.Inactive)+" AND guar.PatStatus != "+POut.Int((int)PatientStatus.Archived)+" ";
				}
				if(hasClinicsEnabled && listClinicNums!=null && listClinicNums.Count>0) {
					command+="AND guar.ClinicNum IN ("+string.Join(",",listClinicNums.Select(x => POut.Long(x)))+") ";
				}
				if(listProvNums!=null && listProvNums.Count>0) {
					command+="AND guar.PriProv IN ("+string.Join(",",listProvNums.Select(x => POut.Long(x)))+") ";
				}

				command+=@"GROUP BY guar.PatNum, guar.Guarantor, guar.LName, guar.FName, guar.Preferred, 
					guar.HmPhone, guar.WirelessPhone, clinic.Abbr, provider.Abbr, unearned.TotalUnearned, lastPay.DateLastPay
					ORDER BY guar.LName, guar.FName";
			}
			else {
				command=$@"
					SELECT 
						p.PatNum,
						p.Guarantor,
						p.LName,
						p.FName,
						p.Preferred,
						p.HmPhone,
						p.WirelessPhone,
						ROUND(p.BalTotal, 2) AS BalTotal,
						ROUND(COALESCE(unearned.TotalUnearned, 0), 2) AS UnearnedAmt,
						COALESCE(lastPay.DateLastPay, '0001-01-01') AS DateLastPay,
						COALESCE(clinic.Abbr, '') AS ClinicAbbr,
						COALESCE(provider.Abbr, '') AS ProvAbbr
					FROM patient p
					LEFT JOIN clinic ON clinic.ClinicNum = p.ClinicNum
					LEFT JOIN provider ON provider.ProvNum = p.PriProv
					LEFT JOIN (
						SELECT ps.PatNum, SUM(ps.SplitAmt) AS TotalUnearned
						FROM paysplit ps
						WHERE ps.UnearnedType != 0
						{hiddenUnearnedFilter}
						GROUP BY ps.PatNum
					) unearned ON unearned.PatNum = p.PatNum
					LEFT JOIN (
						SELECT ps2.PatNum, MAX(ps2.DatePay) AS DateLastPay
						FROM paysplit ps2
						INNER JOIN payment pay ON pay.PayNum = ps2.PayNum
						WHERE pay.PayType != 0
						GROUP BY ps2.PatNum
						HAVING SUM(ps2.SplitAmt) != 0
					) lastPay ON lastPay.PatNum = p.PatNum
					WHERE 1=1 ";

				if(excludeInactive) {
					command+="AND p.PatStatus != "+POut.Int((int)PatientStatus.Inactive)+" AND p.PatStatus != "+POut.Int((int)PatientStatus.Archived)+" ";
				}
				if(hasClinicsEnabled && listClinicNums!=null && listClinicNums.Count>0) {
					command+="AND p.ClinicNum IN ("+string.Join(",",listClinicNums.Select(x => POut.Long(x)))+") ";
				}
				if(listProvNums!=null && listProvNums.Count>0) {
					command+="AND p.PriProv IN ("+string.Join(",",listProvNums.Select(x => POut.Long(x)))+") ";
				}

				command+="ORDER BY p.LName, p.FName";
			}

			DataTable rawTable=ReportsComplex.RunFuncOnReportServer(() => Db.GetTable(command));

			// Build result table with structured data types
			DataTable tableResult=new DataTable();
			tableResult.Columns.Add("PatNum",typeof(long));
			tableResult.Columns.Add("Patient",typeof(string));
			tableResult.Columns.Add("Preferred",typeof(string));
			tableResult.Columns.Add("Phone",typeof(string));
			tableResult.Columns.Add("Status",typeof(string));
			tableResult.Columns.Add("BalTotal",typeof(double));
			tableResult.Columns.Add("UnearnedAmt",typeof(double));
			tableResult.Columns.Add("NetBal",typeof(double));
			tableResult.Columns.Add("DateLastPay",typeof(string));
			tableResult.Columns.Add("Clinic",typeof(string));
			tableResult.Columns.Add("Provider",typeof(string));

			foreach(DataRow row in rawTable.Rows) {
				double balTotal=PIn.Double(row["BalTotal"].ToString());
				double unearnedAmt=PIn.Double(row["UnearnedAmt"].ToString());
				double netBal=balTotal-unearnedAmt;

				// Skip settled accounts where both balance and unearned are within micro-threshold
				if(Math.Abs(balTotal) < minThreshold && unearnedAmt < minThreshold && Math.Abs(netBal) < minThreshold) {
					continue;
				}

				DateTime dateLastPay=PIn.Date(row["DateLastPay"].ToString());
				bool hasPaid=(dateLastPay.Year > 1880);

				// Determine account status
				string status;
				if(netBal <= -minThreshold) {
					if(balTotal <= 0 && unearnedAmt >= minThreshold) {
						status="Prepayment Credit";
					}
					else if(balTotal < -minThreshold && unearnedAmt < minThreshold) {
						status="Credit Balance";
					}
					else if(balTotal < -minThreshold && unearnedAmt >= minThreshold) {
						status="Credit & Prepay";
					}
					else {
						status="Credit";
					}
				}
				else if(netBal >= minThreshold) {
					if(hasPaid) {
						status="Partially Paid";
					}
					else {
						status="Unpaid";
					}
				}
				else {
					if(unearnedAmt >= minThreshold) {
						status="Covered by Prepay";
					}
					else {
						status="Settled";
					}
				}

				// Apply status filter
				if(!string.IsNullOrEmpty(statusFilter) && statusFilter != "All") {
					if(statusFilter == "CreditPrepay" && !status.Contains("Credit") && !status.Contains("Prepay")) {
						continue;
					}
					if(statusFilter == "Unpaid" && status != "Unpaid") {
						continue;
					}
					if(statusFilter == "PartiallyPaid" && status != "Partially Paid") {
						continue;
					}
				}

				long patNum=PIn.Long(row["PatNum"].ToString());
				string lName=row["LName"].ToString();
				string fName=row["FName"].ToString();
				string patName=showPatNum ? $"{patNum} - {lName}, {fName}" : $"{lName}, {fName}";
				string preferred=row["Preferred"].ToString();

				string phone=row["WirelessPhone"].ToString();
				if(string.IsNullOrEmpty(phone)) {
					phone=row["HmPhone"].ToString();
				}

				string dateLastPayStr=hasPaid ? dateLastPay.ToShortDateString() : "";

				tableResult.Rows.Add(
					patNum,
					patName,
					preferred,
					phone,
					status,
					balTotal,
					unearnedAmt,
					netBal,
					dateLastPayStr,
					row["ClinicAbbr"].ToString(),
					row["ProvAbbr"].ToString()
				);
			}

			return tableResult;
		}
	}
}
