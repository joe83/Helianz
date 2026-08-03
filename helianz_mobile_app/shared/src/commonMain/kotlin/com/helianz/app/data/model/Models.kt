package com.helianz.app.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// ── Auth ─────────────────────────────────────────────

@Serializable
data class LoginRequest(val username: String, val password: String)

@Serializable
data class LoginResponse(
    val token: String,
    val displayName: String,
    val userNum: Long,
    val clinicNum: Long,
    val clinicNums: List<Long>,
    val modules: List<UserModule>
)

@Serializable
data class UserModule(val name: String, val enabled: Boolean)

// ── Patient ──────────────────────────────────────────

@Serializable
data class PatientDto(
    val patNum: Long = 0,
    val lName: String = "",
    val fName: String = "",
    val middleI: String? = null,
    val preferred: String? = null,
    val gender: Int = 0,
    val birthdate: String = "",
    val ssn: String? = null,
    val address: String? = null,
    val address2: String? = null,
    val city: String? = null,
    val state: String? = null,
    val zip: String? = null,
    val hmPhone: String? = null,
    val wkPhone: String? = null,
    val wirelessPhone: String? = null,
    val email: String? = null,
    val clinicNum: Long = 0,
    val patientStatus: Int = 0,
    val dateFirstVisit: String = "",
    val priProv: Long = 0,
    val chartNumber: String? = null,
    val country: String? = null,
    val hasIns: Boolean = false,
    val balanceTotal: Double = 0.0,
    val insEstTotal: Double = 0.0,
    val age: Int = 0
)

@Serializable
data class PatientSearchResult(
    val patients: List<PatientDto>,
    val totalCount: Int,
    val page: Int,
    val pageSize: Int
)

@Serializable
data class PatientCreateRequest(
    val lName: String, val fName: String,
    val middleI: String? = null, val preferred: String? = null,
    val gender: Int, val birthdate: String,
    val ssn: String? = null,
    val address: String? = null, val address2: String? = null,
    val city: String? = null, val state: String? = null,
    val zip: String? = null,
    val hmPhone: String? = null, val wkPhone: String? = null,
    val wirelessPhone: String? = null, val email: String? = null,
    val clinicNum: Long, val priProv: Long,
    val country: String? = "Indonesia"
)

// ── Appointment ──────────────────────────────────────

@Serializable
data class AppointmentDto(
    val aptNum: Long = 0,
    val patNum: Long = 0,
    val patientName: String = "",
    val aptStatus: Int = 0,
    val clinicNum: Long = 0,
    val provNum: Long = 0,
    val provHyg: Long = 0,
    val opNum: Long = 0,
    val opName: String? = null,
    val aptDateTime: String = "",
    val length: Int = 30,
    val pattern: String? = null,
    val note: String? = null,
    val confirmed: Long = 0,
    val appointmentTypeNum: Long = 0,
    val appointmentTypeName: String? = null,
    val isNewPatient: Boolean = false,
    val isHygiene: Boolean = false,
    val provName: String? = null,
    val provHygName: String? = null,
    val patientPhone: String? = null
)

@Serializable
data class AppointmentSearchResult(
    val appointments: List<AppointmentDto>,
    val totalCount: Int
)

@Serializable
data class AppointmentCreateRequest(
    val patNum: Long, val clinicNum: Long,
    val provNum: Long, val provHyg: Long = 0,
    val opNum: Long, val aptDateTime: String,
    val length: Int = 30, val pattern: String? = "/X/",
    val note: String? = null,
    val appointmentTypeNum: Long = 0,
    val isNewPatient: Boolean = false,
    val isHygiene: Boolean = false
)

// ── Procedure (Charting) ─────────────────────────────

@Serializable
data class ProcedureDto(
    val procNum: Long = 0,
    val patNum: Long = 0,
    val patientName: String = "",
    val clinicNum: Long = 0,
    val provNum: Long = 0,
    val provName: String? = null,
    val codeNum: String = "",
    val procCode: String? = null,
    val descript: String? = null,
    val toothNum: String? = null,
    val surf: String? = null,
    val procStatus: Int = 0,
    val procDate: String = "",
    val procFee: Double = 0.0,
    val priority: Int = 0,
    val note: String? = null,
    val procStatusName: String? = null
)

