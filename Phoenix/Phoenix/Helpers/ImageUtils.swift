//
//  ImageUtils.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI

/// Loads an image from the file at the given file path.
///
/// If the file at the given file path does not exist or there is an
/// error reading from the file, a placeholder image is returned.
///
/// - Parameters:
/// - filePath: The file path of the image to load.
///
/// - Returns: The image at the given file path, or a placeholder
/// image if the file could not be loaded.
func loadImage(filePath: URL) -> NSImage? {
    do {
        let imageData = try Data(contentsOf: filePath)
        return NSImage(data: imageData)
    } catch {
        AppEnvironment.logger.log("Error loading image: \(error)", level: .error)
        return nil
    }
}

func cacheImage(originalURL: URL?, gameID: UUID, imageType: String) -> URL? {
    guard let originalURL = originalURL else { return nil }

    // Standardized file extension for all cached images
    let targetExtension = "png"
    
    guard let phoenixDir = getPhoenixDirectory() else {
        AppEnvironment.logger.log("Failed to locate Phoenix directory", level: .error)
        return nil
    }
    
    let cacheDir = phoenixDir.appendingPathComponent("cachedImages", isDirectory: true)
    do {
        try FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
    } catch {
        AppEnvironment.logger.log("Failed to create cachedImages directory: \(error)", level: .error)
        return nil
    }
    
    let destURL = cacheDir.appendingPathComponent("\(gameID.uuidString)_\(imageType).\(targetExtension)")
    
    // If already in cache and path matches, return immediately
    if originalURL.path == destURL.path {
        return destURL
    }
    
    guard FileManager.default.fileExists(atPath: originalURL.path) else {
        AppEnvironment.logger.log("Image does not exist at path: \(originalURL)", level: .error)
        return nil
    }
    
    // Load the original image
    guard let image = NSImage(contentsOf: originalURL) else {
        AppEnvironment.logger.log("Failed to load image at path: \(originalURL)", level: .error)
        return nil
    }
    
    // Convert to PNG data
    guard let tiffData = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiffData),
          let pngData = bitmap.representation(using: .png, properties: [:])
    else {
        AppEnvironment.logger.log("Failed to convert image to PNG: \(originalURL)", level: .error)
        return nil
    }
    
    // Write to destination (overwrites if needed)
    do {
        try pngData.write(to: destURL, options: .atomic)
        return destURL
    } catch {
        AppEnvironment.logger.log("Failed to write cached image: \(error)", level: .error)
        return nil
    }
}
