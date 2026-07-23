//
//  RootView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 22/07/26.
//

import SwiftUI

// MARK: - Root View

/// Vista principal de la aplicación.
/// Contiene la navegación mediante pestañas entre
/// los diferentes conversores disponibles.
struct RootView: View {

    // MARK: - Body

    var body: some View {
        TabView {

            // MARK: Morse Converter

            ContentView()
                .tabItem {
                    Label(
                        "Morse",
                        systemImage: "dot.radiowaves.left.and.right"
                    )
                }

            // MARK: Braille Converter

            BrailleView()
                .tabItem {
                    Label(
                        "Braille",
                        systemImage: "hand.point.up.braille.fill"
                    )
                }

            // TODO:
            // Agregar futuras herramientas de conversión.
            //
            // Ejemplos:
            // • ASCII
            // • Binario
            // • Base64
            // • Código César
            // • NATO Phonetic Alphabet
            // • Código QR
        }

        // FIXME:
        // Si el número de conversores aumenta considerablemente,
        // evaluar reemplazar TabView por NavigationSplitView
        // o una barra lateral para mejorar la escalabilidad.
    }
}

// MARK: - Previews

#Preview {
    RootView()
        .environmentObject(HelpCenter())
}
