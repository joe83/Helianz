package com.helianz.app.ui

import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.helianz.app.ui.screens.*
import org.koin.compose.KoinApplication
import com.helianz.app.di.appModule

@Composable
fun HelianzApp() {
    KoinApplication(application = { modules(appModule) }) {
        val navController = rememberNavController()
        NavHost(navController = navController, startDestination = "login") {
            composable("login") { LoginScreen(navController) }
            composable("home") { HomeScreen(navController) }
            composable("patients") { PatientListScreen(navController) }
            composable("patient/{patNum}") { backStackEntry ->
                val patNum = backStackEntry.arguments?.getString("patNum")?.toLongOrNull() ?: 0L
                PatientDetailScreen(navController, patNum)
            }
            composable("appointments") { AppointmentListScreen(navController) }
            composable("chart/{patNum}") { backStackEntry ->
                val patNum = backStackEntry.arguments?.getString("patNum")?.toLongOrNull() ?: 0L
                ToothChartScreen(navController, patNum)
            }
            composable("payments/{patNum}") { backStackEntry ->
                val patNum = backStackEntry.arguments?.getString("patNum")?.toLongOrNull() ?: 0L
                PaymentScreen(navController, patNum)
            }
            composable("prescriptions/{patNum}") { backStackEntry ->
                val patNum = backStackEntry.arguments?.getString("patNum")?.toLongOrNull() ?: 0L
                PrescriptionScreen(navController, patNum)
            }
            composable("notes/{patNum}") { backStackEntry ->
                val patNum = backStackEntry.arguments?.getString("patNum")?.toLongOrNull() ?: 0L
                NoteScreen(navController, patNum)
            }
        }
    }
}
