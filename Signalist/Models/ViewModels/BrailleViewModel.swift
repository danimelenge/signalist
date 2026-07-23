//
//  BrailleViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 22/07/26.
//

import Foundation
import Combine
import AppKit

/// ViewModel encargado de gestionar la lógica del conversor Braille.
/// Convierte automáticamente entre texto y Braille mediante Combine.
@MainActor
final class BrailleViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Texto ingresado por el usuario.
    @Published var inputText: String = ""

    /// Modo de conversión seleccionado.
    @Published var mode: BrailleConversionMode = .textToBraille

    /// Resultado generado de la conversión.
    @Published private(set) var outputText: String = ""

    // MARK: - Private Properties

    /// Almacena las suscripciones de Combine.
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        setupBindings()
    }

    // MARK: - Bindings

    /// Configura las suscripciones para actualizar automáticamente
    /// el resultado cuando cambian el texto o el modo de conversión.
    private func setupBindings() {
        Publishers.CombineLatest($inputText, $mode)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .map { text, mode -> String in
                switch mode {
                case .textToBraille:
                    return BrailleCode.encode(text)

                case .brailleToText:
                    return BrailleCode.decode(text)
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.outputText = result
            }
            .store(in: &cancellables)

        // TODO:
        // Agregar una opción para habilitar o deshabilitar
        // la conversión automática desde la configuración.

        // FIXME:
        // Si en el futuro la conversión soporta textos muy grandes,
        // considerar mover el procesamiento a un Task o cola
        // en segundo plano para evitar bloquear la interfaz.
    }

    // MARK: - Clipboard

    /// Copia el resultado al portapapeles de macOS.
    func copyOutputToClipboard() {
        guard !outputText.isEmpty else { return }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(outputText, forType: .string)
    }

    // MARK: - Actions

    /// Limpia el texto de entrada y reinicia la conversión.
    func clearAll() {
        inputText = ""

        // TODO:
        // Agregar una acción para intercambiar automáticamente
        // entre "Texto → Braille" y "Braille → Texto".
    }
}
