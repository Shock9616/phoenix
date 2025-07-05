//
//  ToolbarView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-04.
//

import SwiftUI

struct ToolbarView: ToolbarContent {
    @ObservedObject var viewModel: GameViewModel

    var body: some ToolbarContent {
        // Add game button
        ToolbarItem(placement: .primaryAction) {
            // Add game button
            Button(action: {}, label: {
                Label(String(localized: "file_AddGame"), systemImage: "plus")
            })
        }
        ToolbarItem(placement: .primaryAction) {
            Picker("Sort By", selection: $viewModel.sortMode) {
                ForEach(SortMode.allCases) { mode in
                    Label {
                        Text(mode.displayName)
                    } icon: {
                        Image(systemName: mode.symbol)
                    }
                    .tag(mode)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: 60)
            .overlay(RoundedRectangle(cornerRadius: 6)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
