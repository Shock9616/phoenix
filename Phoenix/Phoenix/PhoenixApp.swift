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

    // Set app logger
    private let logger = AppEnvironment.logger

    init() {
        // Print system info on startup
        StartupLogger.logAppLaunchInfo(using: logger)
    }

    var body: some Scene {
        WindowGroup {
            PhoenixRootView(viewModel: gameViewModel)
                .frame(minWidth: 835, minHeight: 485)
        }
        .commands {
            MenuCommands(viewModel: gameViewModel)
        }
    }
}
