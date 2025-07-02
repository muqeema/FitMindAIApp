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
    
    var body: some View {
        if isOnboarded {
            TabView {
                TodayView(viewModel: viewModel)
                    .tabItem {
                        Label("Today", systemImage: "heart.fill")
                    }
                
                WeeklyChartView(weeklySteps: viewModel.weeklySteps, weeklySleep: viewModel.weeklySleepHours)
                    .tabItem {
                        Label("Weekly", systemImage: "chart.bar.fill")
                    }
                
                AIInsightView(viewModel: viewModel)
                    .tabItem {
                        Label("AI Insight", systemImage: "sparkles")
                    }
                
                AIInsightHistoryView(viewModel: viewModel)
                    .tabItem {
                        Label("History", systemImage: "line.horizontal.3")
                    }
                
                SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
            }
            .onAppear() {
                Task {
                    await viewModel.loadWeeklyHealthData()
                }
                viewModel.loadInsightsFromStorage()
            }
        } else {
            OnboardingView(viewModel: OnboardingViewModel()) {
                UserDefaults.standard.set(true, forKey: "isOnboarded")
                isOnboarded = true
            }
        }
    }
}

struct WeeklyChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyChartView(
            weeklySteps: [
                DailyStep(date: Date().addingTimeInterval(-86400 * 6), steps: 5000),
                DailyStep(date: Date().addingTimeInterval(-86400 * 5), steps: 7000),
                DailyStep(date: Date().addingTimeInterval(-86400 * 4), steps: 8000),
                DailyStep(date: Date().addingTimeInterval(-86400 * 3), steps: 6000),
                DailyStep(date: Date().addingTimeInterval(-86400 * 2), steps: 9000),
                DailyStep(date: Date().addingTimeInterval(-86400), steps: 4000),
                DailyStep(date: Date(), steps: 10000)
            ],
            weeklySleep: [
                DailySleep(date: Date().addingTimeInterval(-86400 * 6), hours: 6.0),
                DailySleep(date: Date().addingTimeInterval(-86400 * 5), hours: 7.5),
                DailySleep(date: Date().addingTimeInterval(-86400 * 4), hours: 8.0),
                DailySleep(date: Date().addingTimeInterval(-86400 * 3), hours: 5.5),
                DailySleep(date: Date().addingTimeInterval(-86400 * 2), hours: 7.0),
                DailySleep(date: Date().addingTimeInterval(-86400), hours: 6.5),
                DailySleep(date: Date(), hours: 8.2)
            ]
        )
    }
}
