//
//  SettingsViewModel.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-22.
//

import Foundation
internal import Combine
import SwiftUI

/// The view model that handles the app's global settings
class SettingsViewModel: ObservableObject {
    @Published var selectedTab: SettingsTab = .general

    // Appearance Settings
    @AppStorage("showStarRating") var showStarRating: Bool = true
    @AppStorage("showIcons") var showIcons: Bool = true
    @AppStorage("iconSize") var iconSize: Double = 25
    @AppStorage("showGameCount") var showGameCount: Bool = true
}

enum SettingsTab: Hashable {
    case general, appearance
}
