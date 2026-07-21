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
    @Published var inputText: String = ""
    @Published var mode: ConversionMode = .textToMorse
    @Published private(set) var outputText: String = ""
    
    /// Controla si se reproduce el sonido al convertir. Persiste en UserDefaults.
    @Published var isSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEnabled, forKey: "isSoundEnabled")
        }
    }
    
    let soundPlayer = MorseSoundPlayer()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.isSoundEnabled = UserDefaults.standard.object(forKey: "isSoundEnabled") as? Bool ?? true
        setupBindings()
    }
    
    private func setupBindings() {
        let conversion = Publishers.CombineLatest($inputText, $mode)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .map { text, mode -> String in
                switch mode {
                case .textToMorse:
                    return MorseCode.encode(text)
                case .morseToText:
                    return MorseCode.decode(text)
                }
            }
            .share()
        
        conversion
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.outputText = result
            }
            .store(in: &cancellables)
        
        // Reproduce sonido solo cuando se genera código Morse (Texto → Morse)
        conversion
            .combineLatest($mode)
            .filter { _, mode in mode == .textToMorse }
            .map { result, _ in result }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] morse in
                guard let self, self.isSoundEnabled, !morse.isEmpty else { return }
                self.soundPlayer.play(morse: morse)
            }
            .store(in: &cancellables)
    }
    
    func copyOutputToClipboard() {
        guard !outputText.isEmpty else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(outputText, forType: .string)
    }
    
    func replayCurrentSound() {
        guard mode == .textToMorse, !outputText.isEmpty else { return }
        soundPlayer.play(morse: outputText)
    }
    
    func clearAll() {
        soundPlayer.stop()
        inputText = ""
    }
}
