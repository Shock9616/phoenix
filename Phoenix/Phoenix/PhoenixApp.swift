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

    var body: some Scene {
        WindowGroup {
            PhoenixRootView(viewModel: gameViewModel)
        }
    }
}
