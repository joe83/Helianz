package com.helianz.app.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.helianz.app.data.model.*
import com.helianz.app.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class PatientViewModel(private val api: HelianzApiService) : ViewModel() {

    private val _state = MutableStateFlow(PatientState())
    val state: StateFlow<PatientState> = _state.asStateFlow()

    fun search(query: String? = null, clinicNum: Long? = null) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true, error = null)
            try {
                val result = api.searchPatients(query, clinicNum)
                _state.value = _state.value.copy(
                    isLoading = false,
                    patients = result.patients,
                    totalCount = result.totalCount
                )
            } catch (e: Exception) {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = e.message ?: "Search failed"
                )
            }
        }
    }

    fun loadPatient(patNum: Long) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true, error = null)
            try {
                val patient = api.getPatient(patNum)
                _state.value = _state.value.copy(
                    isLoading = false,
                    selectedPatient = patient
                )
            } catch (e: Exception) {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = e.message ?: "Failed to load patient"
                )
            }
        }
    }

    fun selectPatient(patient: PatientDto) {
        _state.value = _state.value.copy(selectedPatient = patient)
    }

    fun clearSelection() {
        _state.value = _state.value.copy(selectedPatient = null)
    }

    data class PatientState(
        val isLoading: Boolean = false,
        val patients: List<PatientDto> = emptyList(),
        val totalCount: Int = 0,
        val selectedPatient: PatientDto? = null,
        val error: String? = null
    )
}
