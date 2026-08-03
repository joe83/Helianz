package com.example.odmobile.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.odmobile.data.model.*
import com.example.odmobile.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class PatientsViewModel(private val api: HelianzApiService) : ViewModel() {

    private val _state = MutableStateFlow(PatientsState())
    val state: StateFlow<PatientsState> = _state.asStateFlow()

    fun search(query: String? = null) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val r = api.searchPatients(query)
                _state.value = _state.value.copy(isLoading = false, patients = r.patients, totalCount = r.totalCount)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isLoading = false, error = e.message)
            }
        }
    }

    data class PatientsState(val isLoading: Boolean = false, val patients: List<PatientDto> = emptyList(),
                             val totalCount: Int = 0, val error: String? = null)
}

class PatientDetailViewModel(private val api: HelianzApiService) : ViewModel() {
    private val _state = MutableStateFlow(DetailState())
    val state: StateFlow<DetailState> = _state.asStateFlow()

    fun load(patNum: Long) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val p = api.getPatient(patNum)
                val pmts = api.getPatientPayments(patNum)
                val rx = api.getPatientPrescriptions(patNum)
                val notes = api.getPatientNotes(patNum)
                _state.value = _state.value.copy(isLoading = false, patient = p, payments = pmts.payments, prescriptions = rx, notes = notes)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isLoading = false, error = e.message)
            }
        }
    }
    data class DetailState(val isLoading: Boolean = false, val patient: PatientDto? = null,
                           val payments: List<PaymentDto> = emptyList(), val prescriptions: List<PrescriptionDto> = emptyList(),
                           val notes: List<ClinicalNoteDto> = emptyList(), val error: String? = null)
}

class ScheduleViewModel(private val api: HelianzApiService) : ViewModel() {
    private val _state = MutableStateFlow(ScheduleState())
    val state: StateFlow<ScheduleState> = _state.asStateFlow()

    fun loadToday() {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try { _state.value = _state.value.copy(isLoading = false, appointments = api.getTodayAppointments()) }
            catch (e: Exception) { _state.value = _state.value.copy(isLoading = false, error = e.message) }
        }
    }
    data class ScheduleState(val isLoading: Boolean = false, val appointments: List<AppointmentDto> = emptyList(), val error: String? = null)
}

class BillingViewModel(private val api: HelianzApiService) : ViewModel() {
    private val _state = MutableStateFlow(BillingState())
    val state: StateFlow<BillingState> = _state.asStateFlow()

    fun loadAll() {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val patients = api.searchPatients().patients
                val payments = mutableListOf<PaymentDto>()
                for (p in patients.take(10)) {
                    try { payments.addAll(api.getPatientPayments(p.patNum).payments) } catch (_: Exception) {}
                }
                _state.value = _state.value.copy(isLoading = false, patients = patients, recentPayments = payments)
            } catch (e: Exception) { _state.value = _state.value.copy(isLoading = false, error = e.message) }
        }
    }
    data class BillingState(val isLoading: Boolean = false, val patients: List<PatientDto> = emptyList(),
                            val recentPayments: List<PaymentDto> = emptyList(), val error: String? = null)
}

class PrescriptionsViewModel(private val api: HelianzApiService) : ViewModel() {
    private val _state = MutableStateFlow(RxState())
    val state: StateFlow<RxState> = _state.asStateFlow()

    fun loadAll() {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val patients = api.searchPatients().patients
                val rx = mutableListOf<PrescriptionDto>()
                for (p in patients.take(10)) {
                    try { rx.addAll(api.getPatientPrescriptions(p.patNum)) } catch (_: Exception) {}
                }
                _state.value = _state.value.copy(isLoading = false, prescriptions = rx)
            } catch (e: Exception) { _state.value = _state.value.copy(isLoading = false, error = e.message) }
        }
    }
    data class RxState(val isLoading: Boolean = false, val prescriptions: List<PrescriptionDto> = emptyList(), val error: String? = null)
}
