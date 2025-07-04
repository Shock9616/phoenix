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

    var body: some View {
        List(selection: $selectedIDs) {
            ForEach(viewModel.displaySections) { section in // Sections
                Section(header: Text("\(section.title) (\(section.games.count))")) {
                    ForEach(section.games) { game in // Games in each section
                        GameListItemView(game: game)
                    }
                }
            }
        }
        .onAppear {
            // Ensure games are selected right away
            selectedIDs = viewModel.selectedGameIDs
        }
        .onChange(of: selectedIDs) {
            // Send newly selected games to the view model
            viewModel.selectGames(selectedIDs)
        }
        .searchable(text: $viewModel.searchText, placement: .sidebar, prompt: "Search")
    }
}

#Preview {
    GameListView(viewModel: GameViewModel())
}
