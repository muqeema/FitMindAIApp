//
//  DashboardViewModel.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation

final class DashboardViewModel: ObservableObject {
    @Published var steps: Int = 0
    @Published var sleepHours: Double = 0
    @Published var aiInsight: String?

    private let healthRepo: HealthRepositoryProtocol
    private let aiRepo: AIRepository

    init(healthRepo: HealthRepositoryProtocol, aiRepo: AIRepository) {
        self.healthRepo = healthRepo
        self.aiRepo = aiRepo
        requestHealthAuthorization()
    }

    func requestHealthAuthorization() {
        HealthKitService.shared.requestAuthorization { [weak self] success in
            guard success else { return }
            self?.fetchHealthData()
        }
    }

    func fetchHealthData() {
        healthRepo.getTodaySteps { steps in
            DispatchQueue.main.async {
                self.steps = steps
            }
        }

        healthRepo.getSleepHours { sleepHours in
            DispatchQueue.main.async {
                self.sleepHours = sleepHours
            }
        }
    }

    func fetchAIInsight() async {
        let summary = "User walked \(steps) steps and slept \(sleepHours) hours."
        if let insight = await aiRepo.getHealthInsight(from: summary) {
            DispatchQueue.main.async {
                self.aiInsight = insight
            }
        }
    }
}
