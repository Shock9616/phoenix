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
/// - viewModel: The view model for communicating with the app's
/// backend
struct MultipleGamesView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        Group {
            Image("GameStackIcon")
                .font(.system(size: 80))

            Text("\(viewModel.selectedGames.count) Games Selected")
                .font(.title)
                .fontWeight(.semibold)

            HStack {
                // Hide games button
                Button(action: {
                    viewModel.hideGames(viewModel.selectedGames)
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
                    viewModel.deleteGames(viewModel.selectedGames)
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
        .foregroundColor(.gray)
    }
}
