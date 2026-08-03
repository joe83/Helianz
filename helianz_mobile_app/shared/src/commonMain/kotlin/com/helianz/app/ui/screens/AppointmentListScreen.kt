package com.helianz.app.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.helianz.app.data.model.AppointmentDto
import com.helianz.app.domain.AppointmentViewModel
import org.koin.compose.viewmodel.koinViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppointmentListScreen(navController: NavHostController,
                          vm: AppointmentViewModel = koinViewModel()) {
    val state by vm.state.collectAsState()

    LaunchedEffect(Unit) { vm.loadToday() }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Today's Appointments") },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "Back")
                    }
                })
        }
    ) { padding ->
        Box(Modifier.padding(padding).fillMaxSize()) {
            if (state.isLoading) {
                CircularProgressIndicator(Modifier.align(Alignment.Center))
            } else if (state.todayAppointments.isEmpty()) {
                Text("No appointments today",
                    Modifier.align(Alignment.Center),
                    style = MaterialTheme.typography.bodyLarge)
            } else {
                LazyColumn(Modifier.fillMaxSize().padding(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    items(state.todayAppointments) { apt ->
                        AppointmentCard(apt) {
                            vm.completeAppointment(apt.aptNum)
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun AppointmentCard(apt: AppointmentDto, onComplete: () -> Unit) {
    ElevatedCard(Modifier.fillMaxWidth().padding(horizontal = 8.dp)) {
        Row(Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
            Column(Modifier.weight(1f)) {
                Text(apt.patientName, style = MaterialTheme.typography.titleMedium)
                Text(apt.aptDateTime.takeLast(8).take(5),  // Extract time
                    style = MaterialTheme.typography.bodySmall)
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(apt.provName ?: "", style = MaterialTheme.typography.bodySmall)
                    Text(apt.opName ?: "", style = MaterialTheme.typography.bodySmall)
                }
                if (apt.note != null)
                    Text(apt.note, style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
            IconButton(onClick = onComplete) {
                Icon(Icons.Default.CheckCircle, "Complete",
                    tint = MaterialTheme.colorScheme.primary)
            }
        }
    }
}
