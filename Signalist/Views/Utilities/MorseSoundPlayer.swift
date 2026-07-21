//
//  MorseSoundPlayer.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 21/07/26.
//

import AVFoundation

@MainActor
final class MorseSoundPlayer: ObservableObject {
    @Published private(set) var isPlaying: Bool = false
    
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let frequency: Double = 600.0
    private let unit: Double = 0.08
    
    /// Formato real que usa el hardware de salida (evita desajustes de sample rate)
    private var format: AVAudioFormat
    
    init() {
        // Usa el formato nativo del mixer/salida, no uno inventado
        format = engine.mainMixerNode.outputFormat(forBus: 0)
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        
        prepareEngine()
    }
    
    private func prepareEngine() {
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print("⚠️ Error al iniciar AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    func play(morse: String) {
        stop()
        
        guard !morse.isEmpty else { return }
        
        // Si el motor se detuvo por cualquier razón, reinícialo
        if !engine.isRunning {
            prepareEngine()
        }
        
        guard let buffer = buildBuffer(for: morse) else {
            print("⚠️ No se pudo generar el buffer de audio")
            return
        }
        
        isPlaying = true
        player.scheduleBuffer(buffer, at: nil, options: []) { [weak self] in
            Task { @MainActor in
                self?.isPlaying = false
            }
        }
        player.play()
    }
    
    func stop() {
        player.stop()
        isPlaying = false
    }
    
    // MARK: - Buffer generation
    
    private func buildBuffer(for morse: String) -> AVAudioPCMBuffer? {
        let sampleRate = format.sampleRate
        var samples: [Float] = []
        let fadeSamples = Int(sampleRate * 0.005)
        
        func appendTone(duration: Double) {
            let count = Int(sampleRate * duration)
            guard count > 0 else { return }
            for i in 0..<count {
                let t = Double(i) / sampleRate
                var amplitude: Float = 0.5
                if i < fadeSamples {
                    amplitude *= Float(i) / Float(max(fadeSamples, 1))
                } else if i > count - fadeSamples {
                    amplitude *= Float(count - i) / Float(max(fadeSamples, 1))
                }
                samples.append(Float(sin(2.0 * .pi * frequency * t)) * amplitude)
            }
        }
        
        func appendSilence(duration: Double) {
            let count = Int(sampleRate * duration)
            guard count > 0 else { return }
            samples.append(contentsOf: [Float](repeating: 0, count: count))
        }
        
        for symbol in morse {
            switch symbol {
            case ".":
                appendTone(duration: unit)
                appendSilence(duration: unit)
            case "-":
                appendTone(duration: unit * 3)
                appendSilence(duration: unit)
            case " ":
                appendSilence(duration: unit * 2)
            case "/":
                appendSilence(duration: unit * 6)
            default:
                break
            }
        }
        
        guard !samples.isEmpty else { return nil }
        
        // Construye el buffer respetando el número real de canales del formato (mono o estéreo)
        let channelCount = Int(format.channelCount)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(samples.count))
        else { return nil }
        
        buffer.frameLength = buffer.frameCapacity
        
        guard let channelData = buffer.floatChannelData else { return nil }
        for channel in 0..<channelCount {
            for (index, sample) in samples.enumerated() {
                channelData[channel][index] = sample
            }
        }
        
        return buffer
    }
}
