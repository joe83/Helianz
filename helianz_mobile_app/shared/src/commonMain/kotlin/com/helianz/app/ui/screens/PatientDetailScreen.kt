package com.helianz.app.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.helianz.app.data.model.PatientDto
import com.helianz.app.domain.PatientViewModel
import org.koin.compose.viewmodel.koinViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PatientDetailScreen(navController: NavHostController, patNum: Long,
                        vm: PatientViewModel = koinViewModel()) {
    val state by vm.state.collectAsState()
    val patient = state.selectedPatient

    LaunchedEffect(patNum) { vm.loadPatient(patNum) }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text(patient?.let { "${it.lName}, ${it.fName}" } ?: "Patient") },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "Back")
                    }
                })
        }
    ) { padding ->
        Column(modifier = Modifier.padding(padding).fillMaxSize()
            .verticalScroll(rememberScrollState()).padding(16.dp)) {

            patient?.let { p ->
                // Quick actions
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    QuickActionButton("Chart", modifier = Modifier.weight(1f)) { navController.navigate("chart/${p.patNum}") }
                    QuickActionButton("Payments", modifier = Modifier.weight(1f)) { navController.navigate("payments/${p.patNum}") }
                    QuickActionButton("Rx", modifier = Modifier.weight(1f)) { navController.navigate("prescriptions/${p.patNum}") }
                    QuickActionButton("Notes", modifier = Modifier.weight(1f)) { navController.navigate("notes/${p.patNum}") }
                }

                Spacer(Modifier.height(16.dp))

                // Demographics
                SectionHeader("Demographics")
                DetailRow("NIK/SSN", p.ssn ?: "-")
                DetailRow("Birthdate", p.birthdate.take(10))
                DetailRow("Gender", if (p.gender == 0) "Male" else if (p.gender == 1) "Female" else "Unknown")
                DetailRow("Chart #", p.chartNumber ?: "-")

                Spacer(Modifier.height(12.dp))

                // Contact
                SectionHeader("Contact")
                DetailRow("Phone", p.wirelessPhone ?: p.hmPhone ?: "-")
                DetailRow("Email", p.email ?: "-")
                DetailRow("Address", p.address ?: "-")
                if (!p.city.isNullOrBlank())
                    DetailRow("City", "${p.city}, ${p.state ?: ""} ${p.zip ?: ""}")

                Spacer(Modifier.height(12.dp))

                // Financial
                SectionHeader("Financial")
                DetailRow("Balance", "Rp ${"%,.0f".format(p.balanceTotal)}")
                DetailRow("Insurance Est", "Rp ${"%,.0f".format(p.insEstTotal)}")
                DetailRow("Insurance", if (p.hasIns) "Active" else "None")

                Spacer(Modifier.height(12.dp))

                // Clinic
                SectionHeader("Clinic Info")
                DetailRow("First Visit", p.dateFirstVisit.take(10))
                DetailRow("Status", when (p.patientStatus) { 0 -> "Active"; 1 -> "Inactive"; else -> "Other" })
            } ?: Text("Patient not found")
        }
    }
}

@Composable
fun SectionHeader(title: String) {
    Text(title, style = MaterialTheme.typography.titleSmall,
        color = MaterialTheme.colorScheme.primary)
    HorizontalDivider(Modifier.padding(vertical = 4.dp))
}

@Composable
fun DetailRow(label: String, value: String) {
    Row(Modifier.fillMaxWidth().padding(vertical = 2.dp)) {
        Text("$label: ", style = MaterialTheme.typography.bodyMedium)
        Text(value, style = MaterialTheme.typography.bodyMedium)
    }
}

@Composable
fun QuickActionButton(label: String, modifier: Modifier = Modifier, onClick: () -> Unit) {
    OutlinedButton(onClick = onClick, modifier = modifier,
        contentPadding = PaddingValues(horizontal = 8.dp, vertical = 4.dp)) {
        Text(label, style = MaterialTheme.typography.labelSmall)
    }
}
