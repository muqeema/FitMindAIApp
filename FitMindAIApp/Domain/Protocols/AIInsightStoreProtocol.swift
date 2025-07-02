//
//  AIInsightStoreProtocol.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 01/07/25.
//

protocol AIInsightStoreProtocol {
    func fetchInsights() -> [AIInsight]
    func save(_ insight: AIInsight)
    func delete(_ insight: AIInsight)
}
