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
    @State private var gameRating: Float = 0.0

    var body: some View {
        ScrollView {
            // ========== Header ==========

            HeaderView(image: viewModel.selectedGameHeader, height: 450)

            // ========== Content ==========

            VStack(alignment: .leading, spacing: 10) {
                // ---------- Controls ----------
                HStack {
                    // Play/Stop button
                    ControlButtonView(action: {
                        if let game = viewModel.selectedGame {
                            switch viewModel.actionButtonState {
                                case .play:
                                    viewModel.launchGame(game)
                                case .stop:
                                    viewModel.killGame(game)
                            }
                        }
                    }, label: {
                        HStack {
                            Image(systemName: viewModel.actionButtonState == .play ? "play.fill" : "stop.fill")
                            Text(viewModel.actionButtonState == .play ? "Play" : "Stop")
                        }
                        .frame(width: 160, height: 50)
                    })
                    .tint(viewModel.actionButtonState == .play ? .green : .red)

                    // Edit game button
                    ControlButtonView(action: {}, label: {
                        Image(systemName: "pencil")
                            .frame(width: 40, height: 50)
                    })
                    .tint(.gray)

                    // Star Rating
                    StarRatingView(rating: $gameRating)
                        .onAppear {
                            self.gameRating = viewModel.selectedGameRating
                        }
                        .onChange(of: viewModel.selectedGameIDs) {
                            self.gameRating = viewModel.selectedGameRating
                        }
                        .onChange(of: gameRating) {
                            viewModel.updateRating(gameRating)
                        }

                    Spacer()
                }
                .offset(y: -6)

                // ---------- Details ----------
                HStack(alignment: .top) {
                    VStack {
                        DescriptionView(viewModel.selectedGameDescription ?? "")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 8)
                        ImageCarouselView(images: viewModel.selectedGameScreenshots)
                            .frame(height: 200)
                    }
                    MetadataView(viewModel.selectedGameMetadata)
                        .fixedSize()
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.top)
    }
}
