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
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = setCardButtons.firstIndex(of: sender) {
            print("Card number \(cardNumber) pressed!")
        }
    }
    
    
    @IBAction private func startNewGame(_ sender: Any) {
        print("New game pressed!")
    }
    
    @IBAction private func addThreeCards(_ sender: Any) {
        print("+3 cards pressed!")
    }
    
}

