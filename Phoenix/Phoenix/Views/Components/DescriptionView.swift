//
//  DescriptionView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

/// A simple text view with a background to be used for the selected
/// game's description
///
/// - Parameters:
/// - content: The text to be displayed
struct DescriptionView: View {
    private let content: String

    init(_ content: String) {
        self.content = content
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
            Text(content)
                .padding()
        }
    }
}
