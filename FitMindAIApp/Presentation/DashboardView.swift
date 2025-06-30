//
//  DashboardView.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Steps Today: \(viewModel.steps)")
                Text("Sleep Hours: \(viewModel.sleepHours, specifier: "%.1f")")

                Button("Get AI Insight") {
                    Task {
                        await viewModel.fetchAIInsight()
                    }
                }

                if let insight = viewModel.aiInsight {
                    Text(insight)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("FitMindAI")
        }
    }
}
