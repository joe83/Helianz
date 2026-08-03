package com.helianz.app.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.helianz.app.domain.AuthViewModel
import org.koin.compose.viewmodel.koinViewModel

data class HomeMenuItem(val title: String, val icon: @Composable () -> Unit, val route: String)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(navController: NavHostController, authVm: AuthViewModel = koinViewModel()) {
    val authState by authVm.state.collectAsState()

    val menuItems = listOf(
        HomeMenuItem("Patients", { Icon(Icons.Default.Person, null) }, "patients"),
        HomeMenuItem("Today's Appointments", { Icon(Icons.Default.DateRange, null) }, "appointments"),
    )

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Helianz") }, actions = {
                TextButton(onClick = {
                    authVm.logout()
                    navController.navigate("login") { popUpTo(0) { inclusive = true } }
                }) { Text("Logout") }
            })
        }
    ) { padding ->
        Column(modifier = Modifier.padding(padding).fillMaxSize().padding(16.dp)) {
            Text("Welcome, ${authState.displayName}",
                style = MaterialTheme.typography.headlineSmall)
            Spacer(Modifier.height(24.dp))

            LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                items(menuItems) { item ->
                    ElevatedCard(modifier = Modifier.fillMaxWidth()
                        .clickable { navController.navigate(item.route) }) {
                        Row(modifier = Modifier.padding(20.dp),
                            verticalAlignment = androidx.compose.ui.Alignment.CenterVertically) {
                            item.icon()
                            Spacer(Modifier.width(16.dp))
                            Text(item.title, style = MaterialTheme.typography.titleMedium)
                        }
                    }
                }
            }
        }
    }
}
