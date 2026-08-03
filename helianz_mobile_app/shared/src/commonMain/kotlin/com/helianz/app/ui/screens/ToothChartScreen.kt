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
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.helianz.app.data.model.ToothProcedure
import com.helianz.app.domain.ChartViewModel
import org.koin.compose.viewmodel.koinViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ToothChartScreen(navController: NavHostController, patNum: Long,
                     vm: ChartViewModel = koinViewModel()) {
    val state by vm.state.collectAsState()

    LaunchedEffect(patNum) { vm.loadChart(patNum) }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text(state.toothChart?.patientName ?: "Tooth Chart") },
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
            } else if (state.toothChart == null || state.toothChart!!.teeth.isEmpty()) {
                Text("No chart data", Modifier.align(Alignment.Center))
            } else {
                LazyColumn(Modifier.fillMaxSize().padding(8.dp),
                    verticalArrangement = Arrangement.spacedBy(4.dp)) {
                    items(state.toothChart!!.teeth) { tooth ->
                        ToothCard(tooth)
                    }
                }
            }
        }
    }
}

@Composable
fun ToothCard(tooth: ToothProcedure) {
    if (tooth.procedures.isEmpty()) return
    ElevatedCard(Modifier.fillMaxWidth().padding(horizontal = 8.dp)) {
        Column(Modifier.padding(12.dp)) {
            Text("Tooth ${tooth.toothNum}",
                style = MaterialTheme.typography.titleSmall,
                fontWeight = FontWeight.Bold)
            tooth.procedures.forEach { proc ->
                Row(Modifier.fillMaxWidth().padding(vertical = 2.dp),
                    horizontalArrangement = Arrangement.SpaceBetween) {
                    Text("${proc.procCode ?: ""} - ${proc.descript ?: ""}",
                        Modifier.weight(1f),
                        style = MaterialTheme.typography.bodySmall)
                    Surface(color = when (proc.procStatus) {
                        2 -> MaterialTheme.colorScheme.primaryContainer
                        1 -> MaterialTheme.colorScheme.tertiaryContainer
                        else -> MaterialTheme.colorScheme.surfaceVariant
                    }, shape = MaterialTheme.shapes.extraSmall) {
                        Text(proc.procStatusName ?: "",
                            Modifier.padding(horizontal = 8.dp, vertical = 2.dp),
                            style = MaterialTheme.typography.labelSmall)
                    }
                }
                if (proc.surf != null)
                    Text("  Surface: ${proc.surf}",
                        style = MaterialTheme.typography.bodySmall)
            }
        }
    }
}
