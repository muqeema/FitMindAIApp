//
//  HealthRepository.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation

final class HealthRepositoryImpl: HealthRepositoryProtocol {
    private let healthKit: HealthKitServiceProtocol
    init(healthKit: HealthKitServiceProtocol) {
        self.healthKit = healthKit
    }

    func getTodaySteps(completion: @escaping (Int) -> Void) {
        healthKit.fetchSteps(completion: completion)
    }

    func getSleepHours(completion: @escaping (Double) -> Void) {
        healthKit.fetchSleepHours(completion: completion)
    }
}
