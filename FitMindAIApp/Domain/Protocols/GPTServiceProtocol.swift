//
//  GPTServiceProtocol.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation

protocol GPTServiceProtocol {
    func generateInsight(for prompt: String) async -> String?
}
