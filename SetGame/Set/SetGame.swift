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
    
    // Array for the main deck, cards on screen currently, and dictionary for the cards that are presently selected.
    public var setDeck = [SetCard]()
    public var setCardsOnScreen: [Int : SetCard] = [:]
    public var setCardsSelected: [Int : SetCard] = [:]
    
    public func cardTouched(at index: Int) {
        if (!isCardSelected(at: index) && setCardsSelected.keys.count < 3) {
            cardSelected(at: index)
        } else if (setCardsSelected.keys.count == 3) {
                if (isSet()) {
                    
                }
                else {
                    setCardsSelected.forEach { setCardsOnScreen[$0] = $1 }
                    setCardsSelected.removeAll()
                }
                cardSelected(at: index)
            }
        else if (setCardsSelected.keys.count < 3) { setCardsOnScreen[index] = setCardsSelected.removeValue(forKey: index) }
    }
    
    public func isCardSelected(at index: Int) -> Bool {
        return setCardsSelected.keys.contains(index)
    }
    
    public func checkMatched(at index: Int) -> MatchState {
        if (setCardsSelected.keys.count < 3) { return MatchState.unchecked }
        else if (isCardSelected(at: index) && setCardsSelected.keys.count == 3) {
            return isSet() ? MatchState.matched : MatchState.unmatched
        }
        else { return MatchState.unmatched }
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
            setCardsOnScreen[index] = setDeck.removeFirst()
        }
    }
    
    private func isSet() -> Bool {
        return false
    }
    
    private func cardSelected(at index: Int) {
        setCardsSelected[index] = setCardsOnScreen.removeValue(forKey: index)
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
