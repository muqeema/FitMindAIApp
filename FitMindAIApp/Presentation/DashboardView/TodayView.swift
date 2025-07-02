//
//  TodayView.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Label("Steps Today", systemImage: "figure.walk")
                        .font(.headline)
                    Text("\(viewModel.steps)")
                        .font(.largeTitle.bold())
                        .foregroundColor(.blue)

                    Gauge(value: Double(viewModel.steps), in: 0...10000) {
                        Text("Progress")
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(.blue)
                    .frame(height: 100)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(16)

                VStack(spacing: 8) {
                    Label("Sleep Hours", systemImage: "bed.double.fill")
                        .font(.headline)
                    Text("\(viewModel.sleepHours, specifier: "%.1f") hours")
                        .font(.largeTitle.bold())
                        .foregroundColor(.green)

                    Gauge(value: viewModel.sleepHours, in: 0...8) {
                        Text("Target: 8")
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(.green)
                    .frame(height: 100)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(16)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Today")
        .animation(.easeInOut, value: viewModel.steps)
        .animation(.easeInOut, value: viewModel.sleepHours)
        .onAppear() {
            viewModel.fetchHealthData()
        }
    }
}
