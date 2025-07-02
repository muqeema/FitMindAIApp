//
//  OnboardingViewModel.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import Foundation
import UserNotifications
import HealthKit

final class OnboardingViewModel: ObservableObject {
    @Published var stepGoal: Int = 8000
    @Published var sleepGoal: Double = 7.0
    @Published var isHealthPermissionGranted: Bool = false
    private let healthStore = HKHealthStore()

    func savePreferences() {
        UserDefaults.standard.set(stepGoal, forKey: "stepGoal")
        UserDefaults.standard.set(sleepGoal, forKey: "sleepGoal")
        NotificationCenter.default.post(name: .onboardingComplete, object: nil)
    }

    func completeOnboarding() {
        print("🔹 Starting onboarding flow")
        requestHealthKitPermission()
    }
    
    private func requestNotificationPermission() {
        print("📡 Requesting Notification permission...")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Notification permission error: \(error)")
                } else {
                    print(granted ? "✅ Notification permission granted" : "❌ Notification permission denied")
                }

                NotificationService.scheduleDailyReminders()
                self?.savePreferences()
            }
        }
    }
    
    func requestHealthKitPermission() {
        if HKHealthStore.isHealthDataAvailable() {
            let healthStore = HKHealthStore()
            
            // What you want to read/write
            let readTypes: Set = [
                HKObjectType.quantityType(forIdentifier: .stepCount)!
            ]
            
            let shareTypes: Set = [
                HKObjectType.quantityType(forIdentifier: .stepCount)!
            ]
            
            healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, error in
                self.requestNotificationPermission()
                if let error = error {
                    print("❌ HealthKit error: \(error.localizedDescription)")
                } else {
                    print("✅ HealthKit authorized: \(success)")
                }
            }
        }
    }
}


extension Notification.Name {
    static let onboardingComplete = Notification.Name("onboardingComplete")
}
