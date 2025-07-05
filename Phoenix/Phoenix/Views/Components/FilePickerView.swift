//
//  FilePickerView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-05.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: View {
    let title: String
    @Binding var filePath: URL?
    let type: UTType
    
    @State private var isPicking = false
    @State private var isTargeted = false
    
    var body: some View {
        HStack {
            fileInfoView
            Spacer()
            Button("Browse") {
                isPicking = true
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
    
    private var fileInfoView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
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
    }
    
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
    func conforms(to type: UTType) -> Bool {
        (try? resourceValues(forKeys: [.contentTypeKey]))?.contentType?.conforms(to: type) == true
    }
}
