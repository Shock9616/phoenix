//
//  GameViewModel.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI
import UniformTypeIdentifiers
internal import Combine

/// The view model that communicates between the app's UI and the
/// backend
class GameViewModel: ObservableObject {
    @Published private var gameModel = GameModel()
    @Published var searchText: String = ""
    @Published var sortMode: SortMode = .platform
    @Published var renamingGameID: UUID? = nil
    
    private let logger: Logging
    private let gameLauncher: GameLaunching
    
    init(
        logger: Logging = AppEnvironment.logger,
        gameLauncher: GameLaunching = GameLauncherService()
    ) {
        self.logger = logger
        self.gameLauncher = gameLauncher
    }
    
    /// The full list of the user's games
    var games: [Game] {
        gameModel.games
    }
    
    /// A set containing the IDs of all currently selected games
    var selectedGameIDs: Set<UUID> {
        gameModel.selectedGameIDs
    }

    var lastSelectedGameID: UUID?
    
    /// The first selected game
    var selectedGame: Game? {
        guard let selectedID = selectedGameIDs.first else { return nil }
        return games.first { $0.id == selectedID }
    }
    
    var selectedGames: [Game] {
        gameModel.games.filter { selectedGameIDs.contains($0.id) }
    }
    
    // MARK: - Selected game accessors
    
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
            logger.log("Using placeholder icon for \(selectedGameName ?? "Unknown Game")", level: .debug)
            return Image("PlaceholderIcon")
        }
        return Image(nsImage: icon)
    }
    
    /// The first selected game's header image
    var selectedGameHeader: Image {
        guard let headerPath = selectedGame?.header,
              let header = loadImage(filePath: headerPath)
        else {
            logger.log("Using placeholder header image for \(selectedGameName ?? "Unknown Game")", level: .debug)
            return Image("PlaceholderImage")
        }
        return Image(nsImage: header)
    }
    
    /// The first selected game's cover image
    var selectedGameCover: Image {
        guard let coverPath = selectedGame?.cover,
              let cover = loadImage(filePath: coverPath)
        else {
            logger.log("Using placeholder cover image for \(selectedGameName ?? "Unknown Game")", level: .debug)
            return Image("PlaceholderImage")
        }
        return Image(nsImage: cover)
    }
    
    /// The list of all screenshots associated with the first
    /// selected game
    var selectedGameScreenshots: [URL] {
        guard let screenshots = selectedGame?.screenshots else { return [] }
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
        
        // Rating
        @AppStorage("showStarRating") var showStarRating = true
        if !showStarRating {
            metadata.append(("Rating", String(selectedGameRating)))
        }
        
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
    
    // MARK: - Game Launching/Tracking
    
    enum GameActionButtonState { case play, stop }
    
    // Whether the action button should say "play" or "stop"
    var actionButtonState: GameActionButtonState {
        guard let selectedGame = selectedGame else { return .play }
        return gameModel.runningGames.keys.contains(selectedGame.id) ? .stop : .play
    }
    
    // MARK: - Game Grouping
    
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
        lastSelectedGameID = gameModel.selectedGameIDs.reversed().first
        logger.log("Selected game(s) \(games.filter { ids.contains($0.id) }.compactMap { $0.name })", level: .debug)
    }
    
    /// Update the rating of the currently selected game in the
    /// gameModel
    ///
    /// - Parameters:
    /// - rating: A floating-point value representing the user's
    /// rating for the game out of 5
    func updateRating(_ rating: Float) {
        guard let selectedID = selectedGameIDs.first,
              let index = gameModel.games.firstIndex(where: { $0.id == selectedID })
        else { return }
        
        gameModel.games[index].rating = rating
        
        saveGames(gameModel.games)
        logger.log("Updated rating of '\(gameModel.games[index].name ?? "Unknown Game")' to \(rating)", level: .info)
    }
    
    /// Update a game in the gameModel
    ///
    /// - Parameters:
    /// - game: The game to be updated
    func updateGame(_ game: Game) {
        guard let selectedID = selectedGameIDs.first,
              let index = gameModel.games.firstIndex(where: { $0.id == selectedID })
        else { return }
        
        gameModel.games[index] = game
        
        saveGames(gameModel.games)
        logger.log("Updated game '\(game.name ?? "Unknown Game")'", level: .info)
    }
    
    /// Add a game to the gameModel
    ///
    /// - Parameters:
    /// - game: The game to be added
    func addGame(_ game: Game) {
        gameModel.games.append(game)
        gameModel.selectedGameIDs = [game.id]
        
        saveGames(gameModel.games)
        logger.log("Added game '\(game.name ?? "Unknown Game")'", level: .info)
    }
    
    /// Launch the given game and add its process to the gameModel
    ///
    /// - Parameters:
    /// - game: The game to be launched
    func launchGame(_ game: Game) {
        do {
            logger.log("Launching game '\(game.name ?? "Unknown Game")'", level: .info)
            
            let gameProcess = try gameLauncher.launch(game)
            guard let gameID = selectedGame?.id else { return }
            
            gameModel.runningGames[gameID] = gameProcess
        } catch {
            logger.log("Failed to launch game: \(error)", level: .error)
        }
    }
    
    /// Kill the given game and remove its process from the gameModel
    ///
    /// - Parameters:
    /// - game: The game to be killed
    func killGame(_ game: Game) {
        logger.log("Stopping game '\(game.name ?? "Unknown Game")'", level: .info)
        
        guard let handle = gameModel.runningGames[game.id] else { return }
        
        switch handle {
            case .process(let proc):
                proc.terminate()
            case .application(let app):
                app.terminate()
        }
        
        gameModel.runningGames.removeValue(forKey: game.id)
    }
    
    /// Toggle the given games' 'isFavorite' parameter
    ///
    /// - Parameters:
    /// - games: The games to be (un)favorited
    func toggleGamesFavorite(_ games: [Game]) {
        for game in games {
            if let index = gameModel.games.firstIndex(of: game) {
                gameModel.games[index].isFavorite.toggle()
                
                saveGames(gameModel.games)
                logger.log("Game '\(game.name ?? "Unknown Game")' \(gameModel.games[index].isFavorite ? "favorited" : "unfavorited")", level: .info)
            }
        }
    }
    
    /// Hide the given game from the game list
    ///
    /// - Parameters:
    /// - game: The game to be hidden
    func toggleGamesHidden(_ games: [Game]) {
        for game in games {
            guard let index = gameModel.games.firstIndex(of: game) else { return }
            
            gameModel.games[index].isHidden.toggle()
            
            if selectedGameIDs.contains(game.id) {
                // Try to find the nearest visible game to select
                let visibleGames = gameModel.games.enumerated()
                    .filter { !$0.element.isHidden }
                
                if let fallback = visibleGames.last(where: { $0.offset < index }) ??
                    visibleGames.first(where: { $0.offset > index })
                {
                    gameModel.selectedGameIDs = [fallback.element.id]
                } else {
                    // No visible games left
                    gameModel.selectedGameIDs = []
                }
            }
            
            saveGames(gameModel.games)
            logger.log("Game '\(game.name ?? "Unknown Game")' hidden", level: .info)
        }
    }
    
    /// Delete the given game from the user's library
    ///
    /// - Parameters:
    /// - game: The game to be deleted
    func deleteGames(_ games: [Game]) {
        for game in games {
            guard let index = gameModel.games.firstIndex(of: game) else { return }
            
            gameModel.games.remove(at: index)
            
            if selectedGameIDs.contains(game.id) {
                // Try to find the nearest visible game to select
                let visibleGames = gameModel.games.enumerated()
                    .filter { !$0.element.isHidden }
                
                if let fallback = visibleGames.last(where: { $0.offset < index }) ??
                    visibleGames.first(where: { $0.offset > index })
                {
                    gameModel.selectedGameIDs = [fallback.element.id]
                } else {
                    // No visible games left
                    gameModel.selectedGameIDs = []
                }
            }
            
            saveGames(gameModel.games)
            logger.log("Game '\(game.name ?? "Unknown Game")' deleted", level: .info)
        }
    }
    
    /// Set renamingGameID so that the game's name can be edited
    ///
    /// - Parameters:
    /// - game: The game to be renamed
    func editGameName(_ game: Game) {
        renamingGameID = game.id
    }
    
    /// Write a game's new name to the game model
    ///
    /// - Parameters:
    /// - newName: The new name to be written
    /// - gmae: The game to be renamed
    func commitNameChange(_ newName: String, for game: Game) {
        guard let index = gameModel.games.firstIndex(where: { $0.id == game.id }) else { return }
        let oldName = gameModel.games[index].name
        
        gameModel.games[index].name = newName
        renamingGameID = nil
        
        saveGames(gameModel.games)
        logger.log("Renamed game '\(oldName ?? "Unnamed")' to '\(newName)'", level: .info)
    }
    
    /// Open a file selector to select a new game icon
    ///
    /// - Parameters:
    /// - game: The game whose icon is to be changed
    func promptForNewIcon(for game: Game) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.title = "Choose a new icon for \(game.name ?? "this game")"
        
        if panel.runModal() == .OK, let selectedURL = panel.url {
            updateIcon(for: game, with: selectedURL)
        }
    }
    
    /// Update the icon for the given game
    ///
    /// - Parameters:
    /// - game: The game whose icon is to be changed
    /// - url: The url of the icon to be used
    func updateIcon(for game: Game, with url: URL) {
        guard let index = gameModel.games.firstIndex(where: { $0.id == game.id }) else { return }
        gameModel.games[index].icon = url
        
        saveGames(gameModel.games)
        logger.log("Updated icon for '\(game.name ?? "Unknown Game")'", level: .info)
    }
    
    /// Update the platform for the given game
    ///
    /// - Parameters:
    /// - game: The game whose platform is to be updated
    /// - platform: The platform to update to
    func editGamesPlatform(_ games: [Game], _ platform: Platform) {
        for game in games {
            guard let index = gameModel.games.firstIndex(where: { $0.id == game.id }) else { return }
            gameModel.games[index].platform = platform
            
            saveGames(gameModel.games)
            logger.log("Updated platform for '\(game.name ?? "Unknown Game")' to \(platform.displayName)", level: .info)
        }
    }
    
    /// Update the status of the given game
    ///
    /// - Parameters:
    /// - game: The game whose status is to be updated
    /// - status: The status to update to
    func editGamesStatus(_ games: [Game], _ status: Status) {
        for game in games {
            guard let index = gameModel.games.firstIndex(where: { $0.id == game.id }) else { return }
            gameModel.games[index].status = status
            
            saveGames(gameModel.games)
            logger.log("Updated status for '\(game.name ?? "Unknown Game")' to \(status.displayName)", level: .info)
        }
    }
}
