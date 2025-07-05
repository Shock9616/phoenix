//
//  HeaderView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-07-02.
//

import SwiftUI

/// A view for presenting a header image in the detail view
///
/// Presented as a full-width image that stretches if scrolled
/// upwards, and blurs as it is scrolled downwards
///
/// - Parameters:
/// - image: The image to display as the header
struct HeaderView: View {
    let image: Image
    let height: CGFloat
    
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
        .frame(height: height)
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
