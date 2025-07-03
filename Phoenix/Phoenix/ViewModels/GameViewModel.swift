//
//  GameViewModel.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI
internal import Combine

/// The view model that communicates between the app's UI and the
/// backend
class GameViewModel: ObservableObject {
    @Published private var gameModel = GameModel()

    private let logger: Logging

    init(logger: Logging = AppEnvironment.logger) {
        self.logger = logger
    }

    var games: [Game] {
        gameModel.games
    }

    var selectedGameIDs: Set<UUID> {
        gameModel.selectedGameIDs
    }

    var selectedGame: Game? {
        guard let selectedID = selectedGameIDs.first else { return nil }
        return games.first { $0.id == selectedID }
    }

    // Comptued properties to handle unwrapping optional chains for the UI

    var selectedGameSteamID: Int? {
        guard let steamID = selectedGame?.steamID else { return nil }
        return steamID
    }

    var selectedGameIgdbID: Int? {
        guard let igdbID = selectedGame?.igdbID else { return nil }
        return igdbID
    }

    var selectedGameName: String? {
        guard let name = selectedGame?.name else { return nil }
        return name
    }

    var selectedGamePlatform: String? {
        guard let platform = selectedGame?.platform else { return nil }
        return platform
    }

    var selectedGameStatus: Status {
        guard let status = selectedGame?.status else { return Status.none }
        return status
    }

    var selectedGameRecency: Recency {
        guard let recency = selectedGame?.recency else { return Recency.never }
        return recency
    }

    var selectedGameHidden: Bool {
        guard let hidden = selectedGame?.isHidden else { return false }
        return hidden
    }

    var selectedGameFavorite: Bool {
        guard let favorite = selectedGame?.isFavorite else { return false }
        return favorite
    }

    var selectedGameExecutable: URL? {
        guard let executablePath = selectedGame?.gameExecutable else { return nil }
        return executablePath
    }

    var selectedGameLauncher: String? {
        guard let launcher = selectedGame?.launcher else { return nil }
        return launcher
    }

    var selectedGameIcon: Image {
        guard let iconPath = selectedGame?.icon,
              let icon = loadImage(filePath: iconPath)
        else {
            logger.log("Using placeholder icon for \(selectedGameName ?? "Unknown Game")", level: .info)
            return Image("PlaceholderIcon")
        }
        return Image(nsImage: icon)
    }

    var selectedGameHeader: Image {
        guard let headerPath = selectedGame?.header,
              let header = loadImage(filePath: headerPath)
        else {
            logger.log("Using placeholder header image for \(selectedGameName ?? "Unknown Game")", level: .info)
            return Image("PlaceholderImage")
        }
        return Image(nsImage: header)
    }

    var selectedGameCover: Image {
        guard let coverPath = selectedGame?.cover,
              let cover = loadImage(filePath: coverPath)
        else {
            logger.log("Using placeholder cover image for \(selectedGameName ?? "Unknown Game")", level: .info)
            return Image("PlaceholderImage")
        }
        return Image(nsImage: cover)
    }

    var selectedGameScreenshots: [Image] {
        var screenshots: [Image] = []
        guard let screenshotPaths = selectedGame?.screenshots else { return screenshots }
        for path in screenshotPaths {
            guard let path = path else {
                logger.log("Given screenshot path doesn't exist for \(selectedGameName ?? "Unknown Game")", level: .warning)
                continue
            }
            guard let screenshot = loadImage(filePath: path) else {
                logger.log("Error loading screenshot for \(selectedGameName ?? "Unknown Game")", level: .error)
                continue
            }
            screenshots.append(Image(nsImage: screenshot))
        }
        return screenshots
    }

    var selectedGameDescription: String? {
        guard let description = selectedGame?.description else { return nil }
        return description
    }

    var selectedGameGenres: [String?] {
        guard let genres = selectedGame?.genres else { return [] }
        return genres
    }

    var selectedGameRating: Double {
        guard let rating = selectedGame?.rating else { return 0.0 }
        return rating
    }

    var selectedGameReleaseDate: Date? {
        guard let date = selectedGame?.releaseDate else { return nil }
        return date
    }

    var selectedGameLastPlayed: Date? {
        guard let date = selectedGame?.lastPlayed else { return nil }
        return date
    }

    var selectedGameDeveloper: String? {
        guard let developer = selectedGame?.developer else { return nil }
        return developer
    }

    var selectedGamePublishers: [String?] {
        guard let publishers = selectedGame?.publishers else { return [] }
        return publishers
    }

    var selectedGameMetadata: [(String, String)] {
        var metadata: [(String, String)] = []

        // Set up a consistent date formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none

        // Last Played
        if let date = selectedGameLastPlayed {
            let formattedDateString = formatter.string(from: date)
            metadata.append(("Last Played", formattedDateString))
        }

        // Platform
        if let platform = selectedGamePlatform {
            metadata.append(("Platform", platform))
        }

        // Status
        metadata.append(("Status", selectedGameStatus.displayName))

        // Genres
        let genres = selectedGameGenres.compactMap { $0 }
        if !genres.isEmpty {
            metadata.append(("Genres", genres.joined(separator: "\n")))
        }

        // Developer
        if let developer = selectedGameDeveloper {
            metadata.append(("Developer", developer))
        }

        // Publishers
        let publishers = selectedGamePublishers.compactMap { $0 }
        if !publishers.isEmpty {
            metadata.append(("Publishers", publishers.joined(separator: "\n")))
        }

        // Release Date
        if let releaseDate = selectedGameReleaseDate {
            let formattedDateString = formatter.string(from: releaseDate)
            metadata.append(("Release Date", formattedDateString))
        }

        return metadata
    }

    // Filtering for game list

    var favoriteGames: [Game] {
        games.filter { !$0.isHidden && $0.isFavorite }
    }

    var otherGames: [Game] {
        games.filter { !$0.isHidden && !$0.isFavorite }
    }

    // MARK: - Intents

    /// Set the gameModel's selectedGameIDs variable to the given set
    ///
    /// - Parameters:
    /// - ids: The set of UUIDs to send to the gameModel
    func selectGames(_ ids: Set<UUID>) {
        gameModel.selectedGameIDs = ids
        logger.log("Selected game(s) \(games.filter { ids.contains($0.id) }.compactMap { $0.name })", level: .debug)
    }
}
