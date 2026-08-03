package com.helianz.app.di

import com.helianz.app.data.remote.HelianzApiService
import com.helianz.app.domain.AuthViewModel
import com.helianz.app.domain.PatientViewModel
import com.helianz.app.domain.AppointmentViewModel
import com.helianz.app.domain.ChartViewModel
import com.helianz.app.domain.PaymentViewModel
import com.helianz.app.domain.PrescriptionViewModel
import com.helianz.app.domain.NoteViewModel
import org.koin.core.module.dsl.viewModelOf
import org.koin.dsl.module

val appModule = module {
    // API service (singleton for shared token state)
    single { HelianzApiService() }

    // ViewModels
    viewModelOf(::AuthViewModel)
    viewModelOf(::PatientViewModel)
    viewModelOf(::AppointmentViewModel)
    viewModelOf(::ChartViewModel)
    viewModelOf(::PaymentViewModel)
    viewModelOf(::PrescriptionViewModel)
    viewModelOf(::NoteViewModel)
}
