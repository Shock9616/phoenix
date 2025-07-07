//
//  GameModel.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import Foundation

/// The struct containing all data related to a game
struct Game: Identifiable, Equatable {
    let id: UUID
    var steamID: Int?
    var igdbID: Int?
    
    var name: String?
    var platform: Platform
    var status: Status
    var recency: Recency
    var isHidden: Bool
    var isFavorite: Bool
    
    var gameExecutable: URL?
    var launcher: String?
    
    var icon: URL?
    var header: URL?
    var cover: URL?
    var screenshots: [URL]
    
    var description: String?
    var genres: [String]
    var rating: Float?
    var releaseDate: Date?
    var lastPlayed: Date?
    var developers: [String]
    var publishers: [String]
    
    init(
        // Create initializer so that ID can be set manually when
        // updating an existing game
        id: UUID = UUID(),
        steamID: Int? = nil,
        igdbID: Int? = nil,
        
        name: String? = nil,
        platform: Platform = .other,
        status: Status = .none,
        recency: Recency = .never,
        isHidden: Bool = false,
        isFavorite: Bool = false,
        
        gameExecutable: URL? = nil,
        launcher: String? = nil,
        
        icon: URL? = nil,
        header: URL? = nil,
        cover: URL? = nil,
        screenshots: [URL] = [],
        
        description: String? = nil,
        genres: [String] = [],
        rating: Float? = nil,
        releaseDate: Date? = nil,
        lastPlayed: Date? = nil,
        developers: [String] = [],
        publishers: [String] = []
    ) {
        self.id = id
        self.steamID = steamID
        self.igdbID = igdbID
        
        self.name = name
        self.platform = platform
        self.status = status
        self.recency = recency
        self.isHidden = isHidden
        self.isFavorite = isFavorite
        
        self.gameExecutable = gameExecutable
        self.launcher = launcher
        
        self.icon = icon
        self.header = header
        self.cover = cover
        self.screenshots = screenshots
        
        self.description = description
        self.genres = genres
        self.rating = rating
        self.releaseDate = releaseDate
        self.lastPlayed = lastPlayed
        self.developers = developers
        self.publishers = publishers
    }
}
