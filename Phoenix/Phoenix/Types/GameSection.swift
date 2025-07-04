//
//  GameSection.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-03.
//

import Foundation

struct GameSection: Identifiable {
    var id: String { title }
    let title: String
    let games: [Game]
}
