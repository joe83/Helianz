package com.helianz.app.ui

import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.UIViewController

// iOS entry point
fun MainViewController(): UIViewController =
    androidx.compose.ui.window.ComposeUIViewController {
        HelianzApp()
    }
