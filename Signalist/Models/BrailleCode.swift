//
//  BrailleCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 22/07/26.
//

import Foundation

/// Convierte texto en español/inglés básico (sin acentos) a Braille Unicode (Grado 1) y viceversa.
struct BrailleCode {
    
    // MARK: - Letter dictionary (a–z)
    
    static let letterDictionary: [Character: Character] = [
        "a": "⠁", "b": "⠃", "c": "⠉", "d": "⠙", "e": "⠑",
        "f": "⠋", "g": "⠛", "h": "⠓", "i": "⠊", "j": "⠚",
        "k": "⠅", "l": "⠇", "m": "⠍", "n": "⠝", "o": "⠕",
        "p": "⠏", "q": "⠟", "r": "⠗", "s": "⠎", "t": "⠞",
        "u": "⠥", "v": "⠧", "w": "⠺", "x": "⠭", "y": "⠽",
        "z": "⠵"
    ]
    
    // MARK: - Digit dictionary (0–9)
    
    /// En Braille, los números se representan con el "signo numérico" seguido
    /// de las letras a–j (1=a, 2=b, ... 9=i, 0=j).
    static let digitDictionary: [Character: Character] = [
        "1": "⠁", "2": "⠃", "3": "⠉", "4": "⠙", "5": "⠑",
        "6": "⠋", "7": "⠛", "8": "⠓", "9": "⠊", "0": "⠚"
    ]
    
    // MARK: - Punctuation dictionary
    
    static let punctuationDictionary: [Character: Character] = [
        ".": "⠲", ",": "⠂", "?": "⠦", "!": "⠖",
        "'": "⠄", "-": "⠤", ":": "⠒", ";": "⠆"
    ]
    
    // MARK: - Special symbols
    
    static let numberSign: Character = "⠼"     // antecede a una secuencia de dígitos
    static let capitalSign: Character = "⠠"    // antecede a una letra mayúscula
    static let brailleSpace: Character = "⠀"   // espacio en blanco Braille (U+2800)
    
    // MARK: - Reverse dictionaries
    
    private static let reverseLetterDictionary: [Character: Character] = {
        Dictionary(uniqueKeysWithValues: letterDictionary.map { ($1, $0) })
    }()
    
    private static let reverseDigitDictionary: [Character: Character] = {
        Dictionary(uniqueKeysWithValues: digitDictionary.map { ($1, $0) })
    }()
    
    private static let reversePunctuationDictionary: [Character: Character] = {
        Dictionary(uniqueKeysWithValues: punctuationDictionary.map { ($1, $0) })
    }()
    
    // MARK: - Encode (Texto → Braille)
    
    static func encode(_ text: String) -> String {
        var result = ""
        var isNumberModeActive = false
        
        for character in text {
            if character == " " {
                result.append(brailleSpace)
                isNumberModeActive = false
                continue
            }
            
            if character.isNumber {
                if !isNumberModeActive {
                    result.append(numberSign)
                    isNumberModeActive = true
                }
                if let braille = digitDictionary[character] {
                    result.append(braille)
                }
                continue
            }
            
            isNumberModeActive = false
            
            if character.isUppercase {
                let lowercased = Character(character.lowercased())
                if let braille = letterDictionary[lowercased] {
                    result.append(capitalSign)
                    result.append(braille)
                }
                continue
            }
            
            if let braille = letterDictionary[character] {
                result.append(braille)
                continue
            }
            
            if let braille = punctuationDictionary[character] {
                result.append(braille)
                continue
            }
            
            // Caracter no soportado: se omite
        }
        
        return result
    }
    
    // MARK: - Decode (Braille → Texto)
    
    static func decode(_ braille: String) -> String {
        var result = ""
        var isNumberModeActive = false
        var isNextCapitalized = false
        
        for symbol in braille {
            if symbol == brailleSpace {
                result.append(" ")
                isNumberModeActive = false
                isNextCapitalized = false
                continue
            }
            
            if symbol == numberSign {
                isNumberModeActive = true
                continue
            }
            
            if symbol == capitalSign {
                isNextCapitalized = true
                continue
            }
            
            if isNumberModeActive, let digit = reverseDigitDictionary[symbol] {
                result.append(digit)
                continue
            }
            
            if let letter = reverseLetterDictionary[symbol] {
                if isNextCapitalized {
                    result.append(Character(letter.uppercased()))
                    isNextCapitalized = false
                } else {
                    result.append(letter)
                }
                isNumberModeActive = false
                continue
            }
            
            if let punctuation = reversePunctuationDictionary[symbol] {
                result.append(punctuation)
                isNumberModeActive = false
                continue
            }
            
            // Símbolo no reconocido: se omite
        }
        
        return result
    }
}
// MARK: - Conversion Mode

enum BrailleConversionMode: String, CaseIterable, Identifiable {
    case textToBraille = "Texto → Braille"
    case brailleToText = "Braille → Texto"
    var id: String { rawValue }
}
