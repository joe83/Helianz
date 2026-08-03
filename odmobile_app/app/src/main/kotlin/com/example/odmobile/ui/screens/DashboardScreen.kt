package com.example.odmobile.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.odmobile.Screen
import com.example.odmobile.ui.theme.*

@Composable
fun DashboardScreen(navController: NavController) {
    val scrollState = rememberScrollState()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(16.dp)
    ) {
        Text("Dashboard", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
        Text("Monday, August 3, 2026", color = TextSecondary, fontSize = 14.sp)

        Spacer(modifier = Modifier.height(16.dp))

        // Quick Actions
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            QuickAction("Patients", Icons.Default.People, Color(0xFFDBEAFE), Primary) {
                navController.navigate(Screen.Patients.route)
            }
            QuickAction("Schedule", Icons.Default.CalendarToday, Color(0xFFDCFCE7), Success) {
                navController.navigate(Screen.Schedule.route)
            }
            QuickAction("Rx", Icons.Default.Medication, Color(0xFFFEF3C7), Warning) {
                navController.navigate(Screen.Prescriptions.route)
            }
            QuickAction("Billing", Icons.Default.AttachMoney, Color(0xFFFEE2E2), Danger) {
                navController.navigate(Screen.Billing.route)
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Stats
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            StatCard("12", "Today's Appts")
            StatCard("3", "Waiting Room")
            StatCard("$4.2k", "Production")
            StatCard("5", "Pending Rx")
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Up Next
        Card(shape = RoundedCornerShape(16.dp)) {
            Column(modifier = Modifier.padding(16.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Up Next", fontWeight = FontWeight.SemiBold, fontSize = 16.sp)
                    Badge(containerColor = Color(0xFFDBEAFE), contentColor = Primary) {
                        Text("2:15 PM", fontSize = 11.sp)
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
                AppointmentItem("2:15", "PM", "Sarah Mitchell", "Crown Prep #14, X-rays", "Here", Warning) {
                    navController.navigate("patient_detail/Sarah Mitchell")
                }
                AppointmentItem("2:45", "PM", "James Rodriguez", "Cleaning, Exam", "Confirmed", Success) {
                    navController.navigate("patient_detail/James Rodriguez")
                }
                AppointmentItem("3:30", "PM", "Emily Chen", "Root Canal #19", "Scheduled", Primary) {
                    navController.navigate("patient_detail/Emily Chen")
                }
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Alerts
        Card(shape = RoundedCornerShape(16.dp)) {
            Column(modifier = Modifier.padding(16.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Alerts", fontWeight = FontWeight.SemiBold, fontSize = 16.sp)
                    Badge(containerColor = Color(0xFFFEE2E2), contentColor = Danger) {
                        Text("3 New", fontSize = 11.sp)
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
                AlertItem("Insurance Expiring", "Sarah Mitchell - Delta Dental ends 08/15", "10m", Danger)
                AlertItem("Lab Case Ready", "Crown for Robert Kim - Lab #4421", "1h", Primary)
            }
        }
    }
}

@Composable
fun QuickAction(
    label: String,
    icon: ImageVector,
    bgColor: Color,
    iconColor: Color,
    onClick: () -> Unit
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.clickable(onClick = onClick).padding(4.dp)
    ) {
        Box(
            modifier = Modifier
                .size(48.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(bgColor),
            contentAlignment = Alignment.Center
        ) {
            Icon(icon, contentDescription = label, tint = iconColor, modifier = Modifier.size(22.dp))
        }
        Spacer(modifier = Modifier.height(4.dp))
        Text(label, fontSize = 11.sp, fontWeight = FontWeight.Medium)
    }
}

@Composable
fun StatCard(value: String, label: String) {
    Card(
        modifier = Modifier.size(width = 78.dp, height = 80.dp),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(
            modifier = Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(value, fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Primary)
            Text(label, fontSize = 10.sp, color = TextSecondary)
        }
    }
}

@Composable
fun AppointmentItem(
    time: String,
    ampm: String,
    name: String,
    proc: String,
    status: String,
    statusColor: Color,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(
            modifier = Modifier.width(50.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(time, fontSize = 14.sp, fontWeight = FontWeight.Bold)
            Text(ampm, fontSize = 10.sp, color = TextSecondary)
        }
        Column(modifier = Modifier.weight(1f)) {
            Text(name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
            Text(proc, fontSize = 13.sp, color = TextSecondary)
        }
        Badge(
            containerColor = statusColor.copy(alpha = 0.15f),
            contentColor = statusColor
        ) {
            Text(status, fontSize = 11.sp)
        }
    }
}

@Composable
fun AlertItem(title: String, desc: String, time: String, iconColor: Color) {
    Row(
        modifier = Modifier.padding(vertical = 8.dp),
        verticalAlignment = Alignment.Top
    ) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .clip(RoundedCornerShape(10.dp))
                .background(iconColor.copy(alpha = 0.1f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(Icons.Default.Info, contentDescription = null, tint = iconColor, modifier = Modifier.size(18.dp))
        }
        Spacer(modifier = Modifier.width(12.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(title, fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
            Text(desc, fontSize = 12.sp, color = TextSecondary)
        }
        Text(time, fontSize = 11.sp, color = TextSecondary)
    }
}
