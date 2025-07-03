//
//  ImageUtils.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI

/// Loads an image from the file at the given file path.
///
/// If the file at the given file path does not exist or there is an error
/// reading from the file, a placeholder image is returned.
///
/// - Parameters:
/// - filePath: The file path of the image to load.
///
/// - Returns: The image at the given file path, or a placeholder image if the
/// file could not be loaded.
func loadImage(filePath: URL) -> NSImage? {
    do {
        let imageData = try Data(contentsOf: filePath)
        return NSImage(data: imageData)
    } catch {
        AppEnvironment.logger.log("Error loading image: \(error)", level: .error)
        return nil
    }
}
