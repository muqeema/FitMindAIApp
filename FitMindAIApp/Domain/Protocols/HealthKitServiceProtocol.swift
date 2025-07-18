//
//  HealthKitServiceProtocol.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation

protocol HealthKitServiceProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchSteps(completion: @escaping (Int) -> Void)
    func fetchSleepHours(completion: @escaping (Double) -> Void)
    func fetchStepData(from startDate: Date, to endDate: Date) async -> [DailyStep]
    func fetchSleepData(from startDate: Date, to endDate: Date) async -> [DailySleep]
}
