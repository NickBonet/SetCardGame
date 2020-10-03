//
//  ViewController.swift
//  SetGame
//
//  Created by Nicholas Bonet on 9/29/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var setCardButtons: [UIButton]!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet weak var addThreeCards: UIButton!
    private lazy var game = SetGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateGameView()
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = setCardButtons.firstIndex(of: sender) {
            game.cardTouched(at: cardNumber)
        }
        updateGameView()
    }

    @IBAction private func startNewGame(_ sender: Any) {
        game.resetGame()
        update3CardsButton(true)
        updateGameView()
    }

    @IBAction private func addThreeCards(_ sender: Any) {
        game.addThreeCards()
        updateGameView()
    }

    private func updateGameView() {
        print("Cards in deck: \(game.setDeck.count)")
        print("Cards selected: \(game.setCardsSelected.keys.count)")
        print("Cards left unselected: \(game.setCardsOnScreen.keys.count)")
        renderButtons()
        updateScoreLabel()
    }

    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }

    private func update3CardsButton(_ enabled: Bool) {
        addThreeCards.isEnabled = enabled
        if enabled {
            addThreeCards.alpha = 1
        } else { addThreeCards.alpha = 0.5 }
    }

    private func renderButtons() {
        for index in setCardButtons.indices {
            if let card = game.setCardsOnScreen[index] ?? game.setCardsSelected[index] {
                CardRender.renderButton(forCard: card, forButton: setCardButtons[index],
                                selected: game.isCardSelected(at: index), matched: game.checkMatchedState(at: index))
            } else { setCardButtons[index].isHidden = true }
        }
        // If Set deck is empty OR the amount of selected cards + on screen cards is 24, disable the button.
        // Assuming that the selected cards are not a match of course.
        if game.setDeck.count == 0 || (game.setCardsOnScreen.keys.count + game.setCardsSelected.keys.count == 24 && !game.isSet()) {
            update3CardsButton(false)
        }
        // If there are 24 cards between onScreen and Selected AND there is a match, enable the button.
        else if game.setCardsOnScreen.keys.count + game.setCardsSelected.keys.count == 24 && game.isSet() {
            update3CardsButton(true)
        }
    }
}

extension UIButton {
    public func setBorder(color: CGColor) {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color
    }

    public func removeBorder() {
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
    }
}
