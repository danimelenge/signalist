//
//  WhatsNewFeature.swift .swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

struct WhatsNewFeature: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
}

extension WhatsNewFeature {
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
    ]
}
