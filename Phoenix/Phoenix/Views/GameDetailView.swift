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

            HeaderView(image: Image("PlaceholderImage"), height: 450)

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
                    DescriptionView("Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.")
                    MetadataView()
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.top)
    }
}
