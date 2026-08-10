using System.Data;
using Dapper;
using HelianzApi.Data;
using HelianzApi.Models;

namespace HelianzApi.Services;

public class ReferenceDataService
{
    private readonly DatabaseConnectionFactory _db;

    public ReferenceDataService(DatabaseConnectionFactory db) => _db = db;

    public async Task<ReferenceData> GetAllAsync(long clinicNum)
    {
        using var conn = _db.CreateConnection();

        var providers = (await conn.QueryAsync<Provider>(@"
            SELECT ProvNum, Abbr, FName, LName, 0 AS ClinicNum, IsHidden, IsSecondary, Specialty
            FROM provider WHERE IsHidden = 0 ORDER BY LName")).ToList();

        var operatories = (await conn.QueryAsync<Operatory>(@"
            SELECT OperatoryNum, OpName, ClinicNum, ProvDentist, ProvHygienist, IsHidden, ItemOrder AS SetOrder
            FROM operatory WHERE IsHidden = 0 ORDER BY ItemOrder")).ToList();

        var procedureCodes = (await conn.QueryAsync<ProcedureCode>(@"
            SELECT pc.CodeNum, pc.ProcCode, pc.Descript, pc.AbbrDesc,
                   pc.ProcCat, def.ItemName AS ProcCatName, 0 AS ProcFee,
                   pc.IsHygiene, pc.PaintType, '' AS TreatmentArea
            FROM procedurecode pc
            LEFT JOIN definition def ON pc.ProcCat = def.DefNum
            ORDER BY pc.ProcCode")).ToList();

        var appointmentTypes = (await conn.QueryAsync<AppointmentType>(@"
            SELECT AppointmentTypeNum, AppointmentTypeName, Pattern,
                   CodeStr, CodeStrRequired, 0 AS Length
            FROM appointmenttype ORDER BY AppointmentTypeName")).ToList();

        var paymentTypes = (await conn.QueryAsync<Definition>(@"
            SELECT DefNum, ItemName, Category, ItemOrder
            FROM definition WHERE Category = 3 ORDER BY ItemOrder")).ToList();

        var commTypes = (await conn.QueryAsync<Definition>(@"
            SELECT DefNum, ItemName, Category, ItemOrder
            FROM definition WHERE Category = 2 ORDER BY ItemOrder")).ToList();

        var clinics = (await conn.QueryAsync<ClinicInfo>(@"
            SELECT ClinicNum, Description, Address, City, Phone, IsHidden
            FROM clinic WHERE IsHidden = 0 ORDER BY Description")).ToList();

        var confirmedStatuses = (await conn.QueryAsync<Definition>(@"
            SELECT DefNum, ItemName, Category, ItemOrder
            FROM definition ORDER BY Category, ItemOrder")).ToList();

        return new ReferenceData
        {
            Providers = providers,
            Operatories = operatories,
            ProcedureCodes = procedureCodes,
            AppointmentTypes = appointmentTypes,
            PaymentTypes = paymentTypes,
            CommTypes = commTypes,
            ConfirmedStatuses = confirmedStatuses,
            Clinics = clinics
        };
    }
}
