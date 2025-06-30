//
//  AIRepository.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation

final class AIRepositoryImpl: AIRepository {
    private let gptService: GPTServiceProtocol
    init(gptService: GPTServiceProtocol) {
        self.gptService = gptService
    }

    func getHealthInsight(from summary: String) async -> String? {
        await gptService.generateInsight(for: summary)
    }
}
