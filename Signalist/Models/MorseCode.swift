//
//  MorseCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 9/07/26.
//

import Foundation

enum ConversionMode: String, CaseIterable, Identifiable {
    case textToMorse = "Texto → Morse"
    case morseToText = "Morse → Texto"
    var id: String { self.rawValue }
}

struct MorseCode {
    static let dictionary: [Character: String] = [
        "a": ".-", "b": "-...", "c": "-.-.", "d": "-..", "e": ".",
        "f": "..-.", "g": "--.", "h": "....", "i": "..", "j": ".---",
        "k": "-.-", "l": ".-..", "m": "--", "n": "-.", "o": "---",
        "p": ".--.", "q": "--.-", "r": ".-.", "s": "...", "t": "-",
        "u": "..-", "v": "...-", "w": ".--", "x": "-..-", "y": "-.--",
        "z": "--..",
        "0": "-----", "1": ".----", "2": "..---", "3": "...--",
        "4": "....-", "5": ".....", "6": "-....", "7": "--...",
        "8": "---..", "9": "----.",
        ".": ".-.-.-", ",": "--..--", "?": "..--..", "'": ".----.",
        "!": "-.-.--", "/": "-..-.", "(": "-.--.", ")": "-.--.-",
        "&": ".-...", ":": "---...", ";": "-.-.-.", "=": "-...-",
        "+": ".-.-.", "-": "-....-", "_": "..--.-", "\"": ".-..-.",
        "$": "...-..-", "@": ".--.-."
    ]
    
    static let reverseDictionary: [String: Character] = {
        var dict: [String: Character] = [:]
        for (key, value) in dictionary {
            dict[value] = key
        }
        return dict
    }()
    
    static func encode(_ text: String) -> String {
        let lowercased = text.lowercased()
        var result: [String] = []
        
        for character in lowercased {
            if character == " " {
                result.append("/")
            } else if let morse = dictionary[character] {
                result.append(morse)
            }
        }
        
        return result.joined(separator: " ")
    }
    
    static func decode(_ morse: String) -> String {
        let words = morse.components(separatedBy: " / ")
        var result: [String] = []
        
        for word in words {
            let letters = word.split(separator: " ")
            var decodedWord = ""
            for letter in letters {
                if let character = reverseDictionary[String(letter)] {
                    decodedWord.append(character)
                }
            }
            result.append(decodedWord)
        }
        
        return result.joined(separator: " ")
    }
}
