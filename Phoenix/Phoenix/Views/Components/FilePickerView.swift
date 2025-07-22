//
//  FilePickerView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-05.
//

import SwiftUI
import UniformTypeIdentifiers

/// The view responsible for picking files, mainly inside the GameFormView
///
/// Presented as a browse button followed by the name of the selected file, or
/// instructions to provide one
///
/// - Parameters:
/// - filePath: The path to the selected file, or nil
/// - type: The type of file that may be selected
struct FilePickerView: View {
    @Binding var filePath: URL?
    let type: UTType
    
    @State private var isPicking = false
    @State private var isTargeted = false
    
    var body: some View {
        HStack {
            Button("Browse") {
                isPicking = true
            }
            if let filePath = filePath {
                Text(filePath.lastPathComponent)
                    .foregroundColor(.secondary)
                    .font(.caption)
            } else {
                Text("Select or drag and drop a file")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .contentShape(Rectangle())
        .onDrop(of: [.fileURL], isTargeted: $isTargeted, perform: handleDrop)
        .fileImporter(
            isPresented: $isPicking,
            allowedContentTypes: [type],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result)
        }
    }
    
    /// Handle file importing
    ///
    /// - Parameters:
    /// - result: The result of the import
    private func handleFileImport(_ result: Result<[URL], Error>) {
        do {
            let selectedURL = try result.get().first
            if selectedURL?.conforms(to: type) == true {
                filePath = selectedURL
            }
        } catch {
            AppEnvironment.logger.log(error.localizedDescription, level: .error)
        }
    }
    
    /// Handle a file being imported via drag-and-drop
    ///
    /// - Parameters:
    /// - providers: The providers for conveying file data when drag-and-dropped
    ///
    /// - Returns: True if the drop is successful, otherwise false
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        
        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil),
                  url.conforms(to: type)
            else {
                return
            }
            
            DispatchQueue.main.async {
                filePath = url
            }
        }
        
        return true
    }
}

extension URL {
    /// Check if the file at the given url conform to the given type
    ///
    /// - Parameters:
    /// - type: The type to check for conformity
    ///
    /// - Returns: True if the file conforms to the given type, otherwise false
    func conforms(to type: UTType) -> Bool {
        (try? resourceValues(forKeys: [.contentTypeKey]))?.contentType?.conforms(to: type) == true
    }
}
