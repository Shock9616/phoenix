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
/// - viewModel: The view model for keeping track of changes to the
/// game
struct GameFormView: View {
    @ObservedObject var viewModel: GameFormViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 100)
                .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
            HStack {
                if let iconPath = viewModel.icon, let icon = loadImage(filePath: iconPath) {
                    Image(nsImage: icon)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                Text(viewModel.name)
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
                TextField("", text: $viewModel.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Icon input
            GridRow {
                Text("Icon")
                    .frame(maxWidth: 80, alignment: .trailing)
                FilePickerView(filePath: $viewModel.icon, type: .image)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Platform input
            GridRow {
                Text("Platform")
                    .frame(maxWidth: 80, alignment: .trailing)
                Picker("", selection: $viewModel.platform) {
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
                Picker("", selection: $viewModel.status) {
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
                FilePickerView(filePath: $viewModel.gameExecutable, type: .data)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Command input
            GridRow {
                Text("Command")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: $viewModel.launcher)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Description input
            GridRow {
                Text("Description")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: $viewModel.description, axis: .vertical)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Genres input
            GridRow {
                Text("Genres")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: Binding(get: { viewModel.genresText }, set: { viewModel.genresText = $0 }), axis: .vertical)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Header input
            GridRow {
                Text("Header")
                    .frame(maxWidth: 80, alignment: .trailing)
                FilePickerView(filePath: $viewModel.header, type: .image)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Cover input
            GridRow {
                Text("Cover")
                    .frame(maxWidth: 80, alignment: .trailing)
                FilePickerView(filePath: $viewModel.cover, type: .image)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)

            // Release date input
            GridRow {
                Text("Release Date")
                    .frame(maxWidth: 80, alignment: .trailing)
                DatePicker("", selection: $viewModel.releaseDate, displayedComponents: .date)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .labelsHidden()
            }
            .padding(.vertical, 5)

            // IGDB ID input
            GridRow {
                Text("IGDB ID")
                    .frame(maxWidth: 80, alignment: .trailing)
                TextField("", text: Binding(get: { viewModel.igdbIDText }, set: { viewModel.igdbIDText = $0 }), axis: .vertical)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)
        }
        .padding()

        HStack {
            // Fetch metadata button
            Button(action: {}, label: {
                Text("Fetch Metadata")
            })

            // Save game button
            Button(action: {
                viewModel.saveGame()
                dismiss()
            }, label: {
                Text("Save Game")
            })
        }
        .padding()
    }
}
