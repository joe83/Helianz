package com.example.odmobile.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.odmobile.domain.PatientsViewModel
import com.example.odmobile.ui.theme.*
import org.koin.androidx.compose.koinViewModel

// Gradients for avatar circles
private val avatarGradients = listOf(
    listOf(Color(0xFF667EEA), Color(0xFF764BA2)),
    listOf(Color(0xFFF093FB), Color(0xFFF5576C)),
    listOf(Color(0xFF4FACFE), Color(0xFF00F2FE)),
    listOf(Color(0xFF43E97B), Color(0xFF38F9D7)),
    listOf(Color(0xFFFA709A), Color(0xFFFEE140)),
    listOf(Color(0xFFA8EDEA), Color(0xFFFED6E3)),
)

@Composable
fun PatientsScreen(navController: NavController, vm: PatientsViewModel = koinViewModel()) {
    val state by vm.state.collectAsState()
    var searchQuery by remember { mutableStateOf("") }
    var selectedFilter by remember { mutableStateOf("All") }
    val filters = listOf("All", "Today", "Recall Due", "Outstanding")

    LaunchedEffect(searchQuery) { vm.search(searchQuery.ifBlank { null }) }
    LaunchedEffect(Unit) { vm.search() }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        Text("Patients", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
        Text("${state.totalCount} active patients", color = TextSecondary, fontSize = 14.sp)

        Spacer(modifier = Modifier.height(12.dp))

        // Search
        OutlinedTextField(
            value = searchQuery,
            onValueChange = { searchQuery = it },
            placeholder = { Text("Search patients...") },
            leadingIcon = { Icon(Icons.Default.Search, null) },
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(12.dp),
            singleLine = true
        )

        Spacer(modifier = Modifier.height(12.dp))

        // Filters
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            filters.forEach { filter ->
                FilterChip(
                    selected = selectedFilter == filter,
                    onClick = { selectedFilter = filter },
                    label = { Text(filter, fontSize = 13.sp) }
                )
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Patient List
        if (state.isLoading) {
            Box(Modifier.fillMaxWidth().padding(32.dp), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        } else {
            state.patients.forEachIndexed { idx, patient ->
                val initials = "${patient.fName.take(1)}${patient.lName.take(1)}"
                val dob = patient.birthdate.take(10)
                val id = "#${patient.patNum}"
                val gradient = avatarGradients[idx % avatarGradients.size]
                PatientListItem(initials, "${patient.lName}, ${patient.fName}", dob, id, gradient) {
                    navController.navigate("patient_detail/${patient.lName}, ${patient.fName}#${patient.patNum}")
                }
                Spacer(modifier = Modifier.height(8.dp))
            }
        }
    }
}

@Composable
fun PatientListItem(initials: String, name: String, dob: String, id: String, gradient: List<Color>, onClick: () -> Unit) {
    Card(
        shape = RoundedCornerShape(12.dp),
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(modifier = Modifier.size(44.dp).clip(CircleShape)
                .background(Brush.linearGradient(gradient)), contentAlignment = Alignment.Center) {
                Text(initials, color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
            }
            Spacer(modifier = Modifier.width(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                Text("DOB: $dob • ID: $id", fontSize = 12.sp, color = TextSecondary)
            }
            Icon(Icons.Default.ChevronRight, null, tint = TextSecondary)
        }
    }
}
