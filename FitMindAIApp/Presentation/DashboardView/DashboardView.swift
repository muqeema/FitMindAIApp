//
//  MainView.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import SwiftUI

struct DashboardView: View {
    @State private var isOnboarded: Bool = UserDefaults.standard.bool(forKey: "isOnboarded")
    @ObservedObject var viewModel: DashboardViewModel
    @State private var selectedTab: Int = 0

    var body: some View {
        if isOnboarded {
            VStack(spacing: 0) {
                ZStack {
                    switch selectedTab {
                    case 0:
                        TodayView(viewModel: viewModel)
                    case 1:
                        WeeklyChartView(viewModel: viewModel)
                    case 2:
                        AIInsightView(viewModel: viewModel)
                    case 3:
                        AIInsightHistoryView(viewModel: viewModel)
                    case 4:
                        SettingsView()
                    default:
                        Text("Unknown Tab")
                    }
                }
                CustomTabBar(selectedTab: $selectedTab)
            }

            .onAppear() {
                Task {
                    await viewModel.loadWeeklyHealthData()
                }
//                viewModel.loadInsightsFromStorage()
            }
        } else {
            OnboardingView(viewModel: OnboardingViewModel()) {
                UserDefaults.standard.set(true, forKey: "isOnboarded")
                isOnboarded = true
            }
        }
    }
}
