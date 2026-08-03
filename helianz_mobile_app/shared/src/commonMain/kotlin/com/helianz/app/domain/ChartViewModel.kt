package com.helianz.app.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.helianz.app.data.model.*
import com.helianz.app.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class ChartViewModel(private val api: HelianzApiService) : ViewModel() {

    private val _state = MutableStateFlow(ChartState())
    val state: StateFlow<ChartState> = _state.asStateFlow()

    fun loadChart(patNum: Long) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val chart = api.getToothChart(patNum)
                _state.value = _state.value.copy(isLoading = false, toothChart = chart)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isLoading = false, error = e.message)
            }
        }
    }

    fun addProcedure(req: ProcedureCreateRequest) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isSaving = true)
            try {
                api.createProcedure(req)
                loadChart(req.patNum)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isSaving = false, error = e.message)
            }
        }
    }

    data class ChartState(
        val isLoading: Boolean = false,
        val isSaving: Boolean = false,
        val toothChart: ToothChart? = null,
        val error: String? = null
    )
}
