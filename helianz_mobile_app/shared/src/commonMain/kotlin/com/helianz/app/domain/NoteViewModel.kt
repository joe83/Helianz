package com.helianz.app.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.helianz.app.data.model.*
import com.helianz.app.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class NoteViewModel(private val api: HelianzApiService) : ViewModel() {

    private val _state = MutableStateFlow(NoteState())
    val state: StateFlow<NoteState> = _state.asStateFlow()

    fun loadNotes(patNum: Long) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val notes = api.getPatientNotes(patNum)
                _state.value = _state.value.copy(isLoading = false, notes = notes)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isLoading = false, error = e.message)
            }
        }
    }

    fun createNote(req: NoteCreateRequest) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isSaving = true)
            try {
                api.createNote(req)
                loadNotes(req.patNum)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isSaving = false, error = e.message)
            }
        }
    }

    data class NoteState(
        val isLoading: Boolean = false,
        val isSaving: Boolean = false,
        val notes: List<ClinicalNoteDto> = emptyList(),
        val error: String? = null
    )
}
