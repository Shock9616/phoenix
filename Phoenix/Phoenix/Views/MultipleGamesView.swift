//
//  MultipleGamesView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

struct MultipleGamesView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        Group {
            Image("GameStackIcon")
                .font(.system(size: 80))

            Text("\(viewModel.selectedGameIDs.count) Games Selected")
                .font(.title)
                .fontWeight(.semibold)

            HStack {
                Button(action: {}, label: {
                    Text("Hide Games")
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                )

                Button(action: {}, label: {
                    Text("Delete Games")
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .foregroundColor(.gray)
    }
}
