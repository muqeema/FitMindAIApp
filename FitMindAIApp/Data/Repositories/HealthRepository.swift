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

    func fetchStepData(from startDate: Date, to endDate: Date) async -> [DailyStep] {
        return await healthKit.fetchStepData(from: startDate, to: endDate)
    }

    func fetchSleepData(from startDate: Date, to endDate: Date) async -> [DailySleep] {
        return await healthKit.fetchSleepData(from: startDate, to: endDate)
    }

    func requestHealthAuthorization(completion: @escaping (Bool) -> Void) {
        healthKit.requestAuthorization(completion: completion)
    }
}
