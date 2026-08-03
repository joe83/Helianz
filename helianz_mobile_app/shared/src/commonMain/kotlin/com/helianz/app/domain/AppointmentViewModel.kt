package com.helianz.app.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.helianz.app.data.model.*
import com.helianz.app.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class AppointmentViewModel(private val api: HelianzApiService) : ViewModel() {

    private val _state = MutableStateFlow(AppointmentState())
    val state: StateFlow<AppointmentState> = _state.asStateFlow()

    fun loadToday(clinicNum: Long? = null, provNum: Long? = null) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val appointments = api.getTodayAppointments(clinicNum, provNum)
                _state.value = _state.value.copy(
                    isLoading = false,
                    todayAppointments = appointments
                )
            } catch (e: Exception) {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = e.message ?: "Failed to load appointments"
                )
            }
        }
    }

    fun createAppointment(req: AppointmentCreateRequest) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isSaving = true)
            try {
                api.createAppointment(req)
                _state.value = _state.value.copy(isSaving = false, appointmentCreated = true)
            } catch (e: Exception) {
                _state.value = _state.value.copy(
                    isSaving = false,
                    error = e.message ?: "Failed to create appointment"
                )
            }
        }
    }

    fun completeAppointment(aptNum: Long) {
        viewModelScope.launch {
            try {
                api.completeAppointment(aptNum)
                // Reload
                _state.value.todayAppointments.firstOrNull()?.clinicNum?.let { loadToday(it) }
            } catch (e: Exception) {
                _state.value = _state.value.copy(error = e.message)
            }
        }
    }

    data class AppointmentState(
        val isLoading: Boolean = false,
        val isSaving: Boolean = false,
        val todayAppointments: List<AppointmentDto> = emptyList(),
        val appointmentCreated: Boolean = false,
        val error: String? = null
    )
}
