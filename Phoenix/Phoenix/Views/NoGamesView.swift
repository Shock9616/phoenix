//
//  NoGamesView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-08-12.
//

import SwiftUI

struct NoGamesView: View {
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 80))

            Text("No Games Selected")
                .font(.title)
                .fontWeight(.semibold)

            Text("Select one or use the + button to add a new one!")
        }
        .foregroundColor(.secondary)
    }
}
