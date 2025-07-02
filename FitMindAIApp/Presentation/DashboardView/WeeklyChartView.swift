//
//  WeeklyChartView.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import SwiftUI
import Charts

struct WeeklyChartView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        let comparison = DashboardAnalytics.computeWeeklyComparison(currentSteps: viewModel.weeklySteps, previousSteps: viewModel.previousWeekSteps, currentSleep: viewModel.weeklySleepHours, previousSleep: viewModel.previousWeekSleepHours)
        let wellness = DashboardAnalytics.computeWellnessScore(steps: viewModel.weeklySteps, sleep: viewModel.weeklySleepHours, stepTarget: viewModel.stepTarget, sleepTarget: viewModel.sleepTarget)
        ScrollView {
            VStack(spacing: 30) {
                Text("Weekly Steps")
                    .font(.headline)

                Chart(viewModel.weeklySteps) { item in
                    BarMark(
                        x: .value("Day", item.date, unit: .day),
                        y: .value("Steps", item.steps)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(height: 200)

                Text("Weekly Sleep Hours")
                    .font(.headline)

                Chart(viewModel.weeklySleepHours) { item in
                    BarMark(
                        x: .value("Day", item.date, unit: .day),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(.green)
                }
                .frame(height: 200)

                ExpandableCard(
                    title: "Weekly Comparison",
                    summary: "Steps: \(comparison.stepsDelta >= 0 ? "↑" : "↓") \(comparison.stepsDelta)",
                    details: "Sleep change: \(String(format: "%.1f", comparison.sleepDelta)) hrs"
                )

                ExpandableCard(
                    title: "Goal Trends",
                    summary: "Target tracking this week",
                    details: DashboardAnalytics.trendSummary(steps: viewModel.weeklySteps, sleep: viewModel.weeklySleepHours, stepTarget: viewModel.stepTarget, sleepTarget: viewModel.sleepTarget)
                )

                ExpandableCard(
                    title: "Wellness Score",
                    summary: "\(wellness) / 100",
                    details: "Based on weekly step & sleep goals"
                )
            }
            .padding()
        }
    }
}
