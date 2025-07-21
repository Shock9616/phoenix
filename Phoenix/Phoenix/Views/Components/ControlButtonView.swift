//
//  ControlButtonView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

/// A wrapper around the default Button for the app's control buttons
///
/// Adds a more prominent background to the buttons and increases
/// the default font size of the label
///
/// - Parameters:
/// - action: a closure defining the behaviour of the button
/// - label: a closure defining the content of the button
struct ControlButtonView<Label: View>: View {
    let action: () -> Void
    let label: () -> Label

    var body: some View {
        if #available(macOS 26.0, *) {
            tahoe
        } else {
            sequoia
        }
    }

    var tahoe: some View {
        Button(action: action, label: {
            label()
                .font(.system(size: 25))
                .foregroundColor(.accentColor)
        })
        .cornerRadius(40)
        .buttonStyle(.bordered)
    }

    var sequoia: some View {
        Button(action: action, label: {
            label()
                .font(.system(size: 25))
        })
        .cornerRadius(10)
        .buttonStyle(.borderedProminent)
    }
}
