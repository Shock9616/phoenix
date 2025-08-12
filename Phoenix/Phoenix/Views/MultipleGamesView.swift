//
//  MultipleGamesView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

/// A simple view to show when multiple games are selected
///
/// Shows the number of selected games, and some controls for hiding
/// and deleting those games
///
/// - Parameters:
/// - gameViewModel: The view model for communicating with the app's
/// backend
struct MultipleGamesView: View {
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        Group {
            Image("GameStackIcon")
                .font(.system(size: 80))

            Text("\(gameViewModel.selectedGames.count) Games Selected")
                .font(.title)
                .fontWeight(.semibold)

            HStack {
                // Hide games button
                Button(action: {
                    gameViewModel.toggleGamesHidden(gameViewModel.selectedGames)
                }, label: {
                    Text("Hide Games")
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                )

                // Delete games button
                Button(action: {
                    gameViewModel.deleteGames(gameViewModel.selectedGames)
                }, label: {
                    Text("Delete Games")
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .foregroundColor(.secondary)
    }
}
