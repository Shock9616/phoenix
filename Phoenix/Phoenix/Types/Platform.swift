//
//  Platform.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-03.
//

import Foundation

/// An enum representing the platform a game is for
enum Platform: Comparable, Identifiable, CaseIterable {
    case mac, steam, gog, pc, psx, gba, wii, xbox, nx, other

    init(fromDisplayName name: String) {
        switch name {
            case Platform.mac.displayName: self = .mac
            case Platform.steam.displayName: self = .steam
            case Platform.gog.displayName: self = .gog
            case Platform.pc.displayName: self = .pc
            case Platform.psx.displayName: self = .psx
            case Platform.gba.displayName: self = .gba
            case Platform.wii.displayName: self = .wii
            case Platform.xbox.displayName: self = .xbox
            case Platform.nx.displayName: self = .nx
            default: self = .other
        }
    }

    var id: Platform { self }

    var displayName: String {
        switch self {
            case .mac: return "Mac"
            case .steam: return "Steam"
            case .gog: return "GOG"
            case .pc: return "PC"
            case .psx: return "PlayStation"
            case .gba: return "GBA"
            case .wii: return "Wii"
            case .xbox: return "Xbox"
            case .nx: return "Switch"
            case .other: return "Other"
        }
    }

    func inferredLaunchMethod(for game: Game) -> LaunchMethod? {
        switch self {
            case .mac:
                guard let path = game.gameExecutable else { return nil }
                return .appBundle(path: path)
            case .steam:
                guard let steamID = game.steamID else { return nil }
                return .urlScheme(url: "steam://run/\(steamID)")
            case .gog:
                guard let path = game.gameExecutable else { return nil }
                return .appBundle(path: path)
            case .pc:
                guard let path = game.gameExecutable else { return nil }
                return .appBundle(path: path)
            case .psx:
                guard let path = game.gameExecutable else { return nil }
                return .shell(command: "'/Applications/DuckStation.app/Contents/MacOS/DuckStation' '\(path.path(percentEncoded: false))'")
            case .gba:
                guard let path = game.gameExecutable else { return nil }
                return .shell(command: "'/Applications/mGBA.app/Contents/MacOS/mGBA' '\(path.path(percentEncoded: false))'")
            case .wii:
                guard let path = game.gameExecutable else { return nil }
                return .shell(command: "'/Applications/Dolphin.app/Contents/MacOS/Dolphin' \(path.path(percentEncoded: false))'")
            case .nx:
                guard let path = game.gameExecutable else { return nil }
                return .shell(command: "'/Applications/Ryujinx.app/Contents/MacOS/Ryujinx' '\(path.path(percentEncoded: false))' --fullscreen")
            case .xbox:
                guard let path = game.gameExecutable else { return nil }
                return .shell(command: "'/Applications/Xemu.app/Contents/MacOS/xemu' -dvd_path '\(path.path(percentEncoded: false))'")
            case .other:
                guard let launcher = game.launcher else { return nil }
                return .shell(command: launcher)
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        let order: [Platform] = [.mac, .steam, .gog, .pc, .psx, .gba, .wii, .xbox, .nx, .other]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
