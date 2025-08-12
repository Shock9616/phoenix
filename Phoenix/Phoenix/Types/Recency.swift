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

    init(fromDisplayName name: String) {
        switch name {
            case Recency.day.displayName: self = .day
            case Recency.week.displayName: self = .week
            case Recency.month.displayName: self = .month
            case Recency.three_months.displayName: self = .three_months
            case Recency.six_months.displayName: self = .six_months
            case Recency.year.displayName: self = .year
            default: self = .never
        }
    }

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
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        let order: [Recency] = [.day, .week, .month, .three_months, .six_months, .year, .never]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
