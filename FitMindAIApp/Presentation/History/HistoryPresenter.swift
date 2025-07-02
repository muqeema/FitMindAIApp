//
//  HistoryPresenter.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 01/07/25.
//

import Foundation
import Combine

final class HistoryPresenter: ObservableObject {
    @Published private(set) var insights: [AIInsight] = []

    private let store: AIInsightStoreProtocol

    init(store: AIInsightStoreProtocol) {
        self.store = store
    }

    func loadInsights() {
        insights = store.fetchInsights().sorted { $0.date > $1.date }
    }

    func delete(_ insight: AIInsight) {
        store.delete(insight)
        loadInsights()
    }
}
