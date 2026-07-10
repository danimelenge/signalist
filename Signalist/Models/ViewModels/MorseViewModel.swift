//
//  MorseViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 9/07/26.
//

import Foundation
import Combine
import AppKit

@MainActor
final class MorseViewModel: ObservableObject {
    // Entradas desde la vista
    @Published var inputText: String = ""
    @Published var mode: ConversionMode = .textToMorse
    
    // Salida calculada, la vista solo la observa
    @Published private(set) var outputText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest($inputText, $mode)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .map { text, mode -> String in
                switch mode {
                case .textToMorse:
                    return MorseCode.encode(text)
                case .morseToText:
                    return MorseCode.decode(text)
                }
            }
            .receive(on: RunLoop.main)
            .assign(to: \.outputText, on: self)
            .store(in: &cancellables)
    }
    
    func copyOutputToClipboard() {
        guard !outputText.isEmpty else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(outputText, forType: .string)
    }
    
    func clearAll() {
        inputText = ""
        // outputText se actualiza solo gracias al pipeline de Combine
    }
}
