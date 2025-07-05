//
//  SortMode.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-03.
//

import Foundation

/// An enum containing the various supported methods of sorting games
/// in the game list
enum SortMode: CaseIterable, Identifiable {
    case platform
    case status
    case name
    case recency

    var id: SortMode { self }

    var displayName: String {
        switch self {
            case .platform: return "Platform"
            case .status: return "Status"
            case .name: return "Name"
            case .recency: return "Recency"
        }
    }

    var symbol: String {
        switch self {
            case .platform: return "gamecontroller"
            case .status: return "trophy"
            case .name: return "textformat.abc"
            case .recency: return "clock"
        }
    }
}
