package com.example.odmobile.data.di

import com.example.odmobile.data.remote.AnalyticsApiService
import com.example.odmobile.data.remote.HelianzApiService
import com.example.odmobile.domain.*
import org.koin.androidx.viewmodel.dsl.viewModelOf
import org.koin.dsl.module

val appModule = module {
    single { HelianzApiService() }
    single { AnalyticsApiService() }
    viewModelOf(::AuthViewModel)
    viewModelOf(::DashboardViewModel)
    viewModelOf(::PatientsViewModel)
    viewModelOf(::ScheduleViewModel)
    viewModelOf(::PatientDetailViewModel)
    viewModelOf(::BillingViewModel)
    viewModelOf(::PrescriptionsViewModel)
}
