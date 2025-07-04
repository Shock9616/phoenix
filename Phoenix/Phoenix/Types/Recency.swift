//
//  Recency.swift
//  Phoenix
//
//  Created by jxhug on 1/21/24.
//

import Foundation

/// An enum representing how recently a game was played
enum Recency: Comparable {
    case day, week, month, three_months, six_months, year, never

    var id: Recency { self }

    var displayName: String {
        switch self {
            case .day: return "Today"
            case .week: return "This Week"
            case .month: return "This Month"
            case .three_months: return "Last 3 Months"
            case .six_months: return "Last 6 Months"
            case .year: return "This Year"
            case .never: return "Never"
//            case .day: return String(localized: "recency_Today")
//            case .week: return String(localized: "recency_ThisWeek")
//            case .month: return String(localized: "recency_ThisMonth")
//            case .three_months: return String(localized: "recency_Last3Months")
//            case .six_months: return String(localized: "recency_Last6Months")
//            case .year: return String(localized: "recency_ThisYear")
//            case .never: return String(localized: "recency_Never")
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        let order: [Recency] = [.day, .week, .month, .three_months, .six_months, .year, .never]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
