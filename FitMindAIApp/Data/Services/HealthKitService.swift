//
//  HealthKitService.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation
import HealthKit

final class HealthKitService: HealthKitServiceProtocol {

    static let shared = HealthKitService()
    private let healthStore = HKHealthStore()
    
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        print("📣 Requesting HealthKit authorization") // ✅ Debug log
        guard HKHealthStore.isHealthDataAvailable() else {
            print("🚫 Health data not available")
            completion(false)
            return
        }
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            print("🚫 Invalid types")
            completion(false)
            return
        }
        
        let typesToRead: Set = [stepType, sleepType]
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            print("🧪 HealthKit authorization callback fired: \(success), error: \(String(describing: error))")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let stepStatus = self.healthStore.authorizationStatus(for: stepType)
                let sleepStatus = self.healthStore.authorizationStatus(for: sleepType)
                print("🔍 Step status: \(stepStatus.rawValue), Sleep status: \(sleepStatus.rawValue)")
                
                let granted = stepStatus == .sharingAuthorized && sleepStatus == .sharingAuthorized
                completion(granted)
            }
        }
    }


    func fetchSteps(completion: @escaping (Int) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(0)
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            completion(Int(steps))
        }

        healthStore.execute(query)
    }
    
    func fetchSleepHours(completion: @escaping (Double) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(0)
            return
        }

        let startOfDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            let sleepSamples = samples as? [HKCategorySample] ?? []

            let totalSleep = sleepSamples.reduce(0) {
                $0 + ($1.value == HKCategoryValueSleepAnalysis.asleep.rawValue
                      ? $1.endDate.timeIntervalSince($1.startDate)
                      : 0)
            }

            completion(totalSleep / 3600.0) // Convert to hours
        }

        healthStore.execute(query)
    }

    // MARK: - Weekly Data

        func fetchWeeklyStepData() async -> [DailyStep] {
            await withCheckedContinuation { continuation in
                var results: [DailyStep] = []
                guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
                    continuation.resume(returning: [])
                    return
                }

                let calendar = Calendar.current
                let now = Date()
                guard let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) else {
                    continuation.resume(returning: [])
                    return
                }

                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now)
                let interval = DateComponents(day: 1)

                let query = HKStatisticsCollectionQuery(
                    quantityType: stepType,
                    quantitySamplePredicate: predicate,
                    options: .cumulativeSum,
                    anchorDate: startDate,
                    intervalComponents: interval
                )

                query.initialResultsHandler = { _, stats, _ in
                    stats?.enumerateStatistics(from: startDate, to: now) { stat, _ in
                        let steps = stat.sumQuantity()?.doubleValue(for: .count()) ?? 0
                        results.append(DailyStep(date: stat.startDate, steps: Int(steps)))
                    }
                    continuation.resume(returning: results)
                }

                healthStore.execute(query)
            }
        }

    func fetchWeeklySleepData() async -> [DailySleep] {
        await withCheckedContinuation { continuation in
            var results: [DailySleep] = []
            guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
                continuation.resume(returning: [])
                return
            }

            let calendar = Calendar.current
            let now = Date()
            guard let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)),
                  let endOfToday = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now) else {
                continuation.resume(returning: [])
                return
            }

            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endOfToday)

            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                let sleepSamples = samples as? [HKCategorySample] ?? []

                var grouped: [Date: TimeInterval] = [:]

                for sample in sleepSamples where sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                    let day = calendar.startOfDay(for: sample.endDate) // <-- optionally use endDate
                    grouped[day, default: 0] += sample.endDate.timeIntervalSince(sample.startDate)
                }

                for (date, duration) in grouped {
                    results.append(DailySleep(date: date, hours: duration / 3600))
                }

                continuation.resume(returning: results.sorted { $0.date < $1.date })
            }

            healthStore.execute(query)
        }
    }

    
}
