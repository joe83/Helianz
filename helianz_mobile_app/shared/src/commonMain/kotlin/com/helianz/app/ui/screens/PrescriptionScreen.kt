package com.helianz.app.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.helianz.app.data.model.PrescriptionDto
import com.helianz.app.domain.PrescriptionViewModel
import org.koin.compose.viewmodel.koinViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PrescriptionScreen(navController: NavHostController, patNum: Long,
                       vm: PrescriptionViewModel = koinViewModel()) {
    val state by vm.state.collectAsState()

    LaunchedEffect(patNum) { vm.loadPrescriptions(patNum) }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Prescriptions") },
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
            } else if (state.prescriptions.isEmpty()) {
                Text("No prescriptions", Modifier.align(Alignment.Center))
            } else {
                LazyColumn(Modifier.fillMaxSize().padding(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    items(state.prescriptions) { rx ->
                        PrescriptionCard(rx)
                    }
                }
            }
        }
    }
}

@Composable
fun PrescriptionCard(rx: PrescriptionDto) {
    ElevatedCard(Modifier.fillMaxWidth().padding(horizontal = 8.dp)) {
        Column(Modifier.padding(14.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text(rx.drug, style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.Bold)
                Text(rx.dateRx.take(10), style = MaterialTheme.typography.bodySmall)
            }
            if (rx.sig != null) {
                Spacer(Modifier.height(4.dp))
                Text("Sig: ${rx.sig}", style = MaterialTheme.typography.bodySmall)
            }
            if (rx.disp != null) {
                Text("Disp: ${rx.disp}  Refills: ${rx.refills ?: "0"}",
                    style = MaterialTheme.typography.bodySmall)
            }
            if (rx.note != null)
                Text(rx.note, style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
    }
}
