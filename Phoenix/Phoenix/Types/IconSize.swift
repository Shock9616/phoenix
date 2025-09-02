//
//  IconSize.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2025-08-11.
//

import Foundation

/// An enum representing the available icon sizes in the sidebar
enum IconSize: Double, Identifiable, CaseIterable {
    case small = 24
    case medium = 34
    case large = 40

    var id: IconSize { self }

    var displayName: String {
        switch self {
            case .small: return "Small"
            case .medium: return "Medium"
            case .large: return "Large"
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        let order: [IconSize] = [.small, .medium, .large]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
