package com.example.odmobile.domain

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.odmobile.data.model.*
import com.example.odmobile.data.remote.HelianzApiService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class AuthViewModel(private val api: HelianzApiService) : ViewModel() {

    private val _state = MutableStateFlow(AuthState())
    val state: StateFlow<AuthState> = _state.asStateFlow()

    fun login(username: String, password: String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(isLoading = true)
            try {
                val r = api.login(username, password)
                api.setToken(r.token)
                _state.value = _state.value.copy(isLoading = false, isLoggedIn = true, displayName = r.displayName)
            } catch (e: Exception) {
                _state.value = _state.value.copy(isLoading = false, error = e.message)
            }
        }
    }

    fun logout() { api.setToken(null); _state.value = AuthState() }

    data class AuthState(val isLoading: Boolean = false, val isLoggedIn: Boolean = false,
                         val displayName: String = "", val error: String? = null)
}
