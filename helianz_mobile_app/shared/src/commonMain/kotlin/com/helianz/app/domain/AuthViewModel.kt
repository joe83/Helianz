package com.helianz.app.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.helianz.app.data.model.*
import com.helianz.app.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class AuthViewModel(private val api: HelianzApiService) : ViewModel() {

    private val _state = MutableStateFlow(AuthState())
    val state: StateFlow<AuthState> = _state.asStateFlow()

    fun login(username: String, password: String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true, error = null)
            try {
                val result = api.login(username, password)
                api.setToken(result.token)
                _state.value = _state.value.copy(
                    isLoading = false,
                    isLoggedIn = true,
                    displayName = result.displayName,
                    token = result.token,
                    clinicNums = result.clinicNums,
                    currentClinicNum = result.clinicNum
                )
            } catch (e: Exception) {
                _state.value = _state.value.copy(
                    isLoading = false,
                    error = e.message ?: "Login failed"
                )
            }
        }
    }

    fun logout() {
        api.setToken(null)
        _state.value = AuthState()
    }

    data class AuthState(
        val isLoading: Boolean = false,
        val isLoggedIn: Boolean = false,
        val displayName: String = "",
        val token: String = "",
        val clinicNums: List<Long> = emptyList(),
        val currentClinicNum: Long = 0,
        val error: String? = null
    )
}
