//
//  Status.swift
//  Phoenix
//
//  Created by jxhug on 1/21/24.
//

import Foundation

/// An enum representing the status of a game in the user's library
enum Status: Comparable, Identifiable, CaseIterable {
    case playing, shelved, occasional, backlog, beaten, completed, abandoned, none

    init(fromDisplayName name: String) {
        switch name {
            case Status.playing.displayName: self = .playing
            case Status.shelved.displayName: self = .shelved
            case Status.occasional.displayName: self = .occasional
            case Status.backlog.displayName: self = .backlog
            case Status.beaten.displayName: self = .beaten
            case Status.completed.displayName: self = .completed
            case Status.abandoned.displayName: self = .abandoned
            default: self = .none
        }
    }

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
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        let order: [Status] = [.playing, .shelved, .occasional, .backlog, .beaten, .completed, .abandoned, .none]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
