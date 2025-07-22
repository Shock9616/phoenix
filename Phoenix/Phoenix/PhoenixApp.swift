//
//  PhoenixApp.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI

@main
struct PhoenixApp: App {
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()

    // Set app logger
    private let logger = AppEnvironment.logger

    init() {
        // Print system info on startup
        StartupLogger.logAppLaunchInfo(using: logger)
    }

    var body: some Scene {
        WindowGroup {
            PhoenixRootView(gameViewModel: gameViewModel, settingsViewModel: settingsViewModel)
                .frame(minWidth: 835, minHeight: 485)
        }
        .commands {
            MenuCommands(gameViewModel: gameViewModel)
        }
        
        Settings {
            PhoenixSettingsView(settingsViewModel: settingsViewModel)
                .frame(width: 500, height: 300)
        }
    }
}
