package com.example.odmobile.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ChevronLeft
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.odmobile.ui.theme.*

data class Appointment(
    val time: String,
    val patient: String,
    val procedure: String,
    val status: String,
    val statusColor: Color,
    val duration: String
)

@Composable
fun ScheduleScreen() {
    val scrollState = rememberScrollState()
    var selectedDay by remember { mutableStateOf(3) } // Today is the 3rd

    val appointments = listOf(
        Appointment("8:00 AM", "John Barker", "New Patient Exam", "Confirmed", Success, "60m"),
        Appointment("9:00 AM", "Maria Garcia", "Filling #30", "In Chair", Warning, "45m"),
        Appointment("10:00 AM", "David Lee", "Crown Seat #19", "Scheduled", Primary, "60m"),
        Appointment("11:00 AM", "BREAK", "", "Break", TextSecondary, "30m"),
        Appointment("1:00 PM", "Sarah Mitchell", "Crown Prep #14", "Here", Warning, "90m"),
        Appointment("2:45 PM", "James Rodriguez", "Cleaning, Exam", "Confirmed", Success, "45m"),
        Appointment("3:30 PM", "Emily Chen", "Root Canal #19", "Scheduled", Primary, "90m"),
        Appointment("5:00 PM", "Robert Kim", "Crown Delivery", "Scheduled", Primary, "60m")
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(16.dp)
    ) {
        Text("Schedule", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
        Text("Monday, August 3, 2026", color = TextSecondary, fontSize = 14.sp)

        Spacer(modifier = Modifier.height(16.dp))

        // Week day selector
        Card(shape = RoundedCornerShape(16.dp)) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(12.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                IconButton(onClick = { if (selectedDay > 1) selectedDay-- }) {
                    Icon(Icons.Default.ChevronLeft, "Previous day")
                }
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        when (selectedDay) {
                            1 -> "Saturday"
                            2 -> "Sunday"
                            3 -> "Monday"
                            4 -> "Tuesday"
                            5 -> "Wednesday"
                            6 -> "Thursday"
                            7 -> "Friday"
                            else -> "Monday"
                        },
                        fontWeight = FontWeight.Bold,
                        fontSize = 18.sp
                    )
                    Text("August $selectedDay, 2026", color = TextSecondary, fontSize = 14.sp)
                }
                IconButton(onClick = { if (selectedDay < 7) selectedDay++ }) {
                    Icon(Icons.Default.ChevronRight, "Next day")
                }
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Summary card
        Card(shape = RoundedCornerShape(16.dp)) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                ScheduleStat("12", "Appts")
                ScheduleStat("8h", "Hours")
                ScheduleStat("$4.2k", "Production")
                ScheduleStat("2", "Open Slots")
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Appointments list
        Text("Today's Appointments", fontWeight = FontWeight.SemiBold, fontSize = 16.sp)
        Spacer(modifier = Modifier.height(8.dp))

        appointments.forEach { appt ->
            if (appt.procedure == "BREAK") {
                BreakItem(appt.time)
            } else {
                ScheduleAppointmentItem(appt)
            }
            if (appt != appointments.last()) {
                HorizontalDivider(modifier = Modifier.padding(vertical = 4.dp))
            }
        }
    }
}

@Composable
fun ScheduleStat(value: String, label: String) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Text(value, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = Primary)
        Text(label, fontSize = 11.sp, color = TextSecondary)
    }
}

@Composable
fun ScheduleAppointmentItem(appt: Appointment) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp, horizontal = 4.dp),
        verticalAlignment = Alignment.Top
    ) {
        // Time column
        Column(
            modifier = Modifier.width(80.dp),
            horizontalAlignment = Alignment.Start
        ) {
            Text(appt.time, fontSize = 14.sp, fontWeight = FontWeight.Bold)
            Text(appt.duration, fontSize = 11.sp, color = TextSecondary)
        }

        // Status indicator
        Box(
            modifier = Modifier
                .width(4.dp)
                .height(48.dp)
                .clip(RoundedCornerShape(2.dp))
                .background(appt.statusColor)
        )

        Spacer(modifier = Modifier.width(12.dp))

        // Details
        Column(modifier = Modifier.weight(1f)) {
            Text(appt.patient, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
            Text(appt.procedure, fontSize = 13.sp, color = TextSecondary)
        }

        // Status badge
        Badge(
            containerColor = appt.statusColor.copy(alpha = 0.15f),
            contentColor = appt.statusColor
        ) {
            Text(appt.status, fontSize = 10.sp)
        }
    }
}

@Composable
fun BreakItem(time: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 6.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.Center
    ) {
        HorizontalDivider(modifier = Modifier.weight(0.2f))
        Text(
            "  $time - LUNCH BREAK  ",
            color = TextSecondary,
            fontSize = 12.sp,
            fontWeight = FontWeight.Medium
        )
        HorizontalDivider(modifier = Modifier.weight(0.2f))
    }
}
