//
//  FileUtils.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-08-12.
//

import Foundation

/// Returns the Phoenix application support directory
///
/// - Returns: The URL for the Application support directory/Phoenix.
func getPhoenixDirectory() -> URL? {
    let fileManager = FileManager.default
    let appSupportDirectory = fileManager.urls(
        for: .applicationSupportDirectory, in: .userDomainMask
    )
    .first
    let phoenixDirectory = appSupportDirectory?.appendingPathComponent("Phoenix")
    return phoenixDirectory
}
