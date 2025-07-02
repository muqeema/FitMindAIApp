//
//  SettingsView.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 02/07/25.
//

import SwiftUI
import HealthKit

struct SettingsView: View {
    @AppStorage("isDailySummaryEnabled") private var isDailySummaryEnabled = true
    @State private var healthAccessGranted = false
    @State private var showHealthKitAlert = false
    @State private var selectedInsightLevel = "Balanced"
    
    private let insightLevels = ["Minimal", "Balanced", "Detailed"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("Daily Summary Notification", isOn: $isDailySummaryEnabled)
                        .onChange(of: isDailySummaryEnabled) { enabled in
                            if enabled {
                                // Placeholder static data, replace with actual fetch
                                NotificationService.scheduleDailyReminders()
                            } else {
                                NotificationService.removeAllNotifications()
                            }
                        }
                }

                Section(header: Text("Health Data")) {
                    HStack {
                        Text("HealthKit Access")
                        Spacer()
                        Image(systemName: healthAccessGranted ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(healthAccessGranted ? .green : .red)
                    }
                    Button("Request HealthKit Access") {
                        HealthKitService.shared.requestAuthorization { success in
                            DispatchQueue.main.async {
                                healthAccessGranted = success
                                if !success {
                                    showHealthKitAlert = true
                                }
                            }
                        }
                    }
                }

                Section(header: Text("AI Insights")) {
                    Picker("Detail Level", selection: $selectedInsightLevel) {
                        ForEach(insightLevels, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("HealthKit Access Denied", isPresented: $showHealthKitAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}
