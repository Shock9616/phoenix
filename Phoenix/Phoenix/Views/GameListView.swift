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
            let favoriteGames = viewModel.games.filter {
                !$0.isHidden && $0.isFavorite
            }
            if !favoriteGames.isEmpty {
                Section(header: Text("Favorites")) {
                    ForEach(favoriteGames, id: \.id) { game in
                        GameListItemView(game: game)
                    }
                }
            }

            // Other games below
            #warning("TODO: Implement categorization")
            let otherGames = viewModel.games.filter {
                !$0.isHidden && !$0.isFavorite
            }
            if !otherGames.isEmpty {
                Section(header: Text("Other Games")) {
                    ForEach(otherGames, id: \.id) { game in
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
            viewModel.selectGame(selectedIDs)
        }
    }
}

/// The view for a list item in the sidebar which shows a game's name
/// and icon
///
/// - Parameters:
/// - game: The game whose name and icon should be displayed
struct GameListItemView: View {
    let game: Game

    var body: some View {
        HStack {
            gameIcon
                .resizable()
                .frame(width: 20, height: 20)

            if let name = game.name {
                Text(name)
            } else {
                Text("Unnamed")
            }
        }
    }

    var gameIcon: Image {
        if let icon = game.icon, let iconData = loadImage(filePath: icon) {
            Image(nsImage: iconData)
        } else {
            // Use the placeholder icon if there is a problem
            Image("PlaceholderIcon")
        }
    }
}

#Preview {
    GameListView(viewModel: GameViewModel())
}
