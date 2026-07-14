//
//  WhatsNewFeature.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

// MARK: - What's New Feature Model

/// Represents a single feature displayed in the
/// What's New screen.
struct WhatsNewFeature: Identifiable {

    // MARK: - Properties

    /// Unique identifier used by SwiftUI.
    let id = UUID()

    /// SF Symbol representing the feature.
    let icon: String

    /// Accent color for the feature icon.
    let iconColor: Color

    /// Feature title.
    let title: String

    /// Short description explaining the feature.
    let description: String
}

// MARK: - Default Features

extension WhatsNewFeature {

    /// Features displayed in the current application version.
    static let currentFeatures: [WhatsNewFeature] = [

        WhatsNewFeature(
            icon: "dot.radiowaves.left.and.right",
            iconColor: .blue,
            title: "Conversión instantánea",
            description: "Escribe texto y obtén el código Morse al instante, sin botones extra."
        ),

        WhatsNewFeature(
            icon: "arrow.left.arrow.right",
            iconColor: .indigo,
            title: "Doble dirección",
            description: "Convierte de texto a Morse o de Morse a texto con un solo toque."
        ),

        WhatsNewFeature(
            icon: "circle.lefthalf.filled",
            iconColor: .purple,
            title: "Modo claro y oscuro",
            description: "Elige tu apariencia favorita o deja que Signalist siga al sistema."
        ),

        WhatsNewFeature(
            icon: "doc.on.doc",
            iconColor: .green,
            title: "Copiar con un clic",
            description: "Copia el resultado al portapapeles y pégalo donde lo necesites."
        )

        // TODO:
        // Add new features here for future application releases.
    ]

    // NOTE:
    // The What's New screen automatically updates when new
    // items are added to the currentFeatures array.

    // FIXME:
    // Consider loading the feature list from a local JSON file
    // or remote configuration to simplify maintenance.
}
