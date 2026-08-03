package com.example.odmobile

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.example.odmobile.data.di.appModule
import com.example.odmobile.ui.screens.*
import com.example.odmobile.ui.screens.login.LoginScreen
import com.example.odmobile.ui.theme.ODMobileTheme
import org.koin.android.ext.koin.androidContext
import org.koin.compose.KoinApplication

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            KoinApplication(application = {
                androidContext(this@MainActivity)
                modules(appModule)
            }) {
                ODMobileTheme { ODMobileApp() }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ODMobileApp() {
    val navController = rememberNavController()
    val items = listOf(Screen.Dashboard, Screen.Schedule, Screen.Patients, Screen.Messages, Screen.Billing)

    Scaffold(
        bottomBar = {
            NavigationBar {
                val navBackStackEntry by navController.currentBackStackEntryAsState()
                val currentDestination = navBackStackEntry?.destination
                items.forEach { screen ->
                    NavigationBarItem(
                        icon = { Icon(screen.icon, contentDescription = screen.title) },
                        label = { Text(screen.title) },
                        selected = currentDestination?.hierarchy?.any { it.route == screen.route } == true,
                        onClick = {
                            navController.navigate(screen.route) {
                                popUpTo(navController.graph.findStartDestination().id) { saveState = true }
                                launchSingleTop = true; restoreState = true
                            }
                        }
                    )
                }
            }
        }
    ) { innerPadding ->
        NavHost(navController = navController, startDestination = "login",
            modifier = Modifier.padding(innerPadding)) {
            composable("login") { LoginScreen(navController) }
            composable(Screen.Dashboard.route) { DashboardScreen(navController) }
            composable(Screen.Schedule.route) { ScheduleScreen() }
            composable(Screen.Patients.route) { PatientsScreen(navController) }
            composable(Screen.Prescriptions.route) { PrescriptionsScreen() }
            composable(Screen.Messages.route) { MessagesScreen() }
            composable(Screen.Billing.route) { BillingScreen() }
            composable("patient_detail/{patientName}") { backStackEntry ->
                val name = backStackEntry.arguments?.getString("patientName") ?: ""
                val patNum = name.substringAfterLast("#").toLongOrNull() ?: 0L
                PatientDetailScreen(patientName = name, navController = navController, patNum = patNum)
            }
        }
    }
}
