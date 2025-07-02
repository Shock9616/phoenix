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
