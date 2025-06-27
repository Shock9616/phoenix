//
//  GameModel.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import Foundation

/// The model that controls all of the game data in Phoenix
///
/// - Parameters:
/// - games: The Array of Game objects representing all the games in
/// the user's library
/// - selectedGameIDs: A set of UUIDs that correspond to the selected
/// games in the GameListView
struct GameModel {
    private(set) var games: [Game]
    var selectedGameIDs: Set<UUID>

    init() {
        games = loadGames()
        selectedGameIDs = [games[0].id]
    }
}

/// Loads games into the app on startup
///
/// - Returns: An array of Game objects representing all the games
/// in the user's library
func loadGames() -> [Game] {
    return [
        Game(name: "Game 1"),
        Game(name: "Game 2", isFavorite: true),
        Game(name: "Game 3"),
        Game(name: "Game 4", isFavorite: true),
        Game(name: "Game 5", isHidden: true)
    ]
}
