package com.example.odmobile.data.remote

import com.example.odmobile.data.model.*
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.logging.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

class HelianzApiService(private val baseUrl: String = "http://100.64.0.2:5000") {

    private var authToken: String? = null
    private val json = Json { ignoreUnknownKeys = true; isLenient = true }

    private val client = HttpClient {
        install(ContentNegotiation) { json(this@HelianzApiService.json) }
        install(Logging) { level = LogLevel.HEADERS }
    }

    fun setToken(token: String?) { authToken = token }

    private suspend inline fun <reified T> get(path: String, params: Map<String, String> = emptyMap()): T =
        client.get("$baseUrl$path") {
            authToken?.let { header(HttpHeaders.Authorization, "Bearer $it") }
            params.forEach { (k, v) -> parameter(k, v) }
        }.body()

    private suspend inline fun <reified T, reified R> post(path: String, body: T): R =
        client.post("$baseUrl$path") {
            authToken?.let { header(HttpHeaders.Authorization, "Bearer $it") }
            contentType(ContentType.Application.Json); setBody(body)
        }.body()

    // Auth
    suspend fun login(username: String, password: String): LoginResponse =
        post("/api/auth/login", LoginRequest(username, password))

    // Patients
    suspend fun searchPatients(query: String? = null): PatientSearchResult =
        get("/api/patients", buildMap { query?.let { put("query", it) } })

    suspend fun getPatient(patNum: Long): PatientDto = get("/api/patients/$patNum")

    // Appointments
    suspend fun getTodayAppointments(): List<AppointmentDto> = get("/api/appointments/today")
    suspend fun searchAppointments(dateFrom: String, dateTo: String): List<AppointmentDto> {
        val result: Map<String, List<AppointmentDto>> = get("/api/appointments",
            mapOf("dateFrom" to dateFrom, "dateTo" to dateTo, "aptStatus" to "1", "pageSize" to "100"))
        @Suppress("UNCHECKED_CAST")
        return (result["appointments"] as? List<*>)?.filterIsInstance<AppointmentDto>() ?: emptyList()
    }

    // Chart
    suspend fun getToothChart(patNum: Long): ToothChart = get("/api/procedures/chart/$patNum")

    // Payments
    suspend fun getPatientPayments(patNum: Long): PaymentSearchResult =
        get("/api/payments", mapOf("patNum" to patNum.toString()))

    // Prescriptions
    suspend fun getPatientPrescriptions(patNum: Long): List<PrescriptionDto> =
        get("/api/prescriptions", mapOf("patNum" to patNum.toString()))

    // Notes
    suspend fun getPatientNotes(patNum: Long): List<ClinicalNoteDto> =
        get("/api/notes", mapOf("patNum" to patNum.toString()))
}
