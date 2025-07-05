//
//  GameListItemView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

/// The view for a list item in the sidebar
///
/// Shows the game's icon followed by the game's name
///
/// - Parameters:
/// - game: The game whose name and icon should be displayed
struct GameListItemView: View {
    let game: Game

    var body: some View {
        HStack {
            gameIcon
                .resizable()
                .frame(width: 25, height: 25)

            Text(game.name ?? "Unnamed")
        }
    }

    /// Get the icon image, or return a placeholder icon in the event
    /// of a missing icon or an error
    var gameIcon: Image {
        if let iconPath = game.icon, let icon = loadImage(filePath: iconPath) {
            Image(nsImage: icon)
        } else {
            // Use the placeholder icon if there is a problem
            Image("PlaceholderIcon")
        }
    }
}
