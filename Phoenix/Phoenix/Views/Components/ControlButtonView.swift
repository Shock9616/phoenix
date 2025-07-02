//
//  ControlButtonView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

/// A wrapper around the default `Button` for the app's control
/// buttons (e.x. the "Play" and "Edit Game" buttons)
///
/// - Parameters:
/// - action: a closure defining the behaviour of the button
/// - label: a closure defining the content of the button
struct ControlButtonView<Label: View>: View {
    let action: () -> Void
    let label: () -> Label

    var body: some View {
        Button(action: action, label: {
            label()
                .font(.system(size: 25))
        })
        .cornerRadius(10)
        .buttonStyle(.borderedProminent)
    }
}
