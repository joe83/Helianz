package com.example.odmobile

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Message
import androidx.compose.material.icons.automirrored.filled.TrendingUp
import androidx.compose.material.icons.filled.*
import androidx.compose.ui.graphics.vector.ImageVector

sealed class Screen(val route: String, val title: String, val icon: ImageVector) {
    object Dashboard : Screen("dashboard", "Home", Icons.Default.Home)
    object Schedule : Screen("schedule", "Schedule", Icons.Default.CalendarToday)
    object Patients : Screen("patients", "Patients", Icons.Default.People)
    object Messages : Screen("messages", "Inbox", Icons.AutoMirrored.Filled.Message)
    object Billing : Screen("billing", "Billing", Icons.Default.AttachMoney)
    object Prescriptions : Screen("prescriptions", "Rx", Icons.Default.Medication)
}
