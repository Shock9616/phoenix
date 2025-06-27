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

    private var selectedGameName: String {
        if let selectedID = viewModel.selectedGameIDs.first,
           let selectedGame = viewModel.games.first(where: { $0.id == selectedID }),
           let name = selectedGame.name
        {
            return name
        }
        return "Phoenix"
    }

    var body: some View {
        NavigationSplitView {
            GameListView(viewModel: viewModel)
        } detail: {
            GameDetailView(viewModel: viewModel)
                .navigationTitle(selectedGameName)
        }
    }
}

#Preview {
    PhoenixRootView(viewModel: GameViewModel())
}
