//
//  DateUtils.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 02/07/25.
//

import Foundation

struct DateRange {
    let start: Date
    let end: Date

    static func currentWeek(from reference: Date = Date()) -> DateRange {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: reference))!
        let end = reference // right now (or end of today if you prefer strict bounds)
        return DateRange(start: start, end: end)
    }

    static func previousWeek(from reference: Date = Date()) -> DateRange {
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: reference))!
        let start = calendar.date(byAdding: .day, value: -7, to: end)!
        return DateRange(start: start, end: end)
    }
}
