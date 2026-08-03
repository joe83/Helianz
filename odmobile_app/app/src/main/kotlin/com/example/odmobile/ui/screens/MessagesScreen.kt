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
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.odmobile.ui.theme.*

data class Message(
    val sender: String,
    val subject: String,
    val preview: String,
    val time: String,
    val unread: Boolean,
    val avatarColor: Color
)

@Composable
fun MessagesScreen() {
    val scrollState = rememberScrollState()
    var selectedTab by remember { mutableStateOf(0) }

    val messages = listOf(
        Message("Dr. Anderson", "Lab Case #4421 Ready", "The crown for Robert Kim has arrived from the lab...", "10:30 AM", true, Primary),
        Message("Front Desk", "Patient Early Arrival", "Sarah Mitchell arrived 15 min early for her 2:15 PM...", "9:45 AM", true, Warning),
        Message("Jane (Hygienist)", "Room 3 Ready", "Room 3 is set up for James Rodriguez cleaning...", "9:15 AM", false, Success),
        Message("Billing Dept", "Insurance Pre-auth", "Delta Dental pre-auth for Emily Chen's root canal...", "Yesterday", true, Danger),
        Message("Dr. Anderson", "Treatment Plan Review", "Can you review the tx plan for new patient John Barker?...", "Yesterday", false, Primary),
        Message("Lab", "Case Update", "Michael's bridge is in the final glazing stage...", "Mon", false, Color(0xFF8B5CF6)),
        Message("Dr. Anderson", "Staff Meeting", "Reminder: Monthly staff meeting this Friday at 7:30 AM...", "Sun", false, TextSecondary)
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(16.dp)
    ) {
        Text("Messages", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)

        Spacer(modifier = Modifier.height(12.dp))

        // Tabs
        TabRow(selectedTabIndex = selectedTab) {
            Tab(selected = selectedTab == 0, onClick = { selectedTab = 0 }) {
                Row(
                    modifier = Modifier.padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Inbox", fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
                    val unreadCount = messages.count { it.unread }
                    if (unreadCount > 0) {
                        Spacer(modifier = Modifier.width(6.dp))
                        Badge(containerColor = Danger) {
                            Text("$unreadCount", fontSize = 11.sp)
                        }
                    }
                }
            }
            Tab(selected = selectedTab == 1, onClick = { selectedTab = 1 }) {
                Text("Sent", modifier = Modifier.padding(12.dp), fontSize = 14.sp)
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Messages
        messages.forEach { msg ->
            MessageItem(msg)
            Spacer(modifier = Modifier.height(4.dp))
            HorizontalDivider(color = Border)
            Spacer(modifier = Modifier.height(4.dp))
        }
    }
}

@Composable
fun MessageItem(msg: Message) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { }
            .padding(vertical = 8.dp),
        verticalAlignment = Alignment.Top
    ) {
        // Avatar
        Box(
            modifier = Modifier
                .size(44.dp)
                .clip(CircleShape)
                .background(msg.avatarColor.copy(alpha = 0.15f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                if (msg.sender.startsWith("Dr.")) Icons.Default.Person else Icons.Default.Email,
                contentDescription = null,
                tint = msg.avatarColor,
                modifier = Modifier.size(22.dp)
            )
        }

        Spacer(modifier = Modifier.width(12.dp))

        Column(modifier = Modifier.weight(1f)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    msg.sender,
                    fontSize = 15.sp,
                    fontWeight = if (msg.unread) FontWeight.Bold else FontWeight.SemiBold
                )
                Text(msg.time, fontSize = 12.sp, color = TextSecondary)
            }
            Text(
                msg.subject,
                fontSize = 14.sp,
                fontWeight = if (msg.unread) FontWeight.SemiBold else FontWeight.Normal
            )
            Text(msg.preview, fontSize = 12.sp, color = TextSecondary, maxLines = 1)
        }
    }
}
