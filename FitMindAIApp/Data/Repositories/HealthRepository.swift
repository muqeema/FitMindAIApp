//
//  HealthRepository.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation
import HealthKit

final class HealthRepositoryImpl: HealthRepositoryProtocol {
    private let healthKit: HealthKitServiceProtocol

    init(healthKit: HealthKitServiceProtocol = HealthKitService.shared) {
        self.healthKit = healthKit
    }

    func getTodaySteps(completion: @escaping (Int) -> Void) {
        healthKit.fetchSteps(completion: completion)
    }

    func getSleepHours(completion: @escaping (Double) -> Void) {
        healthKit.fetchSleepHours(completion: completion)
    }

    func fetchWeeklyStepData() async -> [DailyStep] {
        await healthKit.fetchWeeklyStepData()
    }

    func fetchWeeklySleepData() async -> [DailySleep] {
        await healthKit.fetchWeeklySleepData()
    }

    func requestHealthAuthorization(completion: @escaping (Bool) -> Void) {
        healthKit.requestAuthorization(completion: completion)
    }
}
