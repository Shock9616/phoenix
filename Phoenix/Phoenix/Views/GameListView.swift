//
//  GameListView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI

/// The sidebar view showing all the user's games
///
/// Shows a complete list of the games, as well as sorting options
/// and a search box
///
/// - Parameters:
/// - gameViewModel: The view model for communicating with the app's backend
/// - settingsViewModel: The view model that handles the app's global settings
struct GameListView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    @State private var selectedIDs: Set<UUID> = []

    /// The actual list object
    var body: some View {
        List(selection: $selectedIDs) {
            GameSectionsView
        }
        .onAppear {
            // Ensure games are selected right away
            selectedIDs = gameViewModel.selectedGameIDs
        }
        .onChange(of: selectedIDs) {
            // Send newly selected games to the view model
            gameViewModel.selectGames(selectedIDs)
        }
        .onChange(of: gameViewModel.selectedGameIDs) {
            // Update selected games when view model updates
            selectedIDs = gameViewModel.selectedGameIDs
        }
        .searchable(text: $gameViewModel.searchText, placement: .sidebar, prompt: "Search")
    }

    /// The different computed sections to populate the list
    private var GameSectionsView: some View {
        ForEach(gameViewModel.displaySections) { section in // Sections
            Section(header: settingsViewModel.showGameCount
                    ? Text("\(section.title) (\(section.games.count))")
                    : Text(section.title)) {
                ForEach(section.games) { game in // Games in each section
                    GameRowView(game: game)
                }
            }
        }
    }

    /// The displayed contents for each game
    private func GameRowView(game: Game) -> some View {
        GameListItemView(gameViewModel: gameViewModel, settingsViewModel: settingsViewModel, game: game)
            .contextMenu {
                GameContextMenuView(
                    game: game,
                    gameViewModel: gameViewModel,
                    onEditName: {
                        gameViewModel.editGameName(game)
                    }
                )
            }
    }
}
