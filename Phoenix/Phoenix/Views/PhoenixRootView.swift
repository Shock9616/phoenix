//
//  ContentView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI

/// The root view of the app
///
/// - Parameters:
/// - viewModel: The view model for communicating with the app's
/// backend
struct PhoenixRootView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        NavigationSplitView {
            GameListView(viewModel: viewModel)
                .toolbar { ToolbarView(viewModel: viewModel) }
                .frame(minWidth: 180)
        } detail: {
            if viewModel.selectedGameIDs.count == 1 {
                // If one game is selected
                GameDetailView(viewModel: viewModel)
            } else if viewModel.selectedGameIDs.count > 1 {
                // If multiple games are selected
                MultipleGamesView(viewModel: viewModel)
            }
        }
        .navigationTitle(selectedGameName)
    }

    /// Get the name of the selected game, or return default names
    /// for when multiple/no games are selected
    private var selectedGameName: String {
        if viewModel.selectedGameIDs.count > 1 {
            // If multiple games are selected
            return "Games"
        } else if let selectedID = viewModel.selectedGameIDs.first,
                  let selectedGame = viewModel.games.first(where: { $0.id == selectedID }),
                  let name = selectedGame.name
        {
            // If one game is selected
            return name
        }

        // If no games are selected
        return "Phoenix"
    }
}

#Preview {
    PhoenixRootView(viewModel: GameViewModel())
        .frame(width: 800, height: 600)
}
