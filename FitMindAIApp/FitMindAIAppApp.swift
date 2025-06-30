//
//  FitMindAIAppApp.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import SwiftUI
import Swinject
import Combine
import HealthKit    

@main
struct FitMindAIApp: App {
    let container: Container = {
        let container = Container()

        // Register services
        container.register(HealthKitServiceProtocol.self) { _ in HealthKitService() }
        container.register(GPTServiceProtocol.self) { _ in GPTService() }
        container.register(HealthRepositoryProtocol.self) { r in
            HealthRepositoryImpl(healthKit: r.resolve(HealthKitServiceProtocol.self)!)
        }
        container.register(AIRepository.self) { r in
            AIRepositoryImpl(gptService: r.resolve(GPTServiceProtocol.self)!)
        }

        // ViewModels
        container.register(DashboardViewModel.self) { r in
            DashboardViewModel(
                healthRepo: r.resolve(HealthRepositoryProtocol.self)!,
                aiRepo: r.resolve(AIRepository.self)!
            )
        }

        return container
    }()

    var body: some Scene {
        WindowGroup {
            DashboardView(
                viewModel: container.resolve(DashboardViewModel.self)!
            )
        }
    }
}
