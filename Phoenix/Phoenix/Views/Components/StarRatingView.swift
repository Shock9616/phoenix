//
//  StarRatingView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-03.
//

import SwiftUI

/// A simple view for displaying a rating out of 5 as a series of
/// filled, partly filled, or unfilled stars
///
/// - Parameters
/// - rating: A binding to a float that represents the rating to be
/// displayed
struct StarRatingView: View {
    @Binding var rating: Float

    private var filledStars: Int { Int(self.rating) }
    private var halfFilledStars: Int { Int((self.rating.truncatingRemainder(dividingBy: 1)) * 2) }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< 5) { index in
                // Create a clickable star
                GeometryReader { geometry in
                    Image(systemName: self.starImage(for: index))
                        .foregroundColor(.orange)
                        .font(.system(size: 30))
                        .contentShape(Rectangle())
                        .gesture(
                            // Detect where on the star is clicked
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    let clickX = value.location.x
                                    let width = geometry.size.width
                                    let clickedHalf: Float = clickX < width / 2 ? 0.5 : 1
                                    self.rating = Float(index) + clickedHalf
                                }
                        )
                }
                .frame(width: 30, height: 30)
            }
        }
        .padding(.horizontal)
        .offset(y: -4)
    }

    /// Get the systemName for the appropriate star for the given
    /// index
    ///
    /// - Parameters
    /// - index: The index of the star in the view
    ///
    /// - returns: A string contining the systemName for the star
    private func starImage(for index: Int) -> String {
        if index < self.filledStars {
            return "star.fill"
        } else if index < self.filledStars + self.halfFilledStars {
            return "star.lefthalf.fill"
        } else {
            return "star"
        }
    }
}
