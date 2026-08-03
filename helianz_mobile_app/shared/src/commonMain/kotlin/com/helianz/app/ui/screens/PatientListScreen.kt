package com.helianz.app.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Search
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
fun PatientListScreen(navController: NavHostController, vm: PatientViewModel = koinViewModel()) {
    val state by vm.state.collectAsState()
    var query by remember { mutableStateOf("") }

    LaunchedEffect(Unit) { vm.search() }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Patients (${state.totalCount})") },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "Back")
                    }
                })
        }
    ) { padding ->
        Column(modifier = Modifier.padding(padding).fillMaxSize()) {
            OutlinedTextField(value = query, onValueChange = { query = it },
                modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp),
                placeholder = { Text("Search by name, phone, chart #...") },
                trailingIcon = { IconButton(onClick = { vm.search(query.ifBlank { null }) }) {
                    Icon(Icons.Default.Search, "Search") } },
                singleLine = true)

            if (state.isLoading) {
                Box(Modifier.fillMaxSize(), contentAlignment = androidx.compose.ui.Alignment.Center) {
                    CircularProgressIndicator()
                }
            } else {
                LazyColumn(modifier = Modifier.fillMaxSize()) {
                    items(state.patients) { patient ->
                        PatientRow(patient) {
                            vm.selectPatient(patient)
                            navController.navigate("patient/${patient.patNum}")
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun PatientRow(patient: PatientDto, onClick: () -> Unit) {
    ElevatedCard(modifier = Modifier.fillMaxWidth()
        .padding(horizontal = 16.dp, vertical = 4.dp)
        .clickable(onClick = onClick)) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("${patient.lName}, ${patient.fName}",
                style = MaterialTheme.typography.titleMedium)
            Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                Text("Age: ${patient.age}", style = MaterialTheme.typography.bodySmall)
                Text("Gender: ${if (patient.gender == 0) "M" else "F"}",
                    style = MaterialTheme.typography.bodySmall)
                if (patient.hasIns)
                    Text("Insured", style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.primary)
            }
            if (patient.wirelessPhone != null)
                Text(patient.wirelessPhone, style = MaterialTheme.typography.bodySmall)
            if (patient.balanceTotal > 0)
                Text("Balance: Rp ${"%,.0f".format(patient.balanceTotal)}",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.error)
        }
    }
}
