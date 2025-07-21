//
//  GameContextMenuView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-07.
//

import SwiftUI

struct GameContextMenuView: View {
    let game: Game
    let viewModel: GameViewModel
    let onEditName: () -> Void
    @State private var formViewModel: GameFormViewModel?

    var body: some View {
        // Favorite game(s) button
        Button(action: {
            viewModel.toggleGamesFavorite(viewModel.selectedGames)
        }, label: {
            if #available(macOS 26.0, *) {
                Image(systemName: game.isFavorite ? "star.slash" : "star")
            }
            Text(game.isFavorite ? "Unfavorite" : "Favorite")
        })

        // Hide game(s) button
        Button(action: {
            viewModel.hideGames(viewModel.selectedGames)
        }, label: {
            if #available(macOS 26.0, *) {
                Image(systemName: "eye.slash")
            }
            Text("Hide")
        })

        // Delete game(s) button
        Button(action: {
            viewModel.deleteGames(viewModel.selectedGames)
        }, label: {
            if #available(macOS 26.0, *) {
                Image(systemName: "trash")
            }
            Text("Delete")
        })

        if viewModel.selectedGames.count == 1 {
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
                viewModel.promptForNewIcon(for: game)
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
                    viewModel.editGamesPlatform(viewModel.selectedGames, platform)
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
                    viewModel.editGamesStatus(viewModel.selectedGames, status)
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
