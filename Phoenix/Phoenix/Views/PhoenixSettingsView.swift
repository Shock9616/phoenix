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
    @ObservedObject var gameViewModel: GameViewModel
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

            HiddenGamesView(gameViewModel: gameViewModel)
                .tabItem {
                    Label("Hidden Games", systemImage: "eye.slash.fill")
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
        Grid(alignment: .leading) {
            GridRow {
                Text("")
                    .frame(maxWidth: 166, alignment: .trailing)
                Toggle("Automatically fetch game metadata", isOn: $settingsViewModel.fetchMetadata)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .disabled(true); #warning("TODO: implement automatic metadata fetching")
            }
            .padding(.vertical, 5)

            GridRow {
                Text("")
                    .frame(maxWidth: 166, alignment: .trailing)
                Toggle("Automatically fetch game icon", isOn: $settingsViewModel.fetchIcon)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .disabled(true); #warning("TODO: implement automatic icon fetching")
            }
        }
    }
}

/// The view for the app's appearance settings tab
///
/// - Parameters:
/// - settingsViewModel: The view model that handles the app's global settings
struct AppearanceSettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel

    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                Text("")
                    .frame(maxWidth: 166, alignment: .trailing)
                Toggle("Show star rating", isOn: $settingsViewModel.showStarRating)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            Divider()

            GridRow {
                Text("")
                    .frame(maxWidth: 166, alignment: .trailing)
                Toggle("Show star rating", isOn: $settingsViewModel.showStarRating)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            GridRow {
                Text("")
                    .frame(maxWidth: 166, alignment: .trailing)
                Toggle("Show game icons", isOn: $settingsViewModel.showIcons)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            GridRow {
                Text("Icon size")
                    .frame(maxWidth: 166, alignment: .trailing)
                Picker("", selection: $settingsViewModel.iconSize) {
                    ForEach(IconSize.allCases, id: \.rawValue) { size in
                        Text(size.displayName).tag(size.rawValue) // tag is Double
                    }
                }
                .disabled(!settingsViewModel.showIcons)
                .frame(maxWidth: .infinity, alignment: .leading)
                .labelsHidden()
            }
            .padding(.vertical, 5)

            GridRow {
                Text("")
                    .frame(maxWidth: 166, alignment: .trailing)
                Toggle("Show game count", isOn: $settingsViewModel.showGameCount)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)
        }
        .padding()
    }
}

/// The view for the app's hidden games tab
///
/// - Parameters:
/// - settingsViewModel: The view model that handles the app's global settings
struct HiddenGamesView: View {
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        List {
            ForEach(gameViewModel.games.filter { $0.isHidden }) { game in
                HStack {
                    Text(game.name ?? "Unnamed")
                    Spacer()
                    Button(action: {
                        gameViewModel.toggleGamesHidden([game])
                    }, label: {
                        Text("Show game")
                    })
                    Button(action: {
                        gameViewModel.deleteGames([game])
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
            }
        }
    }
}

#Preview {
    PhoenixSettingsView(gameViewModel: GameViewModel(), settingsViewModel: SettingsViewModel())
}
