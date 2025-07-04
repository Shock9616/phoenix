//
//  GameSection.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-03.
//

import Foundation

/// A generic section that displays games in GameListView
struct GameSection: Identifiable {
    var id: String { title }
    let title: String
    let games: [Game]
}
