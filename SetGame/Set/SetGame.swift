//
//  SetGame.swift
//  SetGame
//
//  Created by Nicholas Bonet on 9/30/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import Foundation

class SetGame {
    
    public var score = 0
    
    // Array for the main deck, cards on screen currently, and cards that are presently selected.
    public var setDeck = [SetCard]()
    public var setCardsOnScreen = [SetCard]()
    public var setCardsSekected = [SetCard]()
    
    public func cardTouched(at index: Int) {
        
    }
    
    public func resetGame() {
        
    }
    
    public func addThreeCards() {
        score.changeScore(value: -1)
    }
    
    public init() {
        buildSetDeck()
        
        // Since the cards are shuffled on deck build, take the first 24 from the deck
        // and assign them to setCardsOnScreen. (12 visible, 12 hidden)
        for index in 0...23 {
            setCardsOnScreen.append(setDeck.remove(at: index))
        }
    }
    
    // Assembles the Set deck of all possible combinations of attributes, and adds the cards to the main deck.
    private func buildSetDeck() {
        for color in SetCard.Coloring.all {
            for shade in SetCard.Shade.all {
                for shape in SetCard.Shape.all {
                    for index in 1...3 {
                        setDeck.append(SetCard(color: color, shade: shade, shape: shape, count: index))
                    }
                }
            }
        }        
        setDeck.shuffle()
    }
}

extension Int {
    public mutating func changeScore(value: Int) {
        if (value > 0 || self >= abs(value) ) { self += value }
    }
}
