//
//  Platform.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-03.
//

import Foundation

/// An enum representing the platform a game is for
enum Platform: Comparable, Identifiable, CaseIterable {
    case mac, steam, gog, pc, psx, gba, wii, snes, xbox, nx, other

    init(fromDisplayName name: String) {
        switch name {
            case Platform.mac.displayName: self = .mac
            case Platform.steam.displayName: self = .steam
            case Platform.gog.displayName: self = .gog
            case Platform.pc.displayName: self = .pc
            case Platform.psx.displayName: self = .psx
            case Platform.gba.displayName: self = .gba
            case Platform.wii.displayName: self = .wii
            case Platform.snes.displayName: self = .snes
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
            case .snes: return "SNES"
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
            case .nx:
                guard let path = game.gameExecutable else { return nil }
                return .shell(command: "'/Applications/Ryujinx.app/Contents/MacOS/Ryujinx' '\(path.path(percentEncoded: false))' --fullscreen")
            default:
                return nil
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        let order: [Platform] = [.mac, .steam, .gog, .pc, .psx, .gba, .wii, .snes, .xbox, .nx, .other]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
