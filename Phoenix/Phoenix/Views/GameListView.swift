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
            // Favorite games at the top
            if !viewModel.favoriteGames.isEmpty {
                Section(header: Text("Favorites")) {
                    ForEach(viewModel.favoriteGames, id: \.id) { game in
                        GameListItemView(game: game)
                    }
                }
            }

            // Other games below
            if !viewModel.otherGames.isEmpty {
                Section(header: Text("Other Games")) {
                    ForEach(viewModel.otherGames, id: \.id) { game in
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
    }
}

#Preview {
    GameListView(viewModel: GameViewModel())
}
