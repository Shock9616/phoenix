//
//  GameFormView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-05.
//

import SwiftUI
import UniformTypeIdentifiers

/// The view containing controls to edit or create a new game
///
/// - Parameters:
/// - gameFormViewModel: The view model for keeping track of changes to the game
struct GameFormView: View {
    @ObservedObject var gameFormViewModel: GameFormViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 100)
                .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
            HStack {
                if let iconPath = gameFormViewModel.icon, let icon = loadImage(filePath: iconPath) {
                    Image(nsImage: icon)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                Text(gameFormViewModel.name)
                    .font(.system(size: 24))
            }
            .padding()
        }
        .padding(.horizontal, -20)
        .padding(.top, -20)

        Grid(alignment: .leading) {
            // Name input
            GridRow {
                Text("Name")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: $gameFormViewModel.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Icon input
            GridRow {
                Text("Icon")
                    .frame(maxWidth: 80, alignment: .trailing)
                FilePickerView(filePath: $gameFormViewModel.icon, type: .image)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Platform input
            GridRow {
                Text("Platform")
                    .frame(maxWidth: 80, alignment: .trailing)
                Picker("", selection: $gameFormViewModel.platform) {
                    ForEach(Platform.allCases) { platform in
                        Text(platform.displayName)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .labelsHidden()
            }
            .padding(.vertical, 5)

            // Status input
            GridRow {
                Text("Status")
                    .frame(maxWidth: 80, alignment: .trailing)
                Picker("", selection: $gameFormViewModel.status) {
                    ForEach(Status.allCases) { status in
                        Text(status.displayName)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .labelsHidden()
            }
            .padding(.vertical, 5)

            // Game executable input
            GridRow {
                Text("Game")
                    .frame(maxWidth: 80, alignment: .trailing)
                FilePickerView(filePath: $gameFormViewModel.gameExecutable, type: .item)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Description input
            GridRow {
                Text("Description")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: $gameFormViewModel.description, axis: .vertical)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Genres input
            GridRow {
                Text("Genres")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: Binding(get: { gameFormViewModel.genresText }, set: { gameFormViewModel.genresText = $0 }), axis: .vertical)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Header input
            GridRow {
                Text("Header")
                    .frame(maxWidth: 80, alignment: .trailing)
                FilePickerView(filePath: $gameFormViewModel.header, type: .image)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Cover input
            GridRow {
                Text("Cover")
                    .frame(maxWidth: 80, alignment: .trailing)
                FilePickerView(filePath: $gameFormViewModel.cover, type: .image)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Developers input
            GridRow {
                Text("Developers")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: Binding(get: { gameFormViewModel.developersText }, set: { gameFormViewModel.developersText = $0 }), axis: .vertical)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Publishers input
            GridRow {
                Text("Publishers")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: Binding(get: { gameFormViewModel.publishersText }, set: { gameFormViewModel.publishersText = $0 }), axis: .vertical)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Release date input
            GridRow {
                Text("Release Date")
                    .frame(maxWidth: 80, alignment: .trailing)
                DatePicker("", selection: $gameFormViewModel.releaseDate, displayedComponents: .date)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .labelsHidden()
            }
            .padding(.vertical, 5)

            // IGDB ID input
            GridRow {
                Text("IGDB ID")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: Binding(get: { gameFormViewModel.igdbIDText }, set: { gameFormViewModel.igdbIDText = $0 }), axis: .vertical)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Command input
            DisclosureGroup("Advanced") {
                Grid(alignment: .leading) {
                    GridRow {
                        Text("Command")
                            .frame(maxWidth: 80, alignment: .trailing)
                        TextField("", text: $gameFormViewModel.launcher, prompt: Text("Override defaualt launch command"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding()

        HStack {
            // Fetch metadata button
            Button(action: {}, label: {
                Text("Fetch Metadata")
            })
            .disabled(true); #warning("TODO: Implement metadata fetching")

            // Save game button
            Button(action: {
                gameFormViewModel.saveGame()
                dismiss()
            }, label: {
                Text("Save Game")
            })
        }
        .padding()
    }
}
