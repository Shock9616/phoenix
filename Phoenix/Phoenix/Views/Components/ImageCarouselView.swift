//
//  ImageCarouselView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-04.
//

import SwiftUI

struct ImageCarouselView: View {
    let images: [URL]

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(images, id: \.self) { screenshot in
                    AsyncImage(url: screenshot) { phase in
                        switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(7.5)
                            case .failure:
                                Color.gray
                                    .overlay(Text("Error").foregroundColor(.white))
                            case .empty:
                                ProgressView()
                            @unknown default:
                                EmptyView()
                        }
                    }
                    .frame(width: 355, height: 200)
                }
            }
        }
        .mask(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.white, location: 0.95),
                    .init(color: Color.clear, location: 1.0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(7.5)
    }
}
