//
//  WeeklySleepChart.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import SwiftUI
import Charts

struct WeeklySleepChart: View {
    let sleepHours: [DailySleep]

    var body: some View {
        Chart(sleepHours) { entry in
            LineMark(
                x: .value("Day", entry.date, unit: .day),
                y: .value("Sleep Hours", entry.hours)
            )
            .foregroundStyle(.blue)
        }
        .frame(height: 200)
        .padding()
    }
}
