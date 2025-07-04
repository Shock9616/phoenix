//
//  GameModel.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import Foundation

/// The struct containing all data related to a game
struct Game: Identifiable {
    // IDs
    let id: UUID = .init()
    var steamID: Int?
    var igdbID: Int?
    
    // Sorting
    var name: String?
    var platform: Platform = .other
    var status: Status = .none
    var recency: Recency = .never
    var isHidden: Bool = false
    var isFavorite: Bool = false
    
    // Launcher functionality
    var gameExecutable: URL?
    var launcher: String?
    var process: Process?
    
    // Images
    var icon: URL?
    var header: URL?
    var cover: URL?
    var screenshots: [URL] = []
    
    // Other metadata
    var description: String?
    var genres: [String] = []
    var rating: Float?
    var releaseDate: Date?
    var lastPlayed: Date?
    var developers: [String] = []
    var publishers: [String] = []
}
