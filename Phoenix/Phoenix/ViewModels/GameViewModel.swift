//
//  GameViewModel.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI
internal import Combine

/// The view model that communicates between the app's UI and the
/// backend
class GameViewModel: ObservableObject {
    @Published private var gameModel = GameModel()

    var games: [Game] {
        gameModel.games
    }

    var selectedGameIDs: Set<UUID> {
        gameModel.selectedGameIDs
    }

    // MARK: - Intents

    /// Set the gameModel's selectedGameIDs variable to the given set
    ///
    /// - Parameters:
    /// - ids: The set of UUIDs to send to the gameModel
    func selectGame(_ ids: Set<UUID>) {
        gameModel.selectedGameIDs = ids
    }
}
