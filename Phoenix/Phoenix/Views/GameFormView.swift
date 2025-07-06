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
        ScrollView {
            VStack {
                // Name input
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("", text: $viewModel.name)
                        .frame(width: 680)
                }
                .padding()

                // Icon input
                FilePickerView(title: "Icon", filePath: $viewModel.icon, type: .image)
                    .padding()

                // Platform input
                HStack {
                    Text("Platform")
                    Spacer()
                    Picker("", selection: $viewModel.platform) {
                        ForEach(Platform.allCases) { platform in
                            Text(platform.displayName)
                        }
                    }
                    .frame(width: 680)
                    .labelsHidden()
                }
                .padding()

                // Status input
                HStack {
                    Text("Status")
                    Spacer()
                    Picker("", selection: $viewModel.status) {
                        ForEach(Status.allCases) { status in
                            Text(status.displayName)
                        }
                    }
                    .frame(width: 680)
                    .labelsHidden()
                }
                .padding()

                // Game executable input
                FilePickerView(title: "Game", filePath: $viewModel.gameExecutable, type: .data)
                    .padding()
            }

            // Advanced section
            DisclosureGroup("Advanced") {
                VStack {
                    // Command input
                    HStack {
                        Text("Command")
                        Spacer()
                        TextField("", text: $viewModel.launcher)
                            .frame(width: 680)
                    }
                    .padding(.vertical)

                    // Description input
                    HStack {
                        Text("Description")
                        Spacer()
                        TextField("", text: $viewModel.description, axis: .vertical)
                            .frame(width: 680)
                    }
                    .padding(.vertical)

                    // Genres input
                    HStack {
                        Text("Genres")
                        Spacer()
                        TextField("", text: Binding(get: { viewModel.genresText }, set: { viewModel.genresText = $0 }), axis: .vertical)
                            .frame(width: 680)
                    }

                    // Header input
                    FilePickerView(title: "Header", filePath: $viewModel.header, type: .image)
                        .padding(.vertical)

                    // Cover input
                    FilePickerView(title: "Cover", filePath: $viewModel.cover, type: .image)
                        .padding(.vertical)

                    // Release date input
                    HStack {
                        DatePicker("Release Date", selection: $viewModel.releaseDate, displayedComponents: .date)
                        Spacer()
                    }
                    .padding(.vertical)

                    // IGDB ID input
                    HStack {
                        Text("IGDB ID")
                        Spacer()
                        TextField("", text: Binding(get: { viewModel.igdbIDText }, set: { viewModel.igdbIDText = $0 }), axis: .vertical)
                            .frame(width: 680)
                    }
                    .padding(.vertical)
                }
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
}
