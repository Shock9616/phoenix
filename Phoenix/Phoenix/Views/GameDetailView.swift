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
/// - gameViewModel: The view model for communicating with the app's backend
/// - settingsViewModel: The view model that handles the app's global settings
struct GameDetailView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var sheetCoordinator: SheetCoordinator
    @State private var gameRating: Float = 0.0

    var body: some View {
        ScrollView(showsIndicators: false) {
            // ========== Header ==========

            HeaderView(image: gameViewModel.selectedGameHeader, height: 450)
                .scaledToFill()
                .edgesIgnoringSafeArea(.horizontal)

            // ========== Content ==========

            VStack(alignment: .leading, spacing: 10) {
                // ---------- Controls ----------
                HStack {
                    // Play/Stop button
                    ControlButtonView(
                        action: {
                            if let game = gameViewModel.selectedGame {
                                switch gameViewModel.actionButtonState {
                                case .play:
                                    gameViewModel.launchGame(game)
                                case .stop:
                                    gameViewModel.killGame(game)
                                }
                            }
                        },
                        label: {
                            HStack {
                                Image(
                                    systemName: gameViewModel.actionButtonState == .play
                                        ? "play.fill" : "stop.fill")
                                Text(gameViewModel.actionButtonState == .play ? "Play" : "Stop")
                            }
                            .frame(width: 160, height: 50)
                        }
                    )
                    .conditionalTint(.accentColor)

                    // Edit game button
                    ControlButtonView(
                        action: {
                            guard let selected = gameViewModel.selectedGame else { return }
                            sheetCoordinator.formViewModel = GameFormViewModel(
                                mode: .edit(existing: selected))
                            sheetCoordinator.formViewModel?.onSave = { updatedGame in
                                gameViewModel.updateGame(updatedGame)
                            }
                        },
                        label: {
                            Image(systemName: "pencil")
                                .frame(width: 35, height: 50)
                        }
                    )
                    .conditionalTint(.accentColor)

                    // Star Rating
                    if settingsViewModel.showStarRating {
                        StarRatingView(rating: $gameRating)
                            .onAppear {
                                self.gameRating = gameViewModel.selectedGameRating
                            }
                            .onChange(of: gameViewModel.selectedGameIDs) {
                                self.gameRating = gameViewModel.selectedGameRating
                            }
                            .onChange(of: gameRating) {
                                gameViewModel.updateRating(gameRating)
                            }
                    }

                    Spacer()
                }
                .offset(y: -6)

                // ---------- Details ----------
                HStack(alignment: .top) {
                    VStack {
                        DescriptionView(gameViewModel.selectedGameDescription ?? "")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 8)
                        ImageCarouselView(images: gameViewModel.selectedGameScreenshots)
                            .frame(height: 200)
                    }
                    MetadataView(gameViewModel.selectedGameMetadata)
                        .fixedSize()
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.top)
    }
}
