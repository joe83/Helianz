package com.example.odmobile.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.odmobile.data.model.DashboardKpi
import com.example.odmobile.data.remote.AnalyticsApiService
import com.example.odmobile.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class DashboardViewModel(
    private val api: HelianzApiService,
    private val analytics: AnalyticsApiService
) : ViewModel() {

    private val _state = MutableStateFlow(DashboardState())
    val state: StateFlow<DashboardState> = _state.asStateFlow()

    fun load() {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val kpi = analytics.getDashboardKpis()
                val todayApts = api.getTodayAppointments()
                _state.value = _state.value.copy(
                    isLoading = false,
                    kpi = kpi,
                    todayAppointments = todayApts
                )
            } catch (e: Exception) {
                _state.value = _state.value.copy(isLoading = false, error = e.message)
            }
        }
    }

    data class DashboardState(
        val isLoading: Boolean = false,
        val kpi: DashboardKpi? = null,
        val todayAppointments: List<com.example.odmobile.data.model.AppointmentDto> = emptyList(),
        val error: String? = null
    )
}
