//
//  DashboardViewModel.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation
import HealthKit

final class DashboardViewModel: ObservableObject {
    @Published var steps: Int = 0
    @Published var sleepHours: Double = 0
    @Published var weeklySteps: [DailyStep] = []
    @Published var weeklySleepHours: [DailySleep] = []
    @Published var insightHistory: [AIInsight] = []
    @Published var isOnboarded: Bool = false
    @Published var aiInsight: String = ""

    private let healthRepo: HealthRepositoryProtocol
    private let aiRepo: AIRepository
    private let healthStore = HKHealthStore()

    init(healthRepo: HealthRepositoryProtocol, aiRepo: AIRepository) {
        self.healthRepo = healthRepo
        self.aiRepo = aiRepo
        requestHealthAuthorization()
        isHealthKitPermissionGranted()
    }

    func loadWeeklyHealthData() async {
        let steps = await healthRepo.fetchWeeklyStepData()
            let sleep = await healthRepo.fetchWeeklySleepData()

            DispatchQueue.main.async {
                self.weeklySteps = steps
                self.weeklySleepHours = sleep
            }
    }
    
    func requestHealthAuthorization() {
        healthRepo.requestHealthAuthorization { [weak self] success in
            guard success else { return }
            self?.fetchHealthData()
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
        let summary = "User walked \(steps) steps and slept \(sleepHours) hours."
        if let insight = await aiRepo.getHealthInsight(from: summary) {
            let newInsight = AIInsight(date: Date(), summary: summary, insight: insight)
            DispatchQueue.main.async {
                self.aiInsight = insight
                self.insightHistory.append(newInsight)
                self.saveInsightsToStorage()
            }
        }
    }


    private let insightsKey = "aiInsightHistory"

    func loadInsightsFromStorage() {
        if let data = UserDefaults.standard.data(forKey: insightsKey) {
            do {
                let decoded = try JSONDecoder().decode([AIInsight].self, from: data)
                insightHistory = decoded
            } catch {
                print("Failed to decode insight history:", error)
            }
        }
    }

    func saveInsightsToStorage() {
        do {
            let data = try JSONEncoder().encode(insightHistory)
            UserDefaults.standard.set(data, forKey: insightsKey)
        } catch {
            print("Failed to save insight history:", error)
        }
    }
    
    func clearInsightHistory() {
        insightHistory.removeAll()
        UserDefaults.standard.removeObject(forKey: insightsKey)
    }

    
    func isHealthKitPermissionGranted() {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
              let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return
        }

        let stepStatus = healthStore.authorizationStatus(for: stepType)
        let sleepStatus = healthStore.authorizationStatus(for: sleepType)

        isOnboarded =  stepStatus == .sharingAuthorized && sleepStatus == .sharingAuthorized
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
