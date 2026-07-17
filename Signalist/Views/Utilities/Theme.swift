//
//  Theme.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 9/07/26.
//

import SwiftUI

// MARK: - App Theme

/// Represents the application's appearance modes
/// available to the user.
enum AppTheme: String, CaseIterable, Identifiable {

    // MARK: - Cases

    case system = "Sistema"
    case light = "Claro"
    case dark = "Oscuro"

    // MARK: - Identifiable

    /// Unique identifier required by SwiftUI.
    var id: String {
        rawValue
    }

    // MARK: - Appearance

    /// Returns the corresponding SwiftUI color scheme.
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil

        case .light:
            return .light

        case .dark:
            return .dark
        }
    }

    // MARK: - Icons

    /// SF Symbol associated with each appearance option.
    var icon: String {
        switch self {
        case .system:
            return "circle.lefthalf.filled"

        case .light:
            return "sun.max.fill"

        case .dark:
            return "moon.fill"
        }
    }

    // NOTE:
    // The selected theme is persisted using AppStorage.
}

// MARK: - Application Theme

/// Centralized design resources used across the application.
enum Theme {

    // MARK: - Brand Colors

    /// Primary gradient start color.
    static let gradientStart = Color("BrandGradientStart")

    /// Primary gradient end color.
    static let gradientEnd = Color("BrandGradientEnd")

    // MARK: - Gradients

    /// Default gradient used throughout the application.
    static var brandGradient: LinearGradient {
        LinearGradient(
            colors: [gradientStart, gradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // TODO:
    // Add additional semantic colors (success, warning, error)
    // for a consistent design system.

    // FIXME:
    // Consider supporting dynamic gradients based on the
    // selected appearance or future themes.
}
