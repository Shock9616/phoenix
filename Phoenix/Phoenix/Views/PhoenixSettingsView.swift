//
//  PhoenixSettingsView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-22.
//

import SwiftUI

/// The root view of the settings window
///
/// Displays the tab bar of settings categories, along with all the settings for
/// the selected category
///
/// - Parameters:
/// - settingsViewModel: The view model that handles the app's global settings
struct PhoenixSettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        TabView {
            GeneralSettingsView(settingsViewModel: settingsViewModel)
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            
            AppearanceSettingsView(settingsViewModel: settingsViewModel)
                .tabItem {
                    Label("Appearance", systemImage: "paintpalette")
                }
        }
    }
}

/// The view for the app's general settings tab
///
/// - Parameters:
/// - settingsViewModel: The view model that handles the app's global settings
struct GeneralSettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        Text("Hello, world!")
    }
}

/// The view for the app's appearance settings tab
///
/// - Parameters:
/// - settingsViewModel: The view model that handles the app's global settings
struct AppearanceSettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Show star rating", isOn: $settingsViewModel.showStarRating)
                .padding()
            
            Toggle("Show game icons", isOn: $settingsViewModel.showIcons)
                .padding()
            
            Toggle("Show game count", isOn: $settingsViewModel.showGameCount)
                .padding()
        }
    }
}

#Preview {
    PhoenixSettingsView(settingsViewModel: SettingsViewModel())
}
