//
//  GameLaunching.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-03.
//

import AppKit
import Foundation

/// An enum to encode the kind of command used to launch a game
enum LaunchMethod: Codable {
    case shell(command: String)
    case appBundle(path: URL)
    case urlScheme(url: String)
}

/// An enum to hold the data used to track/kill a game
enum GameProcessHandle {
    case process(Process)
    case application(NSRunningApplication)
}

protocol GameLaunching {
    /// Executes the appropriate command to launch a game
    ///
    /// - Parameters:
    /// - game: The game to be launched
    ///
    /// - returns: A reference to the launched game's process
    func launch(_ game: Game) throws -> GameProcessHandle?
}

/// A service to manage launching games
struct GameLauncherService: GameLaunching {
    func launch(_ game: Game) throws -> GameProcessHandle? {
        guard let method = game.platform.inferredLaunchMethod(for: game) else {
            throw GameLaunchingError.noLauncherFound(for: game)
        }

        return try launchWithMethod(method)
    }

    /// Launch a game with the appropriate method and return a
    /// process handle to keep track of it
    ///
    /// - Parameters:
    /// - method: The kind of command used to launch the game
    ///
    /// - Returns a GameProcessHandle for the game if it's run as a
    /// shell command or an app bundle, or nil if it's through a
    /// special URL scheme (like Steam)
    private func launchWithMethod(_ method: LaunchMethod) throws -> GameProcessHandle? {
        switch method {
            case .shell(let command):
                return try launchShell(command)
            case .appBundle(let path):
                return try launchAppBundle(at: path)
            case .urlScheme(let url):
                try launchURLScheme(url)
                return nil
        }
    }

    /// Executes a shell command and returns a process handle to
    /// track the game
    ///
    /// - Parameters:
    /// - command: The command to be executed in the shell
    ///
    /// - Throws: An error if there was a problem executing the
    /// command
    ///
    /// - Returns: a GameProcessHandle for keeping track of the
    /// running game, or nil if something goes wrong
    private func launchShell(_ command: String) throws -> GameProcessHandle? {
        let task = Process()

        let devNull = FileHandle(forWritingAtPath: "/dev/null")
        task.standardOutput = devNull
        task.standardError = devNull

        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        AppEnvironment.logger.log("Launching shell command: '\(command)'", level: .info)
        try task.run()

        return .process(task)
    }

    /// Launches the app bundle at the given URL and returns a
    /// process handle to track the game
    ///
    /// - Parameters:
    /// - path: The URL to the app bundle to be launched
    ///
    /// - Returns: A GameProcessHandle for keeping track of the
    /// running game, or nil if something goes wrong
    private func launchAppBundle(at path: URL) throws -> GameProcessHandle? {
        AppEnvironment.logger.log("Launching app bundle: \(path)", level: .info)

        if let app = try? NSWorkspace.shared.launchApplication(at: path, options: [], configuration: [:]) {
            return .application(app)
        }

        return nil
    }

    /// Executes a shell command to open the given URL string
    ///
    /// - Parameters:
    /// - urlString: The URL to be opened
    ///
    /// - Throws: An error if there was a problem executing the
    /// command
    private func launchURLScheme(_ urlString: String) throws {
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [urlString]

        AppEnvironment.logger.log("Launching URL scheme: \(urlString)", level: .info)
        try task.run()
    }
}

/// A custom error enum for errors related to launching games
enum GameLaunchingError: Error, CustomStringConvertible {
    case noLauncherFound(for: Game)

    public var description: String {
        switch self {
            case .noLauncherFound(for: let game):
                return "No launcher found for game: \(game)"
        }
    }
}
