//
//  GameDetailView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI

/// The main detail view of the app
///
/// Displays all the information about the game, as well as the play
/// and edit buttons
///
/// Parameters:
/// - viewModel: The view model for communicating with the app's
/// backend
struct GameDetailView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ScrollView {
            // ========== Header ==========

            HeaderView(image: viewModel.selectedGameHeader, height: 450)

            // ========== Content ==========

            VStack(alignment: .leading, spacing: 10) {
                // ---------- Controls ----------
                HStack {
                    // Play button
                    ControlButtonView(action: {}, label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Play")
                        }
                        .frame(width: 160, height: 50)
                    })
                    .tint(.green)

                    // Edit game button
                    ControlButtonView(action: {}, label: {
                        Image(systemName: "pencil")
                            .frame(width: 40, height: 50)
                    })
                    .tint(.gray)

                    Spacer()
                }

                // ---------- Details ----------
                HStack(alignment: .top) {
                    DescriptionView(viewModel.selectedGameDescription ?? "")
                        .fixedSize(horizontal: false, vertical: true)
                    MetadataView(viewModel.selectedGameMetadata)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.top)
    }
}
