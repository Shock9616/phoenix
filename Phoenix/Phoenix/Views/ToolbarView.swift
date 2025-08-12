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
/// - gameViewModel: The view model for communicating with the app's
/// backend
struct ToolbarView: ToolbarContent {
    @ObservedObject var gameViewModel: GameViewModel
    @EnvironmentObject var sheetCoordinator: SheetCoordinator

    var body: some ToolbarContent {
        // Add game button
        ToolbarItem(placement: .primaryAction) {
            // Add game button
            Button(action: {
                sheetCoordinator.formViewModel = GameFormViewModel(mode: .add)
                sheetCoordinator.formViewModel?.onSave = { updatedGame in
                    gameViewModel.addGame(updatedGame)
                }
            }, label: {
                Label(String(localized: "file_AddGame"), systemImage: "plus")
            })
        }
        ToolbarItem(placement: .primaryAction) {
            Picker("Sort By", selection: $gameViewModel.sortMode) {
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
