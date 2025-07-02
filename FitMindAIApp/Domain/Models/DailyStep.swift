//
//  DailyStep.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 30/06/25.
//

import Foundation

struct DailyStep: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}
