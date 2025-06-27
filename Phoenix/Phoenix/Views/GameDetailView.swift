//
//  GameDetailView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-06-26.
//

import SwiftUI

/// The main detail view of the app
///
/// Displays all the information about the game, as well as the play
/// and edit buttons
///
/// Parameters:
/// - viewModel: The view model for communicating with the app's
/// backend
struct GameDetailView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ScrollView {
            HeaderView(image: Image("PlaceholderImage"))

            VStack(alignment: .leading, spacing: 10) {
                Text("Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.")
                Text("Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.")
                Text("Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.")
                Text("Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.")
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

/// A special view for the Header image that provides some subtle
/// effects when scrolling
///
/// - Parameters:
/// - image: The image to display as the header
struct HeaderView: View {
    let image: Image

    var body: some View {
        GeometryReader { geometry in
            image
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: self.getHeaderHeight(geometry))
                .blur(radius: self.getHeaderBlurRadius(geometry))
                .clipped()
                .offset(x: 0, y: self.getHeaderOffset(geometry))
        }
        .frame(height: 300)
    }

    /// Get the pixel offset of the user's scrolling
    ///
    /// - Parameters:
    /// - geometry: The geometry object to use in offset calculations
    ///
    /// - Returns: The pixel offset of the user's scrolling
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }

    /// Get the offset of the image based on the scoll offset
    ///
    /// - Parameters:
    /// - geometry: The geometry object to use in offset calculations
    ///
    /// - Returns: The pixel offset of the image
    private func getHeaderOffset(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)

        if offset > 0 {
            return -offset
        }

        return 0
    }

    /// Calculate the height of the header image
    ///
    /// - Parameters:
    /// - geometry: The geometry object to use in offset calculations
    ///
    /// - Returns: The height of the header image
    private func getHeaderHeight(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }

    /// Get the blur radius of the header image
    ///
    /// - Parameters:
    /// - geometry: The geometry object to use in offset calculations
    ///
    /// - Returns: The blur radius of the header image
    private func getHeaderBlurRadius(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY

        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height

        return blur * 6
    }
}

#Preview {
    GameDetailView(viewModel: GameViewModel())
}
