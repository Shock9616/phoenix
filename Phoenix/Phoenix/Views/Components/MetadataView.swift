//
//  MetadataView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

/// A custom view for displaying the metadata of the selected game
struct MetadataView: View {
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
            VStack {
                MetadataSectionView(section: "Last Played", value: "December 9, 2024")
            }
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
