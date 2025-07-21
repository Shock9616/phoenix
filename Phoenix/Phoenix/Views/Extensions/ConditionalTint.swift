//
//  ConditionalTint.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-20.
//

import SwiftUI

extension View {
    @ViewBuilder
    func conditionalTint(_ color: Color) -> some View {
        if #available(macOS 26.0, *) {
            self
        } else {
            self.tint(color)
        }
    }
}
