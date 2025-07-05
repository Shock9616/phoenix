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

    private let mode: GameFormMode
    var onSave: ((Game) -> Void)? = nil

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
        }
    }

    func saveGame() {
        let game = Game(
            igdbID: igdbID,
            name: name,
            platform: platform,
            status: status,
            gameExecutable: gameExecutable,
            launcher: launcher,
            icon: icon,
            header: header,
            cover: cover,
            screenshots: screenshots,
            description: description,
            genres: genres,
            releaseDate: releaseDate,
            developers: developers,
            publishers: publishers,
        )
    }
}
