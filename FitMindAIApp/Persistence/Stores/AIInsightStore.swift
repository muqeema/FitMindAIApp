//
//  AIInsightStore.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 01/07/25.
//

import CoreData

final class AIInsightStore {
    static let shared = AIInsightStore()
    private let context = PersistenceController.shared.container.viewContext

    func save(summary: String, insight: String) {
        let entity = AIInsightEntity(context: context)
        entity.id = UUID()
        entity.date = Date()
        entity.summary = summary
        entity.insight = insight

        try? context.save()
    }

    func fetchHistory() -> [AIInsightEntity] {
        let request = AIInsightEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AIInsightEntity.date, ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
}
