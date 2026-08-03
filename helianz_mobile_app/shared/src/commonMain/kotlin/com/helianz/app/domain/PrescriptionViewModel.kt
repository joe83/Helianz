package com.helianz.app.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.helianz.app.data.model.*
import com.helianz.app.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class PrescriptionViewModel(private val api: HelianzApiService) : ViewModel() {

    private val _state = MutableStateFlow(PrescriptionState())
    val state: StateFlow<PrescriptionState> = _state.asStateFlow()

    fun loadPrescriptions(patNum: Long) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val rx = api.getPatientPrescriptions(patNum)
                _state.value = _state.value.copy(isLoading = false, prescriptions = rx)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isLoading = false, error = e.message)
            }
        }
    }

    fun createPrescription(req: PrescriptionCreateRequest) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isSaving = true)
            try {
                api.createPrescription(req)
                loadPrescriptions(req.patNum)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isSaving = false, error = e.message)
            }
        }
    }

    data class PrescriptionState(
        val isLoading: Boolean = false,
        val isSaving: Boolean = false,
        val prescriptions: List<PrescriptionDto> = emptyList(),
        val error: String? = null
    )
}
