//
//  ToolbarView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-04.
//

import SwiftUI

/// The toolbar contents for the sidebar
///
/// Contains the add game button and the sorting mode picker
///
/// - Parameters:
/// - viewModel: The viewModel for communicating with the app's
/// backend
struct ToolbarView: ToolbarContent {
    @ObservedObject var viewModel: GameViewModel
    @State private var formViewModel: GameFormViewModel?

    var body: some ToolbarContent {
        // Add game button
        ToolbarItem(placement: .primaryAction) {
            // Add game button
            Button(action: {
                formViewModel = GameFormViewModel(mode: .add)
                formViewModel?.onSave = { updatedGame in
                    viewModel.addGame(updatedGame)
                }
            }, label: {
                Label(String(localized: "file_AddGame"), systemImage: "plus")
            })
            .sheet(item: $formViewModel) { vm in
                GameFormView(viewModel: vm)
                    .frame(width: 800)
                    .padding()
            }
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
