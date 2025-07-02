//
//  WeeklyChartView.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import SwiftUI
import Charts

struct WeeklyChartView: View {
    let weeklySteps: [DailyStep]
    let weeklySleep: [DailySleep]

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Weekly Steps")
                    .font(.headline)

                Chart(weeklySteps) { item in
                    BarMark(
                        x: .value("Day", item.date, unit: .day),
                        y: .value("Steps", item.steps)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(height: 200)

                Text("Weekly Sleep Hours")
                    .font(.headline)

                Chart(weeklySleep) { item in
                    BarMark(
                        x: .value("Day", item.date, unit: .day),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(.green)
                }
                .frame(height: 200)
            }
            .padding()
        }
    }
}
