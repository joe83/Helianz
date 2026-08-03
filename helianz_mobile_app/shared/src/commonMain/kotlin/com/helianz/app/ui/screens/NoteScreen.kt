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
import com.helianz.app.data.model.ClinicalNoteDto
import com.helianz.app.domain.NoteViewModel
import org.koin.compose.viewmodel.koinViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NoteScreen(navController: NavHostController, patNum: Long,
               vm: NoteViewModel = koinViewModel()) {
    val state by vm.state.collectAsState()

    LaunchedEffect(patNum) { vm.loadNotes(patNum) }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Clinical Notes") },
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
            } else if (state.notes.isEmpty()) {
                Text("No notes", Modifier.align(Alignment.Center))
            } else {
                LazyColumn(Modifier.fillMaxSize().padding(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    items(state.notes) { note ->
                        NoteCard(note)
                    }
                }
            }
        }
    }
}

@Composable
fun NoteCard(note: ClinicalNoteDto) {
    ElevatedCard(Modifier.fillMaxWidth().padding(horizontal = 8.dp)) {
        Column(Modifier.padding(14.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text(note.commTypeName ?: "Note",
                    style = MaterialTheme.typography.titleSmall)
                Text(note.commDateTime.take(10),
                    style = MaterialTheme.typography.bodySmall)
            }
            Text("By: ${note.userName ?: "Unknown"}",
                style = MaterialTheme.typography.bodySmall)
            if (note.note != null) {
                Spacer(Modifier.height(6.dp))
                Text(note.note, style = MaterialTheme.typography.bodyMedium)
            }
        }
    }
}
