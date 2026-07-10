//
//  Theme.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 9/07/26.
//

import SwiftUI

/// Controla la preferencia de apariencia del usuario (Sistema / Claro / Oscuro)
enum AppTheme: String, CaseIterable, Identifiable {
    case system = "Sistema"
    case light = "Claro"
    case dark = "Oscuro"
    
    var id: String { rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

/// Colores de marca que se adaptan automáticamente a claro/oscuro
enum Theme {
    static let gradientStart = Color("BrandGradientStart")
    static let gradientEnd = Color("BrandGradientEnd")
    
    static var brandGradient: LinearGradient {
        LinearGradient(
            colors: [gradientStart, gradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
