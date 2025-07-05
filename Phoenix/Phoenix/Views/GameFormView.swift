//
//  GameFormView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-05.
//

import SwiftUI
import UniformTypeIdentifiers

struct GameFormView: View {
    @ObservedObject var viewModel: GameFormViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            // Name input
            HStack {
                Text("Name")
                TextField("", text: $viewModel.name)
            }
            .padding()

            // Icon input
            FilePickerView(title: "Icon", filePath: $viewModel.icon, type: .image)
                .padding()

            // Platform input
            Picker("Platform", selection: $viewModel.platform) {
                ForEach(Platform.allCases) { platform in
                    Text(platform.displayName)
                }
            }
            .padding()

            // Status input
            Picker("Status", selection: $viewModel.status) {
                ForEach(Status.allCases) { status in
                    Text(status.displayName)
                }
            }
            .padding()
        }
    }
}

#Preview {
    GameFormView(viewModel: GameFormViewModel(mode: .add))
}
