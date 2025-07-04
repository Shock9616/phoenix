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
    @Published var searchText: String = ""

    private var sortMode: SortMode = .platform

    private let logger: Logging

    init(logger: Logging = AppEnvironment.logger) {
        self.logger = logger
    }

    /// The full list of the user's games
    var games: [Game] {
        gameModel.games
    }

    /// A set containing the IDs of all currently selected games
    var selectedGameIDs: Set<UUID> {
        gameModel.selectedGameIDs
    }

    /// The first selected game
    var selectedGame: Game? {
        guard let selectedID = selectedGameIDs.first else { return nil }
        return games.first { $0.id == selectedID }
    }

    // Comptued properties to handle unwrapping optional chains for the UI

    /// The Steam ID of the first selected game
    var selectedGameSteamID: Int? {
        guard let steamID = selectedGame?.steamID else { return nil }
        return steamID
    }

    /// The IGDB ID of the first selected game
    var selectedGameIgdbID: Int? {
        guard let igdbID = selectedGame?.igdbID else { return nil }
        return igdbID
    }

    /// The name of the first selected game
    var selectedGameName: String? {
        guard let name = selectedGame?.name else { return nil }
        return name
    }

    /// The platform of the first selected game
    var selectedGamePlatform: Platform {
        guard let platform = selectedGame?.platform else { return Platform.other }
        return platform
    }

    /// The status of the first selected game
    var selectedGameStatus: Status {
        guard let status = selectedGame?.status else { return Status.none }
        return status
    }

    /// The recency of the first selected game
    var selectedGameRecency: Recency {
        guard let recency = selectedGame?.recency else { return Recency.never }
        return recency
    }

    /// Whether or not the first selected game is hidden
    var selectedGameHidden: Bool {
        guard let hidden = selectedGame?.isHidden else { return false }
        return hidden
    }

    /// Whether or not the first selected game is a favorite
    var selectedGameFavorite: Bool {
        guard let favorite = selectedGame?.isFavorite else { return false }
        return favorite
    }

    /// The URL of the first selected game's executable
    var selectedGameExecutable: URL? {
        guard let executablePath = selectedGame?.gameExecutable else { return nil }
        return executablePath
    }

    /// The launcher command of the first selected game
    var selectedGameLauncher: String? {
        guard let launcher = selectedGame?.launcher else { return nil }
        return launcher
    }

    /// The first selected game's icon
    var selectedGameIcon: Image {
        guard let iconPath = selectedGame?.icon,
              let icon = loadImage(filePath: iconPath)
        else {
            logger.log("Using placeholder icon for \(selectedGameName ?? "Unknown Game")", level: .info)
            return Image("PlaceholderIcon")
        }
        return Image(nsImage: icon)
    }

    /// The first selected game's header image
    var selectedGameHeader: Image {
        guard let headerPath = selectedGame?.header,
              let header = loadImage(filePath: headerPath)
        else {
            logger.log("Using placeholder header image for \(selectedGameName ?? "Unknown Game")", level: .info)
            return Image("PlaceholderImage")
        }
        return Image(nsImage: header)
    }

    /// The first selected game's cover image
    var selectedGameCover: Image {
        guard let coverPath = selectedGame?.cover,
              let cover = loadImage(filePath: coverPath)
        else {
            logger.log("Using placeholder cover image for \(selectedGameName ?? "Unknown Game")", level: .info)
            return Image("PlaceholderImage")
        }
        return Image(nsImage: cover)
    }

    /// The list of all screenshots associated with the first
    /// selected game
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

    /// The description of the first selected game
    var selectedGameDescription: String? {
        guard let description = selectedGame?.description else { return nil }
        return description
    }

    /// The list of genres for the first selected game
    var selectedGameGenres: [String?] {
        guard let genres = selectedGame?.genres else { return [] }
        return genres
    }

    /// The user's rating (out of 5) for the first selected game
    var selectedGameRating: Float {
        guard let rating = selectedGame?.rating else { return 0.0 }
        return rating
    }

    /// The release date of the first selected game
    var selectedGameReleaseDate: Date? {
        guard let date = selectedGame?.releaseDate else { return nil }
        return date
    }

    /// The date the first selected game was last played
    var selectedGameLastPlayed: Date? {
        guard let date = selectedGame?.lastPlayed else { return nil }
        return date
    }

    /// The list of developers of the first selected game
    var selectedGameDevelopers: [String] {
        guard let developers = selectedGame?.developers else { return [] }
        return developers
    }

    /// The list of publishers of the first selected game
    var selectedGamePublishers: [String] {
        guard let publishers = selectedGame?.publishers else { return [] }
        return publishers
    }

    /// A list of tuples containing the titles and values of each
    /// metadata entry for the first selected game
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
        metadata.append(("Platform", selectedGamePlatform.displayName))

        // Status
        metadata.append(("Status", selectedGameStatus.displayName))

        // Genres
        let genres = selectedGameGenres.compactMap { $0 }
        if !genres.isEmpty {
            metadata.append(("Genres", genres.joined(separator: "\n")))
        }

        // Developers
        let developers = selectedGameDevelopers.compactMap { $0 }
        if !developers.isEmpty {
            metadata.append(("Developers", developers.joined(separator: "\n")))
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

    /// A list of GameSectionss generated based on the current
    /// sorting setting
    var groupedGames: [GameSection] {
        let visibleGames = games.filter { !$0.isHidden }

        // Always put the favorites section at the top of the list
        let favoriteGames = visibleGames
            .filter { $0.isFavorite }
            .sorted { ($0.name ?? "") < ($1.name ?? "") }

        var sections: [GameSection] = []

        if !favoriteGames.isEmpty {
            sections.append(GameSection(title: "Favorites", games: favoriteGames))
        }

        let nonFavoriteGames = visibleGames.filter { !$0.isFavorite }

        switch sortMode {
            case .platform:
                // Sort games by platform
                let platformGroups = Dictionary(grouping: nonFavoriteGames) { $0.platform }

                let sortedPlatforms = platformGroups.keys.sorted()

                for platform in sortedPlatforms {
                    if let gamesForPlatform = platformGroups[platform] {
                        let sortedGames = gamesForPlatform.sorted { ($0.name ?? "") < ($1.name ?? "") }
                        sections.append(GameSection(title: platform.displayName, games: sortedGames))
                    }
                }
            case .status:
                // Sort games by status
                let statusGroups = Dictionary(grouping: nonFavoriteGames) { $0.status }

                let sortedStatuses = statusGroups.keys.sorted()

                for status in sortedStatuses {
                    if let gamesForStatus = statusGroups[status] {
                        let sortedGames = gamesForStatus.sorted { ($0.name ?? "") < ($1.name ?? "") }
                        sections.append(GameSection(title: status.displayName, games: sortedGames))
                    }
                }
            case .name:
                // Sort games alphabetically by name
                let sortedGames = nonFavoriteGames.sorted { ($0.name ?? "") < ($1.name ?? "") }
                sections.append(GameSection(title: "Games", games: sortedGames))
            case .recency:
                // Sort games by recency
                let recencyGroups = Dictionary(grouping: nonFavoriteGames) { $0.recency }

                let sortedRecencies = recencyGroups.keys.sorted()

                for recency in sortedRecencies {
                    if let gamesForRecency = recencyGroups[recency] {
                        let sortedGames = gamesForRecency.sorted { ($0.name ?? "") < ($1.name ?? "") }
                        sections.append(GameSection(title: recency.displayName, games: sortedGames))
                    }
                }
        }

        return sections
    }

    /// A list of one GameSection that contains all games that match
    /// the contents of the search bar
    var filteredGames: [GameSection] {
        if searchText.isEmpty {
            return groupedGames
        } else {
            let visibleGames = games.filter { !$0.isHidden }

            return [GameSection(
                title: "Search Results",
                games: visibleGames
                    .filter {
                        ($0.name ?? "").localizedCaseInsensitiveContains(searchText)
                    }
            )]
        }
    }

    /// Return groupedGames if the search bar is empty, and the
    /// search results if it isn't
    var displaySections: [GameSection] {
        if searchText.isEmpty {
            return groupedGames
        } else {
            return filteredGames
        }
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

    func updateRating(_ rating: Float) {
        guard let selectedID = selectedGameIDs.first,
              let index = gameModel.games.firstIndex(where: { $0.id == selectedID })
        else {
            return
        }

        gameModel.games[index].rating = rating

        logger.log("Updated rating of \(gameModel.games[index].name ?? "Unknown Game") to \(rating)", level: .info)
    }
}
