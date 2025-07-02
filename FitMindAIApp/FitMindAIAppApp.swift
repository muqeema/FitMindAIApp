//
//  FitMindAIAppApp.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import SwiftUI

@main
struct FitMindAIApp: App {
    let persistenceController = PersistenceController.shared
    let container = DependencyContainer.shared.container

    var body: some Scene {
        WindowGroup {
            DashboardView(
                viewModel: container.resolve(DashboardViewModel.self)!
            )
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
