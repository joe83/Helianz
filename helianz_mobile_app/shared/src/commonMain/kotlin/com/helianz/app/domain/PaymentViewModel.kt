package com.helianz.app.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.helianz.app.data.model.*
import com.helianz.app.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class PaymentViewModel(private val api: HelianzApiService) : ViewModel() {

    private val _state = MutableStateFlow(PaymentState())
    val state: StateFlow<PaymentState> = _state.asStateFlow()

    fun loadPayments(patNum: Long) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val result = api.getPatientPayments(patNum)
                _state.value = _state.value.copy(isLoading = false, payments = result.payments)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isLoading = false, error = e.message)
            }
        }
    }

    fun createPayment(req: PaymentCreateRequest) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isSaving = true)
            try {
                api.createPayment(req)
                loadPayments(req.patNum)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isSaving = false, error = e.message)
            }
        }
    }

    data class PaymentState(
        val isLoading: Boolean = false,
        val isSaving: Boolean = false,
        val payments: List<PaymentDto> = emptyList(),
        val error: String? = null
    )
}
