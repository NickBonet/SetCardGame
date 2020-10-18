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
        updateGameView()
    }

    @IBAction private func addThreeCards(_ sender: Any) {
        game.addThreeCards()
        updateGameView()
    }

    private func updateGameView() {
        print("Cards in deck: \(game.setDeck.count)")
        print("Cards selected: \(game.setCardsSelected.count)")
        print("Cards left unselected: \(game.setCardsOnScreen.count)")
        //renderCards()
        updateScoreLabel()
        update3CardsButton()
    }

    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }

    private func update3CardsButton() {
        if game.setDeck.count == 0 || (game.setCardsOnScreen.count == 24 && !game.isSet()) {
            addThreeCards.isEnabled = false
        } else { addThreeCards.isEnabled = true }
        addThreeCards.alpha = (addThreeCards.isEnabled == true) ? 1 : 0.5
    }

    private func renderCards() {
        for index in setCardButtons.indices {
            if game.setCardsOnScreen.indices.contains(index) {
                let card = game.setCardsOnScreen[index]
                //CardRender.renderButton(forCard: card, forButton: setCardButtons[index],
                  //                      selected: game.isCardSelected(card), matched: game.isCardMatched(card))
            } else { setCardButtons[index].isHidden = true }
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
