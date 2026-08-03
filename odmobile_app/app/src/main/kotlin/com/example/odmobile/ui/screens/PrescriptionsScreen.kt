package com.example.odmobile.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.odmobile.ui.theme.*

data class Prescription(
    val patient: String,
    val medication: String,
    val dosage: String,
    val status: String,
    val statusColor: Color,
    val date: String
)

@Composable
fun PrescriptionsScreen() {
    val scrollState = rememberScrollState()
    var selectedFilter by remember { mutableStateOf("Pending") }
    val filters = listOf("Pending", "Approved", "All")

    val prescriptions = listOf(
        Prescription("Sarah Mitchell", "Amoxicillin", "500mg 3x/day, 7d", "Pending", Warning, "08/03/2026"),
        Prescription("James Rodriguez", "Ibuprofen 800mg", "1 tablet every 8h", "Approved", Success, "08/03/2026"),
        Prescription("Emily Chen", "Chlorhexidine", "Rinse 2x/day, 14d", "Pending", Warning, "08/02/2026"),
        Prescription("Robert Kim", "Hydrocodone/Acetaminophen", "1-2 tablets every 6h", "Approved", Success, "08/01/2026"),
        Prescription("Lisa Wang", "Doxycycline", "100mg 2x/day, 10d", "Pending", Warning, "07/31/2026"),
        Prescription("Michael Torres", "Clindamycin", "300mg 3x/day, 7d", "Approved", Success, "07/30/2026")
    )

    val filtered = when (selectedFilter) {
        "Pending" -> prescriptions.filter { it.status == "Pending" }
        "Approved" -> prescriptions.filter { it.status == "Approved" }
        else -> prescriptions
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(16.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text("Prescriptions", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
            FilledTonalButton(
                onClick = { },
                shape = RoundedCornerShape(12.dp)
            ) {
                Icon(Icons.Default.Add, null, modifier = Modifier.size(18.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("New Rx")
            }
        }

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
                    label = {
                        Text(
                            filter,
                            fontSize = 13.sp,
                            fontWeight = if (selectedFilter == filter) FontWeight.SemiBold else FontWeight.Normal
                        )
                    }
                )
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Count
        Text(
            "${filtered.size} prescriptions",
            color = TextSecondary,
            fontSize = 14.sp
        )

        Spacer(modifier = Modifier.height(8.dp))

        // Prescriptions list
        filtered.forEach { rx ->
            PrescriptionItem(rx)
            Spacer(modifier = Modifier.height(8.dp))
        }
    }
}

@Composable
fun PrescriptionItem(rx: Prescription) {
    Card(shape = RoundedCornerShape(12.dp), modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(14.dp),
            verticalAlignment = Alignment.Top
        ) {
            Icon(
                Icons.Default.Medication,
                contentDescription = null,
                tint = rx.statusColor,
                modifier = Modifier.size(24.dp)
            )
            Spacer(modifier = Modifier.width(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(rx.medication, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                Text("Patient: ${rx.patient}", fontSize = 13.sp, color = TextSecondary)
                Text(rx.dosage, fontSize = 13.sp, color = TextSecondary)
                Spacer(modifier = Modifier.height(4.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(rx.date, fontSize = 11.sp, color = TextSecondary)
                    Badge(
                        containerColor = rx.statusColor.copy(alpha = 0.15f),
                        contentColor = rx.statusColor
                    ) {
                        Text(rx.status, fontSize = 11.sp)
                    }
                }
            }
        }
    }
}
