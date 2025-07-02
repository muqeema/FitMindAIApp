//
//  OnboardingView.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    var onFinish: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Welcome to FitMindAI")
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Step Goal:")
                    Stepper("\(viewModel.stepGoal) steps", value: $viewModel.stepGoal, in: 1000...20000, step: 500)

                    Text("Sleep Goal:")
                    Stepper("\(viewModel.sleepGoal, specifier: "%.1f") hrs", value: $viewModel.sleepGoal, in: 4...12, step: 0.5)
                }
                .padding()

                Button("Allow Health Access") {
                    viewModel.completeOnboarding()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)

                Spacer()
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.requestHealthKitPermission()
                }
                
            }
            .padding()
            .onReceive(NotificationCenter.default.publisher(for: .onboardingComplete)) { _ in
//                isOnboarded = true
                UserDefaults.standard.set(true, forKey: "isOnboarded")
            }
        }
    }
}
