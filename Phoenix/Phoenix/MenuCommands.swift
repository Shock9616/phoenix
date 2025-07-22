//
//  MenuCommands.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-21.
//

import SwiftUI

struct MenuCommands: Commands {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some Commands {
        // File menu
        CommandGroup(before: .newItem) {
            // Add Game
            Button(action: {}, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "plus") }
                    Text("Add Game")
                }
            })
            .keyboardShortcut("n", modifiers: [.command, .shift])
            
            // Edit Game
            Button(action: {}, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "pencil") }
                    Text("Edit Game")
                }
            })
            .keyboardShortcut("e", modifiers: [.command, .shift])
            
            // Play Game
            Button(action: {}, label: {
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
            Button(action: {}, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "folder") }
                    Text("Open Phoenix Data Folder")
                }
            })
            .keyboardShortcut("o", modifiers: [.command, .shift])
        }
        
        // View
        CommandGroup(replacing: .sidebar) {
            // Sort by platform
            Button(action: {}, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "gamecontroller") }
                    Text("Sort Sidebar by Platform")
                }
            })
            .keyboardShortcut("1", modifiers: [.command])
            
            // Sort by status
            Button(action: {}, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "trophy") }
                    Text("Sort Sidebar by Status")
                }
            })
            .keyboardShortcut("2", modifiers: [.command])
            
            // Sort by Name
            Button(action: {}, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "textformat.abc") }
                    Text("Sort Sidebar by Name")
                }
            })
            .keyboardShortcut("3", modifiers: [.command])
            
            // Sort by Recency
            Button(action: {}, label: {
                HStack {
                    if #available(macOS 26.0, *) { Image(systemName: "clock") }
                    Text("Sort Sidebar by Recency")
                }
            })
            .keyboardShortcut("4", modifiers: [.command])
            
            Divider()
        }
        
        // Updates
        CommandGroup(after: .appInfo) {
            Button(action: {}, label: {
                Text("Check for Updates")
            })
        }
        
        // Help
        CommandGroup(replacing: .help) {
            // Phoenix help
            Button(action: {}, label: {
                Text("Phoenix Help")
            })
            
            // Donate to Phoenix
            Button(action: {}, label: {
                Text("Donate to Phoenix")
            })
        }
    }
}
