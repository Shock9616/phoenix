//
//  AppEnvironment.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import Foundation

enum AppEnvironment {
    static let logger: Logging = {
        #if DEBUG
        return ConsoleLogger()
        #else
        return FileLogger()
        #endif
    }()
}
