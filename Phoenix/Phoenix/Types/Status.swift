//
//  Status.swift
//  Phoenix
//
//  Created by jxhug on 1/21/24.
//

import Foundation

/// An enum representing the status of a game in the user's library
enum Status: Comparable {
    case playing, shelved, occasional, backlog, beaten, completed, abandoned, none

    var id: Status { self }

    var displayName: String {
        switch self {
            case .playing: return "Playing"
            case .shelved: return "Shelved"
            case .occasional: return "Occasional"
            case .backlog: return "Backlog"
            case .beaten: return "Beaten"
            case .completed: return "Completed"
            case .abandoned: return "Abandoned"
            case .none: return "None"
//            case .playing: return String(localized: "status_Playing")
//            case .shelved: return String(localized: "status_Shelved")
//            case .occasional: return String(localized: "status_Occasional")
//            case .backlog: return String(localized: "status_Backlog")
//            case .beaten: return String(localized: "status_Beaten")
//            case .completed: return String(localized: "status_Completed")
//            case .abandoned: return String(localized: "status_Abandoned")
//            case .none: return String(localized: "status_Other")
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        let order: [Status] = [.playing, .shelved, .occasional, .backlog, .beaten, .completed, .abandoned, .none]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
