//
//  SimoneSayings.swift
//  Simone Says
//
//  Created by Matt Larsen on 5/5/21.
//

import Foundation

struct simone {
    
    var title: String
    var body: String
    
    enum says:String, CaseIterable {
//        case webview
        case color = """
            ORIGINAL
            
            This is the original memory game. Try to recall as much of the sequence as possible.
            """
        case colorBlind = """
            COLORBLIND
            
            Memory game without colors. Try to recall as much of the sequence as possible.
            """
        case blind = """
            BLIND
            
            No colors whatsoever, just shapes that light up in sequence around the circle. Try to remember the sequence without the aid of color or lightness.
            """
        case colorCheat = """
            COLOR FOR CHEATERS
            
            The original memory game with the full sequence given.
            """
        
        case liarsCheat = """
            LIAR'S CHEAT
            
            The names are lies but the colors are right.
            Can you make the right choice?
            """
        
        case brainTwist = """
            BRAIN TWIST
            
            Choose any color in the sequence except for the one given.
            """
        
        case spokenWord = """
        SPOKEN WORD
        
        Listen and try to follow the sequence using only vocal clues.
        """
        
        case colorBlindCheat = """
            COLORBLIND FOR CHEATERS
            
            Black and white with full sequence given.
            """
        case colorTornado = """
            COLOR TORNADO
            
            Rotation after every selection for more challenging recall.
            """
        case colorBlindTornado = """
            COLORBLIND TORNADO
            
            Rotation after every selection for more challenging recall
            but in black and white.
            """
        case constantPattern = """
            CONSTANT PATTERN
            
            Try as you might, you will never escape, but with enough patience you might memorize all 10,000 colors of this pattern.
            """
        case multiPlayer = """
            MULTIPLAYER
            
            Build your opponent's sequence one-by-one while you pass the device back and forth. 
            """
        
        case patternTap = """
            MULTIPLAYER 2
            
            Tapping a new pattern each time, you and a partner will take turns trying to remember as many of a sequence as possible.
            """
        case pi = """
            DIGITS OF PI
            
            The ratio between the radius and circumference of a circle, a nonrepeating and infinite decimal, yours to memorize and recall.
            """
        case webview
        case nothing
    }
}

