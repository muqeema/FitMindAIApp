import Foundation

struct DashboardAnalytics {
    static func computeWeeklyComparison(currentSteps: [DailyStep], previousSteps: [DailyStep],
                                        currentSleep: [DailySleep], previousSleep: [DailySleep]) -> (stepsDelta: Int, sleepDelta: Double) {
        let currentStepTotal = currentSteps.reduce(0) { $0 + $1.steps }
        let previousStepTotal = previousSteps.reduce(0) { $0 + $1.steps }

        let currentSleepTotal = currentSleep.reduce(0.0) { $0 + $1.hours }
        let previousSleepTotal = previousSleep.reduce(0.0) { $0 + $1.hours }

        return (currentStepTotal - previousStepTotal, currentSleepTotal - previousSleepTotal)
    }

    static func trendSummary(steps: [DailyStep], sleep: [DailySleep], stepTarget: Int, sleepTarget: Double) -> String {
        let belowStepDays = steps.filter { $0.steps < stepTarget }.count
        let belowSleepDays = sleep.filter { $0.hours < sleepTarget }.count

        return """
            Steps below target on \(belowStepDays)/7 daysSleep below target on \(belowSleepDays)/7 days
        """
    }

    static func computeWellnessScore(steps: [DailyStep], sleep: [DailySleep], stepTarget: Int, sleepTarget: Double) -> Int {
        let totalSteps = steps.reduce(0) { $0 + $1.steps }
        let totalSleep = sleep.reduce(0.0) { $0 + $1.hours }

        let stepPercent = min(Double(totalSteps) / Double(stepTarget * 7), 1.0)
        let sleepPercent = min(totalSleep / (sleepTarget * 7), 1.0)

        let score = (stepPercent * 0.6 + sleepPercent * 0.4) * 100
        return Int(score.rounded())
    }
}
