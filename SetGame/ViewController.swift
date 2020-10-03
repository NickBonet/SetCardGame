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
        // TODO: Placeholder for now.
        print("New game pressed!")
        updateGameView()
    }
    
    @IBAction private func addThreeCards(_ sender: Any) {
        // TODO: Placeholder for now.
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
    
    private func renderButtons() {
        for index in setCardButtons.indices {
            if let card = game.setCardsOnScreen[index] ?? game.setCardsSelected[index] {
                CardRender.renderButton(forCard: card, forButton: setCardButtons[index],
                                        selected: game.isCardSelected(at: index), matched: game.checkMatched(at: index))
            }
            else { setCardButtons[index].isHidden = true }
        }
        if (game.setDeck.count == 0) {
            addThreeCards.isEnabled = false
            addThreeCards.alpha = 0.5
        }
    }
}

extension UIButton {
    public func setBorder(color: CGColor) {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color
    }
    
    public func isSelected() -> Bool {
        return self.layer.borderWidth == 2.0
    }
    
    public func removeBorder() {
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
    }
}
