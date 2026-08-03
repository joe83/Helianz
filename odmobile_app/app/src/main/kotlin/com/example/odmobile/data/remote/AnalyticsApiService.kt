package com.example.odmobile.data.remote

import com.example.odmobile.data.model.*
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

class AnalyticsApiService(private val baseUrl: String = "http://100.64.0.2:8000") {

    private val json = Json { ignoreUnknownKeys = true; isLenient = true }
    private val client = HttpClient {
        install(ContentNegotiation) { json(this@AnalyticsApiService.json) }
    }

    suspend fun getDashboardKpis(): DashboardKpi =
        client.get("$baseUrl/reports/dashboard/").body()

    suspend fun getRevenueTrends(startDate: String, endDate: String): List<RevenueTrend> =
        client.get("$baseUrl/reports/revenue/trends") {
            parameter("start_date", startDate); parameter("end_date", endDate)
        }.body()

    suspend fun getProviders(): List<ProviderSummary> =
        client.get("$baseUrl/reports/providers/").body()

    suspend fun getArAging(): List<ArAging> =
        client.get("$baseUrl/reports/ar/").body()
}
