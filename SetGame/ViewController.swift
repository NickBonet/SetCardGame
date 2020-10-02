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
    private lazy var game = SetGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGameView()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = setCardButtons.firstIndex(of: sender) {
            print("Card number \(cardNumber) pressed!")
            game.cardSelected(at: cardNumber)
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
        renderButtons()
        updateScoreLabel()
        print("Cards in deck: \(game.setDeck.count)")
        print("Cards selected: \(game.setCardsSelected.keys.count)")
        print("Cards left on screen: \(game.setCardsOnScreen.count)")
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func renderButtons() {
        for index in setCardButtons.indices {
            CardRender.renderButton(forCard: game.setDeck[index], forButton: setCardButtons[index], selected: game.isCardSelected(at: index))
        }
    }
}

extension UIButton {
    public func setSelected() {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    public func isSelected() -> Bool {
        return self.layer.borderWidth == 2.0
    }
    
    public func setDeselected() {
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
    }
}
