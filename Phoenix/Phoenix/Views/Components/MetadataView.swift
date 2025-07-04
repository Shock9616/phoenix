//
//  MetadataView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

/// A custom view for displaying the metadata of the selected game
struct MetadataView: View {
    private let metadata: [(String, String)]

    init(_ metadata: [(String, String)]) {
        self.metadata = metadata
    }

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
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
