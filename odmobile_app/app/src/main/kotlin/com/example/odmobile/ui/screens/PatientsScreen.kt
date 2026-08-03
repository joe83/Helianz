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
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.odmobile.ui.theme.*

data class Patient(
    val name: String,
    val dob: String,
    val id: String,
    val avatarGradient: List<Color>
)

@Composable
fun PatientsScreen(navController: NavController) {
    var searchQuery by remember { mutableStateOf("") }
    var selectedFilter by remember { mutableStateOf("All") }
    val filters = listOf("All", "Today", "Recall Due", "Outstanding")

    val patients = listOf(
        Patient("Sarah Mitchell", "05/12/1985", "#10421", listOf(Color(0xFF667EEA), Color(0xFF764BA2))),
        Patient("James Rodriguez", "11/23/1972", "#10422", listOf(Color(0xFFF093FB), Color(0xFFF5576C))),
        Patient("Emily Chen", "03/08/1990", "#10423", listOf(Color(0xFF4FACFE), Color(0xFF00F2FE))),
        Patient("Robert Kim", "07/19/1965", "#10424", listOf(Color(0xFF43E97B), Color(0xFF38F9D7))),
        Patient("Lisa Wang", "09/30/1988", "#10425", listOf(Color(0xFFFA709A), Color(0xFFFEE140))),
        Patient("Michael Torres", "01/14/1978", "#10426", listOf(Color(0xFFA8EDEA), Color(0xFFFED6E3)))
    )

    val filtered = patients.filter {
        it.name.contains(searchQuery, ignoreCase = true)
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        Text("Patients", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
        Text("1,247 active patients", color = TextSecondary, fontSize = 14.sp)

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
        filtered.forEach { patient ->
            PatientListItem(patient) {
                navController.navigate("patient_detail/${patient.name}")
            }
            Spacer(modifier = Modifier.height(8.dp))
        }
    }
}

@Composable
fun PatientListItem(patient: Patient, onClick: () -> Unit) {
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
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(CircleShape)
                    .background(Brush.linearGradient(patient.avatarGradient)),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    patient.name.split(" ").map { it[0] }.joinToString(""),
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp
                )
            }
            Spacer(modifier = Modifier.width(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(patient.name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                Text("DOB: ${patient.dob} • ID: ${patient.id}", fontSize = 12.sp, color = TextSecondary)
            }
            Icon(Icons.Default.ChevronRight, null, tint = TextSecondary)
        }
    }
}
