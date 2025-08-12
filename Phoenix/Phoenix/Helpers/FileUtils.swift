//
//  FileUtils.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-08-12.
//

import Foundation
import SwiftyJSON

/// Returns the Phoenix application support directory, creating one if it
/// doesn't already exist
///
/// - Returns: The URL for the Application support directory/Phoenix.
func getPhoenixDirectory() -> URL? {
    let fileManager = FileManager.default

    guard let appSupportDirectory = fileManager.urls(
        for: .applicationSupportDirectory,
        in: .userDomainMask
    ).first else {
        return nil
    }

    let phoenixDirectory = appSupportDirectory.appending(path: "Phoenix")

    if !fileManager.fileExists(atPath: phoenixDirectory.path) {
        do {
            try fileManager.createDirectory(
                at: phoenixDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            AppEnvironment.logger.log("Failed to create Phoenix directory:", level: .error)
            return nil
        }
    }

    return phoenixDirectory
}

/// Loads games into the app on startup
///
/// - Returns: An array of Game objects representing all the games
/// in the user's library
func loadGames() -> [Game] {
    var games: [Game] = []
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none
    
    do {
        // Read games.json contents into json object
        guard let phoenixDir = getPhoenixDirectory() else { return games }
        
        let gamesFile = phoenixDir.appending(path: "games.json")
        let fileManager = FileManager.default
        
        // If the file doesn't exist, create it with an empty json array
        if !fileManager.fileExists(atPath: gamesFile.path) {
            AppEnvironment.logger.log("Couldn't find games.json, creating a new one...", level: .info)
            fileManager.createFile(atPath: gamesFile.path, contents: "[]".data(using: .utf8), attributes: nil)
        }
        
        let gamesJSONStr = try String(contentsOf: gamesFile, encoding: .utf8)
        
        guard let gamesJSONData = gamesJSONStr.data(using: .utf8) else { return games }
        let gamesJSON = try JSON(data: gamesJSONData)
        
        // Populate game list from json data
        for (_, gameJSON): (String, JSON) in gamesJSON {
            let game = Game(
                id: UUID(uuidString: gameJSON["id"].stringValue) ?? UUID(),
                steamID: gameJSON["steamID"].intValue,
                igdbID: gameJSON["igdbID"].intValue,
                
                name: gameJSON["name"].stringValue,
                platform: Platform(fromDisplayName: gameJSON["platform"].stringValue),
                status: Status(fromDisplayName: gameJSON["status"].stringValue),
                recency: Recency(fromDisplayName: gameJSON["recency"].stringValue),
                isHidden: gameJSON["isHidden"].boolValue,
                isFavorite: gameJSON["isFavorite"].boolValue,
                
                gameExecutable: URL(string: gameJSON["gameExecutable"].stringValue),
                launcher: gameJSON["launcher"].stringValue,
                
                icon: URL(string: gameJSON["icon"].stringValue),
                header: URL(string: gameJSON["header"].stringValue),
                cover: URL(string: gameJSON["cover"].stringValue),
                screenshots: gameJSON["screenshots"].arrayValue.map { URL(filePath: $0.stringValue) },
                
                description: gameJSON["description"].stringValue,
                genres: gameJSON["genres"].arrayValue.map { $0.stringValue },
                rating: gameJSON["rating"].floatValue,
                releaseDate: dateFormatter.date(from: gameJSON["releaseDate"].stringValue),
                lastPlayed: dateFormatter.date(from: gameJSON["lastPlayed"].stringValue),
                developers: gameJSON["developers"].arrayValue.map { $0.stringValue },
                publishers: gameJSON["publishers"].arrayValue.map { $0.stringValue },
            )
            
            games.append(game)
        }
    } catch {
        AppEnvironment.logger.log("Couldn't read contents of games.json", level: .error)
    }
    
    AppEnvironment.logger.log("Successfully populated games list", level: .info)
    return games
}

func saveGames(_ games: [Game]) {
    let gamesJSONArray = JSON([])
    
    if var gamesArray = gamesJSONArray.arrayObject {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        for game in games {
            var gameJSON = JSON([:])
            
            gameJSON["id"].string = game.id.uuidString
            if game.steamID != nil { gameJSON["steamID"].int = game.steamID }
            if game.igdbID != nil { gameJSON["igdbID"].int = game.igdbID }
            
            if game.name != nil { gameJSON["name"].string = game.name }
            gameJSON["platform"].string = game.platform.displayName
            gameJSON["status"].string = game.status.displayName
            gameJSON["recency"].string = game.recency.displayName
            gameJSON["isHidden"].bool = game.isHidden
            gameJSON["isFavorite"].bool = game.isFavorite
            
            if game.gameExecutable != nil { gameJSON["gameExecutable"].string = game.gameExecutable?.absoluteString }
            if game.launcher != nil { gameJSON["launcher"].string = game.launcher }
            
            if game.icon != nil { gameJSON["icon"].string = game.icon?.absoluteString }
            if game.header != nil { gameJSON["header"].string = game.header?.absoluteString }
            if game.cover != nil { gameJSON["cover"].string = game.cover?.absoluteString }
            gameJSON["screenshots"].arrayObject = game.screenshots.map { $0.absoluteString }
            
            if game.description != nil { gameJSON["description"].string = game.description }
            gameJSON["genres"].arrayObject = game.genres
            if game.rating != nil { gameJSON["rating"].float = game.rating }
            if game.releaseDate != nil { gameJSON["releaseDate"].string = dateFormatter.string(from: game.releaseDate!) }
            if game.lastPlayed != nil { gameJSON["lastPlayed"].string = dateFormatter.string(from: game.lastPlayed!) }
            gameJSON["developers"].arrayObject = game.developers
            gameJSON["publishers"].arrayObject = game.publishers
            
            gamesArray.append(gameJSON.object)
        }
        
        let gamesJSON = JSON(gamesArray)
        
        // Convert JSON to Data
        do {
            let data = try gamesJSON.rawData(options: .prettyPrinted)
            try data.write(to: (getPhoenixDirectory()?.appending(path: "games.json"))!)
        } catch {
            AppEnvironment.logger.log("Error writing game JSON data to disk", level: .error)
        }
    }
}
