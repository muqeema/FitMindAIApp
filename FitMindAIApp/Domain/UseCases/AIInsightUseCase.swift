import Foundation

struct AIInsightUseCase {
    static func generateInsight(steps: Int, sleep: Double, using repo: AIRepository) async -> AIInsight? {
        let summary = "User walked \(steps) steps and slept \(sleep) hours."
        guard let insight = await repo.getHealthInsight(from: summary) else { return nil }
        return AIInsight(date: Date(), summary: summary, insight: insight)
    }

    static func predictWithModel(steps: [DailyStep], sleep: [DailySleep]) -> String {
        let avgSteps = steps.map { Double($0.steps) }.reduce(0.0, +) / Double(steps.count)
        let avgSleep = sleep.map { $0.hours }.reduce(0.0, +) / Double(sleep.count)
        return HealthInsightModel.shared.predict(steps: avgSteps, sleep: avgSleep)
    }
}