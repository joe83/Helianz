package com.helianz.app.data.remote

import com.helianz.app.data.model.*
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.auth.*
import io.ktor.client.plugins.auth.providers.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.logging.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

class HelianzApiService(private val baseUrl: String = "http://100.64.0.2:5000") {

    private var authToken: String? = null

    private val json = Json {
        ignoreUnknownKeys = true
        isLenient = true
        coerceInputValues = true
    }

    private val client = HttpClient {
        install(ContentNegotiation) { json(this@HelianzApiService.json) }
        install(Logging) { level = LogLevel.BODY }
    }

    fun setToken(token: String?) { authToken = token }

    private suspend inline fun <reified T> get(path: String, params: Map<String, String> = emptyMap()): T {
        return client.get("$baseUrl$path") {
            authToken?.let { header(HttpHeaders.Authorization, "Bearer $it") }
            params.forEach { (k, v) -> parameter(k, v) }
        }.body()
    }

    private suspend inline fun <reified T, reified R> post(path: String, body: T): R {
        return client.post("$baseUrl$path") {
            authToken?.let { header(HttpHeaders.Authorization, "Bearer $it") }
            contentType(ContentType.Application.Json)
            setBody(body)
        }.body()
    }

    private suspend inline fun <reified T> postUnit(path: String, body: T) {
        client.post("$baseUrl$path") {
            authToken?.let { header(HttpHeaders.Authorization, "Bearer $it") }
            contentType(ContentType.Application.Json)
            setBody(body)
        }
    }

    private suspend inline fun <reified T> put(path: String, body: T) {
        client.put("$baseUrl$path") {
            authToken?.let { header(HttpHeaders.Authorization, "Bearer $it") }
            contentType(ContentType.Application.Json)
            setBody(body)
        }
    }

    // ── Auth ─────────────────────────────────────────

    suspend fun login(username: String, password: String): LoginResponse =
        post("/api/auth/login", LoginRequest(username, password))

    // ── Patients ─────────────────────────────────────

    suspend fun searchPatients(query: String? = null, clinicNum: Long? = null,
                               page: Int = 1, pageSize: Int = 20): PatientSearchResult {
        val params = mutableMapOf<String, String>()
        query?.let { params["query"] = it }
        clinicNum?.let { params["clinicNum"] = it.toString() }
        params["page"] = page.toString()
        params["pageSize"] = pageSize.toString()
        return get("/api/patients", params)
    }

    suspend fun getPatient(patNum: Long): PatientDto = get("/api/patients/$patNum")
    suspend fun createPatient(req: PatientCreateRequest): PatientDto = post("/api/patients", req)

    // ── Appointments ─────────────────────────────────

    suspend fun getTodayAppointments(clinicNum: Long? = null, provNum: Long? = null): List<AppointmentDto> {
        val params = mutableMapOf<String, String>()
        clinicNum?.let { params["clinicNum"] = it.toString() }
        provNum?.let { params["provNum"] = it.toString() }
        return get("/api/appointments/today", params)
    }

    suspend fun searchAppointments(dateFrom: String? = null, dateTo: String? = null,
                                   provNum: Long? = null, clinicNum: Long? = null,
                                   patNum: Long? = null, page: Int = 1,
                                   pageSize: Int = 50): AppointmentSearchResult {
        val params = mutableMapOf<String, String>()
        dateFrom?.let { params["dateFrom"] = it }
        dateTo?.let { params["dateTo"] = it }
        provNum?.let { params["provNum"] = it.toString() }
        clinicNum?.let { params["clinicNum"] = it.toString() }
        patNum?.let { params["patNum"] = it.toString() }
        params["page"] = page.toString()
        params["pageSize"] = pageSize.toString()
        return get("/api/appointments", params)
    }

    suspend fun createAppointment(req: AppointmentCreateRequest): AppointmentDto =
        post("/api/appointments", req)

    suspend fun completeAppointment(aptNum: Long) {
        postUnit("/api/appointments/$aptNum/complete", emptyMap<String, String>())
    }

    // ── Procedures / Charting ────────────────────────

    suspend fun getToothChart(patNum: Long): ToothChart =
        get("/api/procedures/chart/$patNum")

    suspend fun createProcedure(req: ProcedureCreateRequest) {
        postUnit("/api/procedures", req)
    }

    suspend fun completeProcedure(procNum: Long) {
        postUnit("/api/procedures/$procNum/complete", emptyMap<String, String>())
    }

    // ── Payments ─────────────────────────────────────

    suspend fun getPatientPayments(patNum: Long): PaymentSearchResult =
        get("/api/payments", mapOf("patNum" to patNum.toString()))

    suspend fun createPayment(req: PaymentCreateRequest): PaymentDto =
        post("/api/payments", req)

    // ── Prescriptions ────────────────────────────────

    suspend fun getPatientPrescriptions(patNum: Long): List<PrescriptionDto> =
        get("/api/prescriptions", mapOf("patNum" to patNum.toString()))

    suspend fun createPrescription(req: PrescriptionCreateRequest): PrescriptionDto =
        post("/api/prescriptions", req)

    // ── Notes ────────────────────────────────────────

    suspend fun getPatientNotes(patNum: Long): List<ClinicalNoteDto> =
        get("/api/notes", mapOf("patNum" to patNum.toString()))

    suspend fun createNote(req: NoteCreateRequest) {
        postUnit("/api/notes", req)
    }

    // ── Reference Data ───────────────────────────────

    suspend fun getReferenceData(clinicNum: Long = 0): ReferenceData =
        get("/api/reference", mapOf("clinicNum" to clinicNum.toString()))
}
