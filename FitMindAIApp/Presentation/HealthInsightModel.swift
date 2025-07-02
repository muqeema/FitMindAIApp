//
//  HealthInsightModel.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 02/07/25.
//

import CoreML

final class HealthInsightModel {
    static let shared = HealthInsightModel()

    private let model: HealthInsight

    private init() {
        do {
            self.model = try HealthInsight(configuration: MLModelConfiguration())
        } catch {
            fatalError("Failed to load CoreML model: \(error)")
        }
    }

    func predict(steps: Double, sleep: Double) -> String {
        do {
            let input = HealthInsightInput(average_steps: Int64(steps), average_sleep_hours: sleep)
            let output = try model.prediction(input: input)
            return output.label
        } catch {
            print("Prediction error: \(error)")
            return "Unknown"
        }
    }
}
