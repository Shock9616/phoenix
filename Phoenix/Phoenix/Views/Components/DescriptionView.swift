//
//  DescriptionView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import ExpandableText
import SwiftUI

/// A custom view for displaying the description of the selected game
///
/// Presented as a regular Text view displayed over a rounded
/// rectangle to differentiate it from the background
///
/// - Parameters:
/// - content: The text to be displayed
struct DescriptionView: View {
    private let content: String

    init(_ content: String) {
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
            ExpandableText(content)
                .font(.system(size: 14.5))
                .buttonFont(Font.system(size: 13))
                .buttonColor(Color.accentColor)
                .lineLimit(7)
                .trimMultipleNewlinesWhenTruncated(false)
                .lineSpacing(3.5)
                .padding()
        }
    }
}
