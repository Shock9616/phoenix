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
/// - gameViewModel: The view model for communicating with the app's backend
/// - settingsViewModel: The view model that handles the app's global settings
struct PhoenixRootView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var sheetCoordinator: SheetCoordinator

    var body: some View {
        NavigationSplitView {
            GameListView(gameViewModel: gameViewModel, settingsViewModel: settingsViewModel)
                .toolbar { ToolbarView(gameViewModel: gameViewModel) }
                .frame(minWidth: 190)
        } detail: {
            if gameViewModel.selectedGames.count == 1 {
                // If one game is selected
                GameDetailView(gameViewModel: gameViewModel, settingsViewModel: settingsViewModel)
            } else if gameViewModel.selectedGames.count > 1 {
                // If multiple games are selected
                MultipleGamesView(gameViewModel: gameViewModel)
            }
        }
        .navigationTitle(selectedGameName)
        .sheet(item: $sheetCoordinator.formViewModel) { vm in
            GameFormView(gameFormViewModel: vm)
                .frame(width: 800)
                .padding()
        }
    }

    /// Get the name of the selected game, or return default names
    /// for when multiple/no games are selected
    private var selectedGameName: String {
        if gameViewModel.selectedGames.count > 1 {
            // If multiple games are selected
            return "Games"
        } else if let selectedGame = gameViewModel.selectedGame,
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
    PhoenixRootView(gameViewModel: GameViewModel(), settingsViewModel: SettingsViewModel())
        .frame(width: 800, height: 600)
}
