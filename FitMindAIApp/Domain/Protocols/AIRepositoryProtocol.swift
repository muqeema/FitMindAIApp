//
//  AIRepository.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 28/06/25.
//

import Foundation

protocol AIRepository {
    func getHealthInsight(from summary: String) async -> String?
}
