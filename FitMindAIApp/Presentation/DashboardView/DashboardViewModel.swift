//
//  DashboardViewModel.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation
import HealthKit
import SwiftUI

final class DashboardViewModel: ObservableObject {
    
    @Published var steps: Int = 0
    @Published var sleepHours: Double = 0
    
    @Published var weeklySteps: [DailyStep] = []
    @Published var previousWeekSteps: [DailyStep] = []
    
    @Published var weeklySleepHours: [DailySleep] = []
    @Published var previousWeekSleepHours: [DailySleep] = []
    
    @Published var insightHistory: [AIInsight] = []
    @Published var aiInsight: String = ""

    private let healthRepo: HealthRepositoryProtocol
    private let aiRepo: AIRepository
    private let healthStore = HKHealthStore()

    @AppStorage("stepTarget") var stepTarget: Int = 7000
    @AppStorage("sleepTarget") var sleepTarget: Double = 7.0
    
    
    init(healthRepo: HealthRepositoryProtocol, aiRepo: AIRepository) {
        self.healthRepo = healthRepo
        self.aiRepo = aiRepo
        requestHealthAuthorization()
    }

    func loadWeeklyHealthData() async {
        let currentRange = DateRange.currentWeek()
        let previousRange = DateRange.previousWeek()

        let currentSteps = await healthRepo.fetchStepData(from: currentRange.start, to: currentRange.end)
        let currentSleep = await healthRepo.fetchSleepData(from: currentRange.start, to: currentRange.end)

        let previousSteps = await healthRepo.fetchStepData(from: previousRange.start, to: previousRange.end)
        let previousSleep = await healthRepo.fetchSleepData(from: previousRange.start, to: previousRange.end)

        DispatchQueue.main.async {
            self.weeklySteps = currentSteps
            self.weeklySleepHours = currentSleep
            self.previousWeekSteps = previousSteps
            self.previousWeekSleepHours = previousSleep
        }
    }
    
    func requestHealthAuthorization() {
        healthRepo.requestHealthAuthorization { [weak self] success in
            guard success else { return }
            Task {
                await self?.loadWeeklyHealthData()
            }
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
        if let newInsight = await AIInsightUseCase.generateInsight(steps: steps, sleep: sleepHours, using: aiRepo) {
            DispatchQueue.main.async {
                self.aiInsight = newInsight.insight
                self.insightHistory.append(newInsight)
                InsightStorageService.save(self.insightHistory)
            }
        }
    }

    func updateAIInsight() {
        let avgSteps = weeklySteps.reduce(0.0) { $0 + Double($1.steps) } / Double(weeklySteps.count)
        let avgSleep = weeklySleepHours.reduce(0.0) { $0 + Double($1.hours) } / Double(weeklySleepHours.count)

        let prediction = HealthInsightModel.shared.predict(steps: avgSteps, sleep: avgSleep)

        switch prediction {
        case "Optimal":
            aiInsight = "You’re doing great! Keep maintaining your healthy habits."
        case "Moderate":
            aiInsight = "You’re on the right track. Try increasing your daily activity."
        case "Low":
            aiInsight = "Let’s work on improving your sleep and step count."
        default:
            aiInsight = "Unable to generate insight at the moment."
        }
    }

}
