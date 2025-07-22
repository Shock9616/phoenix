//
//  GameContextMenuView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-07.
//

import SwiftUI

/// The view for the context menu shown when right-clicking a game in the game
/// list
///
/// - Parameters:
/// - game: The game to be operated on
/// - gameViewModel: The view model for communicating with the app's backend
/// - onEditName: A closure to be executed when the user edits the selected
/// game's name
struct GameContextMenuView: View {
    let game: Game
    let gameViewModel: GameViewModel
    let onEditName: () -> Void
    @State private var formViewModel: GameFormViewModel?

    var body: some View {
        // Favorite game(s) button
        Button(action: {
            gameViewModel.toggleGamesFavorite(gameViewModel.selectedGames)
        }, label: {
            if #available(macOS 26.0, *) {
                Image(systemName: game.isFavorite ? "star.slash" : "star")
            }
            Text(game.isFavorite ? "Unfavorite" : "Favorite")
        })

        // Hide game(s) button
        Button(action: {
            gameViewModel.hideGames(gameViewModel.selectedGames)
        }, label: {
            if #available(macOS 26.0, *) {
                Image(systemName: "eye.slash")
            }
            Text("Hide")
        })

        // Delete game(s) button
        Button(action: {
            gameViewModel.deleteGames(gameViewModel.selectedGames)
        }, label: {
            if #available(macOS 26.0, *) {
                Image(systemName: "trash")
            }
            Text("Delete")
        })

        if gameViewModel.selectedGames.count == 1 {
            // Rename and change icon only available for single selection
            Divider()

            // Rename button
            Button(action: onEditName) {
                if #available(macOS 26.0, *) {
                    Image(systemName: "pencil")
                }
                Text("Rename")
            }

            // Change icon button
            Button(action: {
                gameViewModel.promptForNewIcon(for: game)
            }, label: {
                if #available(macOS 26.0, *) {
                    Image(systemName: "square.dashed")
                }
                Text("Change icon")
            })
        }

        Divider()

        // Change platform menu
        Menu(content: {
            ForEach(Platform.allCases) { platform in
                Button(action: {
                    gameViewModel.editGamesPlatform(gameViewModel.selectedGames, platform)
                }, label: {
                    Text(platform.displayName)
                })
            }
        }, label: {
            if #available(macOS 26.0, *) {
                Image(systemName: "gamecontroller")
            }
            Text("Change platform")
        })

        // Change status menu
        Menu(content: {
            ForEach(Status.allCases) { status in
                Button(action: {
                    gameViewModel.editGamesStatus(gameViewModel.selectedGames, status)
                }, label: {
                    Text(status.displayName)
                })
            }
        }, label: {
            if #available(macOS 26.0, *) {
                Image(systemName: "trophy")
            }
            Text("Change status")
        })
    }
}
