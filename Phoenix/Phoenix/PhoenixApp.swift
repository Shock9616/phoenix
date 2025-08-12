//
//  PhoenixApp.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI
internal import Combine

@main
struct PhoenixApp: App {
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var sheetCoordinator = SheetCoordinator()

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
                .environmentObject(sheetCoordinator)
        }
        .commands {
            MenuCommands(gameViewModel: gameViewModel)
        }
        .environmentObject(sheetCoordinator)

        Settings {
            PhoenixSettingsView(gameViewModel: gameViewModel, settingsViewModel: settingsViewModel)
                .frame(width: 500, height: 300)
        }
    }
}

final class SheetCoordinator: ObservableObject {
    @Published var formViewModel: GameFormViewModel?
}
