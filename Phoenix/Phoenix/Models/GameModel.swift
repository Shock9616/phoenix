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
/// - runningGames: A dictionary of game IDs and process handles for
/// games launched through Phoenix
struct GameModel {
    var games: [Game]
    var selectedGameIDs: Set<UUID>
    var runningGames: [UUID: GameProcessHandle] = [:]

    init() {
        games = loadGames()
        selectedGameIDs = games.count > 0 ? [games[0].id] : []
    }
}
