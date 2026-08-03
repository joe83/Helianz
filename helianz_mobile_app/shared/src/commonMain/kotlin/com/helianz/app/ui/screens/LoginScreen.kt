package com.helianz.app.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.helianz.app.domain.AuthViewModel
import org.koin.compose.viewmodel.koinViewModel

@Composable
fun LoginScreen(navController: NavHostController, vm: AuthViewModel = koinViewModel()) {
    val state by vm.state.collectAsState()
    var username by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    LaunchedEffect(state.isLoggedIn) {
        if (state.isLoggedIn) navController.navigate("home") {
            popUpTo("login") { inclusive = true }
        }
    }

    Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
        Column(
            modifier = Modifier.fillMaxSize().padding(32.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text("Helianz", style = MaterialTheme.typography.headlineLarge,
                color = MaterialTheme.colorScheme.primary)
            Spacer(Modifier.height(8.dp))
            Text("Dental Practice Management", style = MaterialTheme.typography.bodyMedium)

            Spacer(Modifier.height(48.dp))

            OutlinedTextField(value = username, onValueChange = { username = it },
                label = { Text("Username") }, modifier = Modifier.fillMaxWidth(),
                singleLine = true)
            Spacer(Modifier.height(16.dp))
            OutlinedTextField(value = password, onValueChange = { password = it },
                label = { Text("Password") }, modifier = Modifier.fillMaxWidth(),
                visualTransformation = PasswordVisualTransformation(),
                singleLine = true,
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password))

            if (state.error != null) {
                Spacer(Modifier.height(8.dp))
                Text(state.error!!, color = MaterialTheme.colorScheme.error)
            }

            Spacer(Modifier.height(24.dp))

            Button(onClick = { vm.login(username, password) },
                modifier = Modifier.fillMaxWidth().height(48.dp),
                enabled = !state.isLoading && username.isNotBlank() && password.isNotBlank()) {
                if (state.isLoading) CircularProgressIndicator(modifier = Modifier.size(24.dp))
                else Text("Login")
            }
        }
    }
}
