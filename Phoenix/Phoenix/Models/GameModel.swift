//
//  GameModel.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import Foundation

/// The model that controls all of the game data in Phoenix
///
/// - Parameters:
/// - games: The Array of Game objects representing all the games in
/// the user's library
/// - selectedGameIDs: A set of UUIDs that correspond to the selected
/// games in the GameListView
struct GameModel {
    var games: [Game]
    var selectedGameIDs: Set<UUID>
    var runningGames: [Game] = []

    init() {
        games = loadGames()
        selectedGameIDs = [games[0].id]
    }
}

/// Loads games into the app on startup
///
/// - Returns: An array of Game objects representing all the games
/// in the user's library
func loadGames() -> [Game] {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"

    return [
        Game(
            steamID: 1145350,
            igdbID: 228525,
            name: "Hades II",
            platform: .steam,
            status: .playing,
            recency: .week,
            isFavorite: true,
            launcher: "open steam://run/1145350",
            icon: URL(filePath: "/Users/kalebrosborough/Desktop/Phoenix Data Backup/cachedImages/7F3A4920-01B2-45D2-8E1B-F4DFA57267A8_icon.jpg"),
            header: URL(filePath: "/Users/kalebrosborough/Desktop/Phoenix Data Backup/cachedImages/7F3A4920-01B2-45D2-8E1B-F4DFA57267A8_header.jpg"),
            description: "As the immortal Princess of the Underworld, you'll explore a bigger, deeper mythic world, vanquishing the forces of the Titan of Time with the full might of Olympus behind you, in a sweeping story that continually unfolds through your every setback and accomplishment. New locations, challenges, upgrade systems, and surprises await as you delve into the ever-shifting Underworld again and again.",
            genres: ["Adventure", "Indie", "Role-playing (RPG)"],
            rating: 3.5,
            releaseDate: formatter.date(from: "06/29/2024"),
            lastPlayed: formatter.date(from: "07/01/2025"),
            developers: ["Supergiant Games"],
            publishers: ["Supergiant Games"]
        ),
        Game(
            igdbID: 27238,
            name: "AM2R",
            platform: .mac,
            status: .completed,
            recency: .month,
            isFavorite: false,
            launcher: "open 'file:///Users/kalebrosborough/Applications/AM2R.app/'",
            icon: URL(filePath: "/Users/kalebrosborough/Desktop/Phoenix Data Backup/cachedImages/D0E53744-5D93-487B-A802-E09953685736_icon.jpg"),
            header: URL(filePath: "/Users/kalebrosborough/Desktop/Phoenix Data Backup/cachedImages/D0E53744-5D93-487B-A802-E09953685736_header.jpg"),
            description: "AM2R, short for Another Metroid 2 Remake, is an action-adventure video game developed by Milton Guasti under the pseudonym DoctorM64, and released in August 2016 for Microsoft Windows, coinciding with the 30th anniversary of the Metroid series. It is an unofficial, enhanced remake of Nintendo's Game Boy game Metroid II: Return of Samus (1991), borrowing the art style and overall feeling of the Game Boy Advance game Metroid: Zero Mission (2004). Shortly after the game's release, Nintendo sent DMCA notices to websites hosting AM2R; download links to the game were removed from its official website, but Guasti said that he still planned to continue working on the game privately. In September 2016, Guasti ended the development of AM2R after he received a DMCA takedown request from Nintendo.\n\nThe game follows Samus Aran, who aims to eradicate the parasitic Metroids from their home planet SR388. It includes several new features, including redone graphics and music, a map system, and new areas and minibosses. The controls were changed to be less 'floaty', in line with the gameplay of later titles in the series. Video game journalists appreciated the game, frequently calling it impressive and commenting on the improved visuals compared to those of the original Metroid II, although one thought the conditions required to win battles against Metroids were too specific considering how often they occur. The game was nominated for The Game Awards 2016, but was later removed from the nominations page without notice.",
            genres: ["Adventure", "Platform"],
            rating: 5.0,
            releaseDate: formatter.date(from: "08/06/2016"),
            lastPlayed: formatter.date(from: "04/27/2025"),
            developers: ["DoctorM64"],
            publishers: ["DoctorM64"]
        ),
        Game(
            igdbID: 121752,
            name: "Ghostrunner",
            platform: .pc,
            status: .beaten,
            recency: .month,
            isFavorite: false,
            launcher: "open 'file:///Users/kalebrosborough/Applications/Ghostrunner.app/'",
            icon: URL(filePath: "/Users/kalebrosborough/Desktop/Phoenix Data Backup/cachedImages/EE652E0A-07DC-494C-BE7A-14AFBD4B89A1_icon.jpg"),
            header: URL(filePath: "/Users/kalebrosborough/Desktop/Phoenix Data Backup/cachedImages/EE652E0A-07DC-494C-BE7A-14AFBD4B89A1_header.jpg"),
            description: "Enter an intense cyberpunk world and experience fierce, dynamic combat! Conquer your enemies in the physical world and in cyberspace. Hunt for answers in humanity’s last remaining shelter.\n\nAscend humanity’s last remaining shelter, a great tower-city. The tower is torn by violence, poverty, and chaos. Conquer your enemies, discover the secrets of the superstructure and your own origin and obtain the power to challenge The Keymaster.\n\nThe game takes place in the future, after a global cataclysm where the remains of humanity live in a tower built by The Architect, who died mysteriously years ago. Everyone knows the truth, no one says it aloud.\n\nThe world ruled by The Keymaster is harsh. A person’s worth depends on the category of implants they have, defining their whole lives. The implants—given to them in childhood—determine which social group a person belongs to. If you weren’t lucky enough to get a good life, there is nothing you can do.\n\nIt's no surprise that a rebellion starts.\n\nYou are a cyber-warrior, the only one capable of fighting both in the physical world and in cyberspace. Lost and hunted, thrown into the middle of the conflict, you must use this bond with technology to ascend the tower.\n\nAs you climb higher, secrets are revealed. The clock starts ticking on a race to uncover the mystery behind the structure that houses humanity’s last hope. Solve the riddle or be killed—there is no other option.",
            genres: ["Adventure", "Platform", "Shooter"],
            rating: 4.0,
            releaseDate: formatter.date(from: "10/26/2020"),
            lastPlayed: formatter.date(from: "12/9/2024"),
            developers: ["One More Level", "3D Realms"],
            publishers: ["All In! Games", "505 Games"]
        ),
        Game(
            igdbID: 15698,
            name: "Metroid Dread",
            platform: .nx,
            status: .completed,
            recency: .year,
            isFavorite: false,
            launcher: "'/Applications/Ryujinx.app/Contents/MacOS/Ryujinx' '/Volumes/Gamez/emulation/ROMs/Switch/Games/Metroid Dread.nsp' --fullscreen",
            icon: URL(filePath: "/Users/kalebrosborough/Desktop/Phoenix Data Backup/cachedImages/A95E0998-06C6-4F2E-B3B0-836E1A8D0885_icon.jpg"),
            header: URL(filePath: "/Users/kalebrosborough/Desktop/Phoenix Data Backup/cachedImages/A95E0998-06C6-4F2E-B3B0-836E1A8D0885_header.jpg"),
            description: "Face off against unrelenting E.M.M.I. robots: once DNA-extracting research machines, the imposing E.M.M.I. are now hunting Samus down. Tensions are high as you evade these E.M.M.I. to avoid a cruel death while finding a way to take them down. Find out what turned these robotic wonders into the scourge of ZDR and escape with your life.\n\nFeel Samus’ power grow as you gain maneuvers and abilities: acquire new and familiar abilities as you traverse the many environments of this dangerous world. Parkour over obstacles, slide through tight spaces, counter enemies, and battle your way through the planet. Return to areas and use your new abilities to find upgrades, alternate paths, and a way forward. Explore the sprawling map, evade and destroy E.M.M.I. robots, and overcome the dread plaguing ZDR.",
            genres: ["Adventure", "Platform"],
            rating: 5.0,
            releaseDate: formatter.date(from: "10/06/2021"),
            lastPlayed: formatter.date(from: "07/29/2024"),
            developers: ["MercurySteam", "Nintendo EPD"],
            publishers: ["Nintendo"]
        )
    ]
}
