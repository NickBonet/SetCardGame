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
        // If the card's not already selected AND there are less than 3 cards selected, select the card.
        if (!isCardSelected(at: index) && setCardsSelected.keys.count < 3) {
            cardSelected(at: index)
        }
        // If there are 3 selected cards already, time to do some Set checking.
        else if (setCardsSelected.keys.count == 3) {
                // If there is a Set, replace the cards with new ones from the main deck.
                if (isSet()) {
                    // If the selected card is not currently part of the match, select the card and cleanup the matched cards.
                    if (!setCardsSelected.keys.contains(index)) {
                        cardSelected(at: index)
                        setCardsSelected.forEach { if ($0.key != index) { cleanupSelected(for: $0.key) } }
                    } else { // If the card selected is part of the match, ignore and just cleanup the matched cards.
                        setCardsSelected.forEach { cleanupSelected(for: $0.key) }
                    }
                    score.changeScore(value: 3)
                }
                // If there's not a Set, deselect the cards and select the card at index.
                else {
                    setCardsSelected.forEach { setCardsOnScreen[$0] = $1 }
                    setCardsSelected.removeAll()
                    score.changeScore(value: -2)
                    cardSelected(at: index)
                }
            }
        // If there's less than 3 cards selected, go ahead and deselect the current card.
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
        // TODO: Finish this
    }
    
    public func addThreeCards() {
        // TODO: Finish this
        score.changeScore(value: -1)
        //if (setDeck.count >= 3 ) {
        //}
    }
    
    public init() {
        buildSetDeck()
        // Since the cards are shuffled on deck build, take the first 12 from the deck
        // and assign them to setCardsOnScreen.
        for index in 0...11 {
            setCardsOnScreen[index] = setDeck.removeFirst()
        }
    }
    
    private func isSet() -> Bool {
        // TODO: Implement actual matching logic
        return true
    }
    
    private func cardSelected(at index: Int) {
        setCardsSelected[index] = setCardsOnScreen.removeValue(forKey: index)
    }
    
    // Handles cleaning up selected dictionary on match and, if able to, replacing the card from deck.
    private func cleanupSelected(for index: Int) {
        setCardsSelected.removeValue(forKey: index)
        if (setDeck.count != 0) { setCardsOnScreen[index] = setDeck.removeFirst() }
    }
    
    // Assembles the Set deck of all possible combinations of attributes, and adds the cards to the main deck.
    // Also shuffles the deck for us.
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
    // Safely change the score without dipping into negative values.
    public mutating func changeScore(value: Int) {
        if (value > 0 || self >= abs(value) ) { self += value }
    }
}
