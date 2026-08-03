package com.example.odmobile.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
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

@Composable
fun PatientDetailScreen(patientName: String, navController: NavController) {
    var selectedTab by remember { mutableStateOf(0) }
    val tabs = listOf("Info", "Treatment", "Chart", "Account")
    val initials = patientName.split(" ").map { it[0] }.joinToString("")

    Column(modifier = Modifier.fillMaxSize()) {
        // Header
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = { navController.popBackStack() }) {
                Icon(Icons.AutoMirrored.Filled.ArrowBack, null, tint = Primary)
            }
            Spacer(modifier = Modifier.width(8.dp))
            Box(
                modifier = Modifier
                    .size(50.dp)
                    .clip(CircleShape)
                    .background(Brush.linearGradient(listOf(Color(0xFF667EEA), Color(0xFF764BA2)))),
                contentAlignment = Alignment.Center
            ) {
                Text(initials, color = Color.White, fontWeight = FontWeight.Bold, fontSize = 18.sp)
            }
            Spacer(modifier = Modifier.width(12.dp))
            Column {
                Text(patientName, fontSize = 20.sp, fontWeight = FontWeight.Bold)
                Text("Patient ID: #10421", fontSize = 13.sp, color = TextSecondary)
            }
        }

        // Tabs
        TabRow(selectedTabIndex = selectedTab) {
            tabs.forEachIndexed { index, title ->
                Tab(
                    selected = selectedTab == index,
                    onClick = { selectedTab = index },
                    text = { Text(title, fontSize = 13.sp, fontWeight = FontWeight.SemiBold) }
                )
            }
        }

        // Content
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            when (selectedTab) {
                0 -> PatientInfoTab()
                1 -> PatientTreatmentTab()
                2 -> PatientChartTab()
                3 -> PatientAccountTab()
            }
        }
    }
}

@Composable
fun PatientInfoTab() {
    Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            SectionTitle("Demographics")
            DetailRow("Date of Birth", "May 12, 1985 (41y)")
            DetailRow("Gender", "Female")
            DetailRow("SSN", "***-**-4521")
            DetailRow("Marital Status", "Married")
        }
    }
    Spacer(modifier = Modifier.height(12.dp))
    Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            SectionTitle("Contact")
            DetailRow("Phone", "(555) 234-8901")
            DetailRow("Email", "sarah.m@email.com")
            DetailRow("Address", "4821 Oak Street, Apt 3B")
            DetailRow("City, State, ZIP", "Springfield, IL 62704")
        }
    }
    Spacer(modifier = Modifier.height(12.dp))
    Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            SectionTitle("Insurance")
            DetailRow("Primary", "Delta Dental PPO")
            DetailRow("Subscriber ID", "DD88452100")
            DetailRow("Group #", "GRP-9921-A")
            DetailRow("Annual Max", "$2,000 / $1,240 used")
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text("Expires", color = TextSecondary, fontSize = 14.sp)
                Text("Aug 15, 2026", color = Danger, fontWeight = FontWeight.Bold, fontSize = 14.sp)
            }
        }
    }
    Spacer(modifier = Modifier.height(16.dp))
    Button(
        onClick = { },
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp)
    ) {
        Text("Edit Patient Info")
    }
    OutlinedButton(
        onClick = { },
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp)
    ) {
        Text("New Appointment")
    }
}

@Composable
fun PatientTreatmentTab() {
    Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            SectionTitle("Active Treatment Plan")
            TreatmentRow("Crown - Porcelain/Ceramic", "Tooth #14", "$1,250")
            TreatmentRow("Core Buildup", "Tooth #14", "$285")
            TreatmentRow("Periodic Oral Evaluation", "Full mouth", "$65")
            HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text("Total", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                Text("$1,600", fontWeight = FontWeight.Bold, fontSize = 16.sp)
            }
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text("Insurance Est.", color = TextSecondary, fontSize = 13.sp)
                Text("-$960", color = TextSecondary, fontSize = 13.sp)
            }
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text("Patient Portion", color = Success, fontWeight = FontWeight.Bold, fontSize = 15.sp)
                Text("$640", color = Success, fontWeight = FontWeight.Bold, fontSize = 15.sp)
            }
        }
    }
}

@Composable
fun PatientChartTab() {
    Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            SectionTitle("Clinical Notes")
            Card(
                colors = CardDefaults.cardColors(containerColor = Color(0xFFF9FAFB))
            ) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text("Jul 15, 2026 - Dr. Anderson", fontSize = 12.sp, color = TextSecondary)
                    Text(
                        "Patient presents for 6-month recall. Good OH. #14 shows large MOD composite with marginal breakdown. Recommended crown.",
                        fontSize = 14.sp
                    )
                }
            }
            Spacer(modifier = Modifier.height(8.dp))
            Card(
                colors = CardDefaults.cardColors(containerColor = Color(0xFFF9FAFB))
            ) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text("Jan 10, 2026 - Dr. Anderson", fontSize = 12.sp, color = TextSecondary)
                    Text("Routine cleaning and exam. No new caries. Flossing improved.", fontSize = 14.sp)
                }
            }
        }
    }
    Spacer(modifier = Modifier.height(12.dp))
    Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            SectionTitle("Allergies & Medical Alerts")
            DetailRow("Penicillin", "ALLERGY")
            DetailRow("Latex", "ALLERGY")
            DetailRow("Blood Pressure", "128/82 (Last visit)")
        }
    }
}

@Composable
fun PatientAccountTab() {
    Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            SectionTitle("Account Summary")
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text("Current Balance", fontWeight = FontWeight.SemiBold, fontSize = 15.sp)
                Badge(containerColor = Danger.copy(alpha = 0.15f), contentColor = Danger) {
                    Text("$640.00", fontWeight = FontWeight.Bold)
                }
            }
        }
    }
    Spacer(modifier = Modifier.height(12.dp))
    Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            SectionTitle("Recent Transactions")
            TransactionRow("Crown Prep #14", "08/03/2026", "$1,250.00", Success)
            TransactionRow("Insurance Payment", "07/20/2026", "-$480.00", Primary)
            TransactionRow("Cleaning & Exam", "07/15/2026", "$95.00", Success)
            TransactionRow("Patient Payment", "06/28/2026", "-$200.00", Primary)
        }
    }
}

// Shared Components
@Composable
fun SectionTitle(title: String) {
    Text(title, fontSize = 16.sp, fontWeight = FontWeight.Bold, color = Primary)
    Spacer(modifier = Modifier.height(8.dp))
}

@Composable
fun DetailRow(label: String, value: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(label, color = TextSecondary, fontSize = 14.sp)
        Text(value, fontSize = 14.sp, fontWeight = FontWeight.Medium)
    }
}

@Composable
fun TreatmentRow(procedure: String, tooth: String, fee: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(procedure, fontSize = 14.sp, fontWeight = FontWeight.Medium)
            Text(tooth, fontSize = 12.sp, color = TextSecondary)
        }
        Text(fee, fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
    }
}

@Composable
fun TransactionRow(description: String, date: String, amount: String, color: Color) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(description, fontSize = 14.sp, fontWeight = FontWeight.Medium)
            Text(date, fontSize = 12.sp, color = TextSecondary)
        }
        Text(amount, fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = color)
    }
}
