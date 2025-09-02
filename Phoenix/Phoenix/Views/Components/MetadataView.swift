//
//  MetadataView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

/// A custom view for displaying the metadata of the selected game
///
/// Presented as a list of titles and values for each metadata
/// section displayed over a rounded rectangle to differentiate it
/// from the app's background
///
/// - Parameters:
/// - metadata: A list of string tuple pairs representing the section
/// title first, and the section value second
struct MetadataView: View {
    private let metadata: [(String, String)]

    init(_ metadata: [(String, String)]) {
        self.metadata = metadata
    }

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(metadata, id: \.0) { section, value in
                    MetadataSectionView(section: section, value: value)
                }
            }
            .font(.system(size: 14.5))
            .padding()
        }
    }
}

/// A small view to display one section of metadata
///
/// Presented as a title over a dimmed value
struct MetadataSectionView: View {
    let section: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(section)
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
