//
//  AIInsight.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 01/07/25.
//

import Foundation

struct AIInsight: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    let summary: String
    let insight: String

    init(id: UUID = UUID(), date: Date = Date(), summary: String, insight: String) {
        self.id = id
        self.date = date
        self.summary = summary
        self.insight = insight
    }
}
