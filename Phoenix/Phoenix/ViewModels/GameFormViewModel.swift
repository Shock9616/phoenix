//
//  GameFormViewModel.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-05.
//

import Foundation
internal import Combine

enum GameFormMode {
    case add
    case edit(existing: Game)
}

/// The view model that handles creating/editing a game
class GameFormViewModel: ObservableObject, Identifiable {
    let id = UUID()

    @Published var name: String = ""
    @Published var icon: URL?
    @Published var platform: Platform = .other
    @Published var status: Status = .none
    @Published var gameExecutable: URL?
    @Published var launcher: String = ""
    @Published var description: String = ""
    @Published var genres: [String] = []
    @Published var header: URL?
    @Published var cover: URL?
    @Published var screenshots: [URL] = []
    @Published var developers: [String] = []
    @Published var publishers: [String] = []
    @Published var releaseDate: Date = .init()
    @Published var igdbID: Int?

    private var gameID: UUID?
    private var steamID: Int?
    private var recency: Recency = .never
    private var isHidden: Bool = false
    private var isFavorite: Bool = false
    private var rating: Float?
    private var lastPlayed: Date?

    private let mode: GameFormMode
    var onSave: ((Game) -> Void)?

    init(mode: GameFormMode) {
        self.mode = mode
        if case let .edit(existing) = mode {
            name = existing.name ?? ""
            icon = existing.icon
            platform = existing.platform
            status = existing.status
            gameExecutable = existing.gameExecutable
            launcher = existing.launcher ?? ""
            description = existing.description ?? ""
            genres = existing.genres
            header = existing.header
            cover = existing.cover
            screenshots = existing.screenshots
            developers = existing.developers
            publishers = existing.publishers
            releaseDate = existing.releaseDate ?? Date()
            igdbID = existing.igdbID

            gameID = existing.id
            steamID = existing.steamID
            recency = existing.recency
            isHidden = existing.isHidden
            isFavorite = existing.isFavorite
            rating = existing.rating
            lastPlayed = existing.lastPlayed
        } else {
            gameID = nil
            steamID = nil
            rating = 0
            lastPlayed = nil
        }
    }

    // Convert the genres array to a string and back
    var genresText: String {
        get {
            genres.joined(separator: ", ")
        } set {
            genres = newValue
                .components(separatedBy: ", ")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
    }

    // Convert the developers array to a string and back
    var developersText: String {
        get {
            developers.joined(separator: ", ")
        } set {
            developers = newValue
                .components(separatedBy: ", ")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
    }

    // Convert the publishers array to a string and back
    var publishersText: String {
        get {
            publishers.joined(separator: ", ")
        } set {
            publishers = newValue
                .components(separatedBy: ", ")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
    }

    // Convert the Steam ID to a string and back
    var steamIDText: String {
        get {
            String(steamID ?? 0)
        } set {
            steamID = Int(newValue)
        }
    }

    // Convert the IGDB ID to a string and back
    var igdbIDText: String {
        get {
            String(igdbID ?? 0)
        } set {
            igdbID = Int(newValue)
        }
    }

    /// Create a new game object with the updated values and save
    func saveGame() {
        let newUUID = UUID()

        let newIcon = cacheImage(originalURL: icon, gameID: gameID ?? newUUID, imageType: "icon")
        let newHeader = cacheImage(originalURL: header, gameID: gameID ?? newUUID, imageType: "header")
        let newCover = cacheImage(originalURL: cover, gameID: gameID ?? newUUID, imageType: "cover")

        let game = Game(
            id: gameID ?? newUUID,
            steamID: steamID,
            igdbID: igdbID,
            name: name,
            platform: platform,
            status: status,
            recency: recency,
            isHidden: isHidden,
            isFavorite: isFavorite,
            gameExecutable: gameExecutable,
            launcher: launcher,
            icon: newIcon,
            header: newHeader,
            cover: newCover,
            screenshots: screenshots,
            description: description,
            genres: genres,
            releaseDate: releaseDate,
            lastPlayed: lastPlayed,
            developers: developers,
            publishers: publishers,
        )

        onSave?(game)
    }
}
