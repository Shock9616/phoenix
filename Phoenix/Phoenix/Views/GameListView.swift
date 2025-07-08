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
/// - viewModel: The view model for communicating with the app's
/// backend
/// - selectedIDs: The currently selected games
struct GameListView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var selectedIDs: Set<UUID> = []

    /// The actual list object
    var body: some View {
        List(selection: $selectedIDs) {
            GameSectionsView
        }
        .onAppear {
            // Ensure games are selected right away
            selectedIDs = viewModel.selectedGameIDs
        }
        .onChange(of: selectedIDs) {
            // Send newly selected games to the view model
            viewModel.selectGames(selectedIDs)
        }
        .onChange(of: viewModel.selectedGameIDs) {
            // Update selected games when view model updates
            selectedIDs = viewModel.selectedGameIDs
        }
        .searchable(text: $viewModel.searchText, placement: .sidebar, prompt: "Search")
    }

    /// The different computed sections to populate the list
    private var GameSectionsView: some View {
        ForEach(viewModel.displaySections) { section in // Sections
            Section(header: Text("\(section.title) (\(section.games.count))")) {
                ForEach(section.games) { game in // Games in each section
                    GameRowView(game: game)
                }
            }
        }
    }

    /// The displayed contents for each game
    private func GameRowView(game: Game) -> some View {
        GameListItemView(viewModel: viewModel, game: game)
            .contextMenu {
                GameContextMenuView(
                    game: game,
                    viewModel: viewModel,
                    onEditName: {
                        viewModel.editGameName(game)
                    }
                )
            }
    }
}
