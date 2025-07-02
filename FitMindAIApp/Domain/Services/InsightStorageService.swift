import Foundation

struct InsightStorageService {
    private static let key = "aiInsightHistory"

    static func load() -> [AIInsight] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([AIInsight].self, from: data)) ?? []
    }

    static func save(_ insights: [AIInsight]) {
        if let data = try? JSONEncoder().encode(insights) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}