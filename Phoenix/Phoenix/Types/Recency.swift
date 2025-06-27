//
//  Recency.swift
//  Phoenix
//
//  Created by jxhug on 1/21/24.
//

import Foundation

/// An enum representing how recently a game was played
enum Recency: String, Codable, CaseIterable, Identifiable {
    case day, week, month, three_months, six_months, year, never

    var id: Recency { self }

    var displayName: String {
        switch self {
            case .day: return String(localized: "recency_Today")
            case .week: return String(localized: "recency_ThisWeek")
            case .month: return String(localized: "recency_ThisMonth")
            case .three_months: return String(localized: "recency_Last3Months")
            case .six_months: return String(localized: "recency_Last6Months")
            case .year: return String(localized: "recency_ThisYear")
            case .never: return String(localized: "recency_Never")
        }
    }
}
