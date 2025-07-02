//
//  WeeklyStepsChart.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import SwiftUI
import Charts

struct WeeklyStepsChart: View {
    let steps: [DailyStep]

    var body: some View {
        Chart(steps) { entry in
            BarMark(
                x: .value("Day", entry.date, unit: .day),
                y: .value("Steps", entry.steps)
            )
            .foregroundStyle(.blue)
        }
        .frame(height: 200)
        .padding()
    }
}

