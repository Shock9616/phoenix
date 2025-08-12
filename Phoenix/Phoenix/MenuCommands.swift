//
//  MenuCommands.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-21.
//

import SwiftUI

/// All the custom menu bar commands for Phoenix
///
/// - Parameters:
/// - gameViewModel: The view model for communicating with the app's backend
struct MenuCommands: Commands {
    @ObservedObject var gameViewModel: GameViewModel
    @EnvironmentObject var sheetCoordinator: SheetCoordinator
    
    var body: some Commands {
        // ========== File Menu ==========
        
        CommandGroup(before: .newItem) {
            // Add Game
            Button(action: {
                sheetCoordinator.formViewModel = GameFormViewModel(mode: .add)
                sheetCoordinator.formViewModel?.onSave = { updatedGame in
                    gameViewModel.addGame(updatedGame)
                }
            }, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "plus") }
                    Text("Add Game")
                }
            })
            .keyboardShortcut("n", modifiers: [.command, .shift])
            
            // Edit Game
            Button(action: {
                guard let selected = gameViewModel.selectedGame else { return }
                sheetCoordinator.formViewModel = GameFormViewModel(mode: .edit(existing: selected))
                sheetCoordinator.formViewModel?.onSave = { updatedGame in
                    gameViewModel.updateGame(updatedGame)
                }
            }, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "pencil") }
                    Text("Edit Game")
                }
            })
            .keyboardShortcut("e", modifiers: [.command, .shift])

            // Play Game
            Button(action: {
                if let game = gameViewModel.selectedGame {
                    gameViewModel.launchGame(game)
                    AppEnvironment.logger.log("Launching game '\(game.name ?? "Unnamed")'", level: .info)
                }
            }, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "play") }
                    Text("Play Game")
                }
            })
            .keyboardShortcut("p", modifiers: [.command, .shift])
            
            Divider()
        }
        
        CommandGroup(replacing: .importExport) {
            // Open Phoenix Directory
            Button(action: {
                if let phoenixDirectory = getPhoenixDirectory() {
                    NSWorkspace.shared.open(phoenixDirectory)
                    AppEnvironment.logger.log("Opened Application Support/Phoenix.", level: .info)
                }
            }, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "folder") }
                    Text("Open Phoenix Data Folder")
                }
            })
            .keyboardShortcut("o", modifiers: [.command, .shift])
        }
        
        // ========== View Menu ==========
        
        CommandGroup(replacing: .sidebar) {
            // Sort by platform
            Button(action: {
                gameViewModel.sortMode = .platform
            }, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "gamecontroller") }
                    Text("Sort Sidebar by Platform")
                }
            })
            .keyboardShortcut("1", modifiers: [.command])
            
            // Sort by status
            Button(action: {
                gameViewModel.sortMode = .status
            }, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "trophy") }
                    Text("Sort Sidebar by Status")
                }
            })
            .keyboardShortcut("2", modifiers: [.command])
            
            // Sort by Name
            Button(action: {
                gameViewModel.sortMode = .name
            }, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "textformat.abc") }
                    Text("Sort Sidebar by Name")
                }
            })
            .keyboardShortcut("3", modifiers: [.command])
            
            // Sort by Recency
            Button(action: {
                gameViewModel.sortMode = .recency
            }, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "clock") }
                    Text("Sort Sidebar by Recency")
                }
            })
            .keyboardShortcut("4", modifiers: [.command])
            
            Divider()
        }
        
        // ========== Updates ==========
        
        CommandGroup(after: .appInfo) {
            Button(action: {}, label: {
                Text("Check for Updates")
            })
            .disabled(true); #warning("TODO: Implement app updates")
        }
        
        // ========== Help Menu ==========
        
        CommandGroup(replacing: .help) {
            // Phoenix help
            Link("Phoenix Help", destination: URL(string: "https://github.com/phoenixlauncher/phoenix/wiki/0.-Home")!)
            
            // Donate to Phoenix
            Link("Donate to Phoenix", destination: URL(string: "https://ko-fi.com/phoenixlauncher")!)
        }
    }
}
