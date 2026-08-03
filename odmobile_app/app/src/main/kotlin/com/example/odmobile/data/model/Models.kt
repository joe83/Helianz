package com.example.odmobile.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// ── Auth ─────────────────────────────────────────────
@Serializable data class LoginRequest(val username: String, val password: String)
@Serializable data class LoginResponse(val token: String, val displayName: String, val userNum: Long, val clinicNum: Long, val clinicNums: List<Long>)

// ── Patient ──────────────────────────────────────────
@Serializable data class PatientDto(
    val patNum: Long = 0, val lName: String = "", val fName: String = "",
    val gender: Int = 0, val birthdate: String = "", val age: Int = 0,
    val ssn: String? = null, val wirelessPhone: String? = null,
    val email: String? = null, val address: String? = null,
    val city: String? = null, val chartNumber: String? = null,
    val clinicNum: Long = 0, val patientStatus: Int = 0,
    val balanceTotal: Double = 0.0, val hasIns: Boolean = false,
    val dateFirstVisit: String = "", val country: String? = null
)
@Serializable data class PatientSearchResult(val patients: List<PatientDto>, val totalCount: Int, val page: Int, val pageSize: Int)

// ── Appointment ──────────────────────────────────────
@Serializable data class AppointmentDto(
    val aptNum: Long = 0, val patNum: Long = 0, val patientName: String = "",
    val aptStatus: Int = 0, val clinicNum: Long = 0, val provNum: Long = 0,
    val opNum: Long = 0, val opName: String? = null, val aptDateTime: String = "",
    val length: Int = 30, val note: String? = null, val provName: String? = null,
    val appointmentTypeName: String? = null, val patientPhone: String? = null,
    val isNewPatient: Boolean = false, val isHygiene: Boolean = false
)

// ── Procedure / Chart ────────────────────────────────
@Serializable data class ProcedureDto(
    val procNum: Long = 0, val patNum: Long = 0,
    val procCode: String? = null, val descript: String? = null,
    val toothNum: String? = null, val surf: String? = null,
    val procStatus: Int = 0, val procDate: String = "",
    val procFee: Double = 0.0, val procStatusName: String? = null,
    val note: String? = null
)
@Serializable data class ToothChart(val patNum: Long, val patientName: String, val teeth: List<ToothProc>)
@Serializable data class ToothProc(val toothNum: String, val procedures: List<ProcedureDto>)

// ── Payment ──────────────────────────────────────────
@Serializable data class PaymentDto(
    val payNum: Long = 0, val patNum: Long = 0, val patientName: String = "",
    val payDate: String = "", val payAmt: Double = 0.0,
    val payTypeName: String? = null, val note: String? = null
)
@Serializable data class PaymentSearchResult(val payments: List<PaymentDto>, val totalCount: Int, val totalAmount: Double)

// ── Prescription ─────────────────────────────────────
@Serializable data class PrescriptionDto(
    val rxNum: Long = 0, val patNum: Long = 0, val patientName: String = "",
    val drug: String = "", val sig: String? = null, val disp: String? = null,
    val refills: String? = null, val note: String? = null, val dateRx: String = ""
)

// ── Clinical Note ────────────────────────────────────
@Serializable data class ClinicalNoteDto(
    val commlogNum: Long = 0, val patNum: Long = 0, val patientName: String = "",
    val commDateTime: String = "", val commTypeName: String? = null,
    val note: String? = null, val userName: String? = null
)

// ══ ANALYTICS MODELS (dbt_dental_clinic) ═════════════

@Serializable data class DashboardKpi(
    val todayAppointments: Int = 0, val waitingRoom: Int = 0,
    val todayProduction: Double = 0.0, val pendingRx: Int = 0,
    val activePatients: Int = 0, val monthRevenue: Double = 0.0
)
@Serializable data class RevenueTrend(
    val period: String = "", val production: Double = 0.0,
    val collections: Double = 0.0, val adjustments: Double = 0.0
)
@Serializable data class ProviderSummary(val provNum: Long = 0, val provName: String = "", val production: Double = 0.0, val patients: Int = 0)
@Serializable data class ArAging(val range: String = "", val amount: Double = 0.0, val count: Int = 0)