@Serializable
data class ToothChart(
    val patNum: Long,
    val patientName: String,
    val teeth: List<ToothProcedure>
)

@Serializable
data class ToothProcedure(
    val toothNum: String,
    val procedures: List<ProcedureDto>
)

@Serializable
data class ProcedureSearchResult(
    val procedures: List<ProcedureDto>,
    val totalCount: Int
)

@Serializable
data class ProcedureCreateRequest(
    val patNum: Long, val clinicNum: Long, val provNum: Long,
    val codeNum: String, val toothNum: String? = null,
    val surf: String? = null, val procStatus: Int = 1,
    val procDate: String, val procFee: Double = 0.0,
    val priority: Int = 0, val note: String? = null,
    val aptNum: Long = 0, val dxNum: Long = 0
)

// ── Payment ──────────────────────────────────────────

@Serializable
data class PaymentDto(
    val payNum: Long = 0,
    val patNum: Long = 0,
    val patientName: String = "",
    val clinicNum: Long = 0,
    val payDate: String = "",
    val payAmt: Double = 0.0,
    val payType: Long = 0,
    val payTypeName: String? = null,
    val checkNum: String? = null,
    val note: String? = null,
    val provNum: Long = 0,
    val provName: String? = null
)

@Serializable
data class PaymentSearchResult(
    val payments: List<PaymentDto>,
    val totalCount: Int,
    val totalAmount: Double
)

@Serializable
data class PaymentCreateRequest(
    val patNum: Long, val clinicNum: Long,
    val payDate: String, val payAmt: Double,
    val payType: Long, val checkNum: String? = null,
    val note: String? = null, val provNum: Long = 0,
    val splits: List<PaySplitRequest> = emptyList()
)

@Serializable
data class PaySplitRequest(val procNum: Long, val splitAmt: Double)

// ── Prescription ─────────────────────────────────────

@Serializable
data class PrescriptionDto(
    val rxNum: Long = 0,
    val patNum: Long = 0,
    val patientName: String = "",
    val clinicNum: Long = 0,
    val provNum: Long = 0,
    val provName: String? = null,
    val drug: String = "",
    val sig: String? = null,
    val disp: String? = null,
    val refills: String? = null,
    val note: String? = null,
    val dateRx: String = "",
    val isControlled: Boolean = false
)

@Serializable
data class PrescriptionCreateRequest(
    val patNum: Long, val clinicNum: Long, val provNum: Long,
    val drug: String, val sig: String? = null,
    val disp: String? = null, val refills: String? = null,
    val note: String? = null, val pharmacyNum: Long = 0,
    val isControlled: Boolean = false
)

// ── Clinical Note ────────────────────────────────────

@Serializable
data class ClinicalNoteDto(
    val commlogNum: Long = 0,
    val patNum: Long = 0,
    val patientName: String = "",
    val clinicNum: Long = 0,
    val provNum: Long = 0,
    val provName: String? = null,
    val commDateTime: String = "",
    val commTypeName: String? = null,
    val note: String? = null,
    val userName: String? = null
)

@Serializable
data class NoteCreateRequest(
    val patNum: Long, val clinicNum: Long, val provNum: Long,
    val commType: Long, val note: String, val aptNum: Long = 0
)

// ── Reference Data ───────────────────────────────────

@Serializable
data class ReferenceData(
    val providers: List<ProviderDto> = emptyList(),
    val operatories: List<OperatoryDto> = emptyList(),
    val procedureCodes: List<ProcedureCodeDto> = emptyList(),
    val appointmentTypes: List<AppointmentTypeDto> = emptyList(),
    val paymentTypes: List<DefinitionDto> = emptyList(),
    val commTypes: List<DefinitionDto> = emptyList()
)

@Serializable
data class ProviderDto(val provNum: Long, val abbr: String, val fName: String, val lName: String)

@Serializable
data class OperatoryDto(val operatoryNum: Long, val opName: String, val clinicNum: Long)

@Serializable
data class ProcedureCodeDto(
    val codeNum: Long, val procCode: String, val descript: String,
    val procCatName: String? = null, val procFee: Double = 0.0,
    val isHygiene: Boolean = false
)

@Serializable
data class AppointmentTypeDto(
    val appointmentTypeNum: Long, val appointmentTypeName: String, val length: Int = 30
)

@Serializable
data class DefinitionDto(val defNum: Long, val itemName: String)
