//
//  AppEnvironment.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import Foundation

/// Global environment struct for holding app-wide dependencies such
/// as logging
final class AppEnvironment {
    static let logger: Logging = {
        #if DEBUG
        return ConsoleLogger()
        #else
        return FileLogger()
        #endif
    }()
}
