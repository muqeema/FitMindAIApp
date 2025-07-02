//
//  InMemoryInsightStore.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 01/07/25.
//

final class InMemoryInsightStore: AIInsightStoreProtocol {
    private var insights: [AIInsight] = []

    func fetchInsights() -> [AIInsight] {
        insights
    }

    func save(_ insight: AIInsight) {
        insights.append(insight)
    }

    func delete(_ insight: AIInsight) {
        insights.removeAll { $0.id == insight.id }
    }
}
