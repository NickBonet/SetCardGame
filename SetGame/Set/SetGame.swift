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

    // Array for the main deck, and dictionary for cards on screen currently
    // and for the cards that are presently selected.
    public var setDeck = [SetCard]()
    public var setCardsOnScreen: [Int: SetCard] = [:]
    public var setCardsSelected: [Int: SetCard] = [:]

    public func cardTouched(at index: Int) {
        // If the card's not already selected AND there are less than 3 cards selected, select the card.
        if !isCardSelected(at: index) && setCardsSelected.keys.count < 3 {
            cardSelected(at: index)
        }
        // If there are 3 selected cards already, time to do some Set checking.
        else if setCardsSelected.keys.count == 3 {
                // If there is a Set, replace the cards with new ones from the main deck.
                if isSet() {
                    // If the selected card is not currently part of the match,
                    // select the card and cleanup the matched cards.
                    if !setCardsSelected.keys.contains(index) {
                        cardSelected(at: index)
                        setCardsSelected.forEach { if $0.key != index { cleanMatch(for: $0.key) } }
                    } else { // If the card selected is part of the match, ignore and just cleanup the matched cards.
                        setCardsSelected.forEach { cleanMatch(for: $0.key) }
                    }
                }
                // If there's not a Set, deselect the cards and select the card at index.
                else {
                    cleanMismatch()
                    cardSelected(at: index)
                }
            }
        // If there's less than 3 cards selected, go ahead and deselect the current card.
        else if setCardsSelected.keys.count < 3 {
            setCardsOnScreen[index] = setCardsSelected.removeValue(forKey: index)
        }
    }

    // Returns the state of whether a specific card is selected or not.
    public func isCardSelected(at index: Int) -> Bool {
        return setCardsSelected.keys.contains(index)
    }

    // Returns whether or not a given card is part of a match.
    public func checkMatchedState(at index: Int) -> MatchState {
        if setCardsSelected.keys.count < 3 {
            return MatchState.unchecked
        } else if isCardSelected(at: index) && setCardsSelected.keys.count == 3 {
            return isSet() ? MatchState.matched : MatchState.unmatched
        } else { return MatchState.unmatched }
    }

    // Resets the game instance.
    public func resetGame() {
        score = 0
        buildSetDeck()
    }

    public func addThreeCards() {
        // If there's currently a Set match on screen, just replace those cards.
        if isSet() {
            setCardsSelected.forEach { cleanMatch(for: $0.key) }
        } else if setDeck.count != 0 {
            score.changeScore(value: -1)
            for _ in 1...3 {
                if setCardsSelected.keys.count == 3 && !isSet() {
                    setCardsOnScreen[setCardsOnScreen.keys.count + 3] = setDeck.removeFirst()
                } else {
                    setCardsOnScreen[setCardsOnScreen.keys.count + setCardsSelected.keys.count] = setDeck.removeFirst()
                }
            }
            // If there is a mismatch, deselect the cards.
            if setCardsSelected.keys.count == 3 && !isSet() { cleanMismatch() }
        }
    }

    public init() {
        buildSetDeck()
    }

    public func isSet() -> Bool {
        if setCardsSelected.keys.count == 3 {
            let cards = Array(setCardsSelected.map {$0.value})
            // Test whether each attribute of the 3 cards are all equal or all unique
            if (!((cards[0].color == cards[1].color) && (cards[1].color == cards[2].color) || (cards[0].color != cards[1].color) && (cards[1].color != cards[2].color) && (cards[0].color != cards[2].color))) {
                return false
            }
            if (!((cards[0].shape == cards[1].shape) && (cards[1].shape == cards[2].shape) || (cards[0].shape != cards[1].shape) && (cards[1].shape != cards[2].shape) && (cards[0].shape != cards[2].shape))) {
                return false
            }
            if (!((cards[0].shade == cards[1].shade) && (cards[1].shade == cards[2].shade) || (cards[0].shade != cards[1].shade) && (cards[1].shade != cards[2].shade) && (cards[0].shade != cards[2].shade))) {
                return false
            }
            if (!((cards[0].count == cards[1].count) && (cards[1].count == cards[2].count) || (cards[0].count != cards[1].count) && (cards[1].count != cards[2].count) && (cards[0].count != cards[2].count))) {
                return false
            }
            return true
        } else { return false }
    }

    private func cardSelected(at index: Int) {
        setCardsSelected[index] = setCardsOnScreen.removeValue(forKey: index)
    }

    // Handles cleaning up selected dictionary on match and, if able to, replacing the card from deck.
    private func cleanMatch(for index: Int) {
        // Since this is ran/looped 3 times whenever a match is being checked, handle scoring here.
        // +3 points total for a match.
        score.changeScore(value: 1)
        setCardsSelected.removeValue(forKey: index)
        if setDeck.count != 0 { setCardsOnScreen[index] = setDeck.removeFirst() }
    }

    // Handles cleaning up the selected dictionary on mismatch. Also takes care of reducing score for mismatch.
    private func cleanMismatch() {
        setCardsSelected.forEach { setCardsOnScreen[$0] = $1 }
        setCardsSelected.removeAll()
        score.changeScore(value: -2)
    }

    // Assembles the Set deck of all possible combinations of attributes, and adds the cards to the main deck.
    // Also shuffles the deck for us.
    private func buildSetDeck() {
        setDeck.removeAll()
        setCardsOnScreen.removeAll()
        setCardsSelected.removeAll()
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
        // Since the cards are shuffled, take the first 12 from the deck
        // and assign them to setCardsOnScreen.
        for index in 0...11 {
            setCardsOnScreen[index] = setDeck.removeFirst()
        }
    }
}

extension Int {
    // Safely change the score without dipping into negative values.
    public mutating func changeScore(value: Int) {
        if value > 0 || self >= abs(value) { self += value } else if self <= abs(value) { self = 0 }
    }
}
