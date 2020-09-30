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
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = setCardButtons.firstIndex(of: sender) {
            print("Card number \(cardNumber) pressed!")
            sender.layer.borderWidth = 2.0
            sender.layer.borderColor = UIColor.red.cgColor
        }
        updateGameView()
    }
    
    
    @IBAction private func startNewGame(_ sender: Any) {
        print("New game pressed!")
        updateGameView()
    }
    
    @IBAction private func addThreeCards(_ sender: Any) {
        print("+3 cards pressed!")
        game.addThreeCards()
        updateGameView()
    }
    
    private func updateGameView() {
        updateScoreLabel()
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
}

