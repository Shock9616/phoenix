//
//  GameLaunching.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-03.
//

import Foundation

protocol GameLaunching {
    func launch(_ game: Game) throws
}

struct GameLauncherService: GameLaunching {
    func launch(_ game: Game) throws {}

    /// Executes a command in the shell and returns a reference to
    /// the process so that it can be killed later by Phoenix
    ///
    /// - Parameters:
    /// - command: The command to be executed in the shell
    ///
    /// - Throws: An error if there was a problem executing the
    /// command
    ///
    /// - Returns: a reference to the game process
    func shell(_ command: String) throws -> Process {
        let task = Process()

        let devNull = FileHandle(forWritingAtPath: "/dev/null")
        task.standardOutput = devNull
        task.standardError = devNull

        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        AppEnvironment.logger.log("Executing command: '\(command)'", level: .info)
        try task.run()

        return task
    }
}
