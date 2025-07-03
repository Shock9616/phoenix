//
//  GameListItemView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

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

            Text(game.name ?? "Unnamed")
        }
    }

    var gameIcon: Image {
        if let iconPath = game.icon, let icon = loadImage(filePath: iconPath) {
            Image(nsImage: icon)
        } else {
            // Use the placeholder icon if there is a problem
            Image("PlaceholderIcon")
        }
    }
}
