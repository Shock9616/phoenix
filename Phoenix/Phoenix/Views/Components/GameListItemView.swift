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
/// - gameViewModel: The view model for communicating with the app's backend
/// - settingsViewModel: The view model that handles the app's global settings
/// - game: The game whose name and icon should be displayed
struct GameListItemView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    let game: Game
    
    @State private var editedName: String = ""
    @FocusState private var isRenaming: Bool
    
    var body: some View {
        HStack {
            if settingsViewModel.showIcons {
                gameIcon
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            
            if gameViewModel.renamingGameID == game.id {
                // If renaming the game, use a text field
                TextField("", text: $editedName, onCommit: {
                    gameViewModel.commitNameChange(editedName, for: game)
                })
                .textFieldStyle(.plain)
                .focused($isRenaming)
                .onAppear {
                    // Populate the text field with the game's existing name
                    editedName = game.name ?? ""
                    DispatchQueue.main.async {
                        isRenaming = true
                    }
                }
                .onSubmit {
                    // Commit the game's new name
                    gameViewModel.commitNameChange(editedName, for: game)
                }
                .onExitCommand {
                    // Stop editing the game's name
                    gameViewModel.renamingGameID = nil
                }
            } else {
                // If not renaming, just use a regular text object
                Text(game.name ?? "Unnamed")
            }
        }
        .onTapGesture {
            handleSelectionOrRename()
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
    
    /// Retain normal List (multi)selection behavior while also allowing the
    /// user to click on the name of a selected game to rename it
    private func handleSelectionOrRename() {
        let flags = NSEvent.modifierFlags
        let currentID = game.id
        
        // Command-click: toggle individual selection
        if flags.contains(.command) {
            var updated = gameViewModel.selectedGameIDs
            if updated.contains(currentID) {
                updated.remove(currentID)
            } else {
                updated.insert(currentID)
            }
            gameViewModel.selectGames(updated)
            return
        }
        
        // Shift-click: select range
        if flags.contains(.shift),
           let lastID = gameViewModel.lastSelectedGameID,
           let lastIndex = gameViewModel.games.firstIndex(where: { $0.id == lastID }),
           let currentIndex = gameViewModel.games.firstIndex(where: { $0.id == currentID })
        {
            let lower = min(lastIndex, currentIndex)
            let upper = max(lastIndex, currentIndex)
            
            let allGames = gameViewModel.games.filter { !$0.isHidden }
            let rangeIDs = Set(allGames[lower ... upper].map(\.id))
            gameViewModel.selectGames(rangeIDs)
            return
        }
        
        // No modifiers
        if gameViewModel.selectedGameIDs.contains(currentID) {
            gameViewModel.editGameName(game)
        } else {
            gameViewModel.selectGames([currentID])
        }
    }
}
