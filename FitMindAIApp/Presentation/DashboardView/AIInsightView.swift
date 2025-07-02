//
//  AIInsightView.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import SwiftUI

struct AIInsightView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("AI Insights")
                .font(.title2)
                .bold()

            Button("Get AI Insight") {
                Task {
                    await viewModel.fetchAIInsight()
                }
            }
            Button("Update Insight") {
                Task {
                    viewModel.updateAIInsight()
                }
            }
            Text(viewModel.aiInsight)
                           .padding()
                           .font(.title3)
                           .multilineTextAlignment(.center)
                           .frame(maxWidth: .infinity)
                           .background(Color.green.opacity(0.1))
                           .cornerRadius(16)
                           .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
