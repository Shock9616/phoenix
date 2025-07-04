//
//  Logging.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import Foundation

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

protocol Logging {
    /// Print log messages to the debug console
    ///
    /// - Parameters:
    /// - message: The message to print to the console
    /// - level: The level of importance of the message
    func log(_ message: String, level: LogLevel)
}

/// A simple logger for printing verbose log messages to the Xcode
/// debug console while testing
struct ConsoleLogger: Logging {
    func log(_ message: String, level: LogLevel) {
        print("[\(level.rawValue)] \(message)")
    }
}

/// A logger for writting logs to a dedicated log file in a release
/// environment
struct FileLogger: Logging {
    private let logFileURL: URL

    init(filename: String = "log_\(Date()).log") {
        let logsDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Logs", isDirectory: true)

        try? FileManager.default.createDirectory(at: logsDirectory, withIntermediateDirectories: true)

        self.logFileURL = logsDirectory.appendingPathComponent(filename)
    }

    func log(_ message: String, level: LogLevel) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let fullMessage = "[\(timestamp)] [\(level.rawValue) \(message)\n"
        if let data = fullMessage.data(using: .utf8) {
            try? data.append(to: logFileURL)
        }
    }
}

/// A logger dedicated to printing system information at application
/// start
enum StartupLogger {
    static func logAppLaunchInfo(using logger: Logging) {
        let date = ISO8601DateFormatter().string(from: Date())

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"

        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let osVersionString = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"

        logger.log("===== App Launch =====", level: .info)
        logger.log("Timestamp: \(date)", level: .info)
        logger.log("App Version: \(appVersion) (\(buildNumber))", level: .info)
        logger.log("macOS Version: \(osVersionString)", level: .info)
        logger.log("======================", level: .info)
    }
}

private extension Data {
    func append(to fileURL: URL) throws {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            defer { try? fileHandle.close() }
            try fileHandle.seekToEnd()
            try fileHandle.write(contentsOf: self)
        } else {
            try write(to: fileURL)
        }
    }
}
