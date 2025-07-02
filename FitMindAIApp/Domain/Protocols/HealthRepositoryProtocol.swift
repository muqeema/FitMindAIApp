//
//  HealthRepository.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation

protocol HealthRepositoryProtocol {
    func getTodaySteps(completion: @escaping (Int) -> Void)
    func getSleepHours(completion: @escaping (Double) -> Void)
    func fetchStepData(from startDate: Date, to endDate: Date) async -> [DailyStep]
    func fetchSleepData(from startDate: Date, to endDate: Date) async -> [DailySleep]
    func requestHealthAuthorization(completion: @escaping (Bool) -> Void)
}
