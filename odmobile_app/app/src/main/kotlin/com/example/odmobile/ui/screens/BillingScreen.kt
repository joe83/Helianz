package com.example.odmobile.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.TrendingUp
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

data class Claim(
    val patient: String,
    val procedure: String,
    val amount: String,
    val status: String,
    val statusColor: Color,
    val date: String
)

@Composable
fun BillingScreen() {
    val scrollState = rememberScrollState()
    var selectedTab by remember { mutableStateOf(0) }

    val claims = listOf(
        Claim("Sarah Mitchell", "Crown - Porcelain #14", "$1,250", "Submitted", Primary, "08/03/2026"),
        Claim("James Rodriguez", "Prophylaxis Adult", "$95", "Paid", Success, "08/03/2026"),
        Claim("Emily Chen", "Root Canal #19", "$1,800", "Pending", Warning, "08/02/2026"),
        Claim("Robert Kim", "Crown Delivery #30", "$1,100", "Submitted", Primary, "08/01/2026"),
        Claim("Lisa Wang", "Composite Filling #3", "$285", "Paid", Success, "07/31/2026"),
        Claim("Michael Torres", "Bridge 3-unit", "$3,500", "Denied", Danger, "07/28/2026")
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(16.dp)
    ) {
        Text("Billing", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)

        Spacer(modifier = Modifier.height(16.dp))

        // Summary cards
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Card(
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFFDBEAFE))
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Icon(Icons.AutoMirrored.Filled.TrendingUp, null, tint = Primary, modifier = Modifier.size(24.dp))
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("$42.5k", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Primary)
                    Text("Monthly Revenue", fontSize = 11.sp, color = TextSecondary)
                }
            }
            Card(
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFFDCFCE7))
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Icon(Icons.Default.CheckCircle, null, tint = Success, modifier = Modifier.size(24.dp))
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("$38.1k", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Success)
                    Text("Collected", fontSize = 11.sp, color = TextSecondary)
                }
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Card(
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFFFEF3C7))
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Icon(Icons.Default.Pending, null, tint = Warning, modifier = Modifier.size(24.dp))
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("$4.4k", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Warning)
                    Text("Outstanding", fontSize = 11.sp, color = TextSecondary)
                }
            }
            Card(
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFFFEE2E2))
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Icon(Icons.Default.Cancel, null, tint = Danger, modifier = Modifier.size(24.dp))
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("$3.5k", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Danger)
                    Text("Denied", fontSize = 11.sp, color = TextSecondary)
                }
            }
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Tabs
        TabRow(selectedTabIndex = selectedTab) {
            Tab(selected = selectedTab == 0, onClick = { selectedTab = 0 }) {
                Text("Claims", modifier = Modifier.padding(12.dp), fontSize = 14.sp)
            }
            Tab(selected = selectedTab == 1, onClick = { selectedTab = 1 }) {
                Text("Payments", modifier = Modifier.padding(12.dp), fontSize = 14.sp)
            }
            Tab(selected = selectedTab == 2, onClick = { selectedTab = 2 }) {
                Text("Aging", modifier = Modifier.padding(12.dp), fontSize = 14.sp)
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Claims
        when (selectedTab) {
            0 -> {
                Text("Recent Claims", fontWeight = FontWeight.SemiBold, fontSize = 16.sp)
                Spacer(modifier = Modifier.height(8.dp))
                claims.forEach { claim ->
                    ClaimItem(claim)
                    Spacer(modifier = Modifier.height(8.dp))
                }
            }
            1 -> {
                // Payment summary
                Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        SectionTitle("This Month")
                        PaymentRow("Patient Payments", "$12,450", Success)
                        PaymentRow("Insurance Payments", "$25,650", Primary)
                        PaymentRow("Adjustments", "-$340", Danger)
                        HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text("Total Collected", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                            Text("$37,760", fontWeight = FontWeight.Bold, fontSize = 16.sp, color = Success)
                        }
                    }
                }
            }
            2 -> {
                // Aging report
                Card(shape = RoundedCornerShape(16.dp), modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        SectionTitle("Accounts Receivable Aging")
                        AgingRow("0-30 Days", "$2,100", Success)
                        AgingRow("31-60 Days", "$1,450", Warning)
                        AgingRow("61-90 Days", "$650", Color(0xFFF97316))
                        AgingRow("90+ Days", "$200", Danger)
                        HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text("Total A/R", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                            Text("$4,400", fontWeight = FontWeight.Bold, fontSize = 16.sp, color = Danger)
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun ClaimItem(claim: Claim) {
    Card(shape = RoundedCornerShape(12.dp), modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(14.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(claim.patient, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                Text(claim.procedure, fontSize = 13.sp, color = TextSecondary)
                Text(claim.date, fontSize = 11.sp, color = TextSecondary)
            }
            Column(horizontalAlignment = Alignment.End) {
                Text(claim.amount, fontSize = 16.sp, fontWeight = FontWeight.Bold)
                Badge(
                    containerColor = claim.statusColor.copy(alpha = 0.15f),
                    contentColor = claim.statusColor
                ) {
                    Text(claim.status, fontSize = 11.sp)
                }
            }
        }
    }
}

@Composable
fun PaymentRow(label: String, amount: String, color: Color) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(label, fontSize = 14.sp, color = TextSecondary)
        Text(amount, fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = color)
    }
}

@Composable
fun AgingRow(period: String, amount: String, color: Color) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 6.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
                modifier = Modifier
                    .size(10.dp)
                    .background(color, RoundedCornerShape(2.dp))
            )
            Spacer(modifier = Modifier.width(8.dp))
            Text(period, fontSize = 14.sp)
        }
        Text(amount, fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = color)
    }
}
