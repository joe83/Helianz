package com.helianz.app.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.helianz.app.data.model.PaymentDto
import com.helianz.app.domain.PaymentViewModel
import org.koin.compose.viewmodel.koinViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PaymentScreen(navController: NavHostController, patNum: Long,
                  vm: PaymentViewModel = koinViewModel()) {
    val state by vm.state.collectAsState()

    LaunchedEffect(patNum) { vm.loadPayments(patNum) }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Payments") },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "Back")
                    }
                })
        }
    ) { padding ->
        Box(Modifier.padding(padding).fillMaxSize()) {
            if (state.isLoading) {
                CircularProgressIndicator(Modifier.align(Alignment.Center))
            } else if (state.payments.isEmpty()) {
                Text("No payments", Modifier.align(Alignment.Center))
            } else {
                LazyColumn(Modifier.fillMaxSize().padding(8.dp),
                    verticalArrangement = Arrangement.spacedBy(6.dp)) {
                    items(state.payments) { pmt ->
                        PaymentCard(pmt)
                    }
                }
            }
        }
    }
}

@Composable
fun PaymentCard(pmt: PaymentDto) {
    ElevatedCard(Modifier.fillMaxWidth().padding(horizontal = 8.dp)) {
        Row(Modifier.padding(14.dp), horizontalArrangement = Arrangement.SpaceBetween) {
            Column(Modifier.weight(1f)) {
                Text(pmt.payDate.take(10), style = MaterialTheme.typography.bodySmall)
                Text(pmt.payTypeName ?: "Payment", style = MaterialTheme.typography.titleSmall)
                if (pmt.note != null)
                    Text(pmt.note, style = MaterialTheme.typography.bodySmall)
            }
            Text("Rp ${"%,.0f".format(pmt.payAmt)}",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.primary)
        }
    }
}
