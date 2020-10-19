//
//  ViewController.swift
//  SetGame
//
//  Created by Nicholas Bonet on 9/29/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet weak var addThreeCards: UIButton!
    @IBOutlet weak var cardContainerView: UIView!
    private var setCardButtons = [SetCardVkew]()
    private lazy var game = SetGame()
    private lazy var cardGrid = Grid(layout: Grid.Layout.aspectRatio(1.5), frame: cardContainerView.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        print(game.setCardsOnScreen.count)
        cardGrid.cellCount = game.setCardsOnScreen.count
        createCards()
        updateGameView()
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        //if let cardNumber = setCardButtons.firstIndex(of: sender) {
        //    game.cardTouched(at: cardNumber)
        //}
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
        cardGrid.cellCount = game.setCardsOnScreen.count
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

    private func createCards() {
        for cardIndex in game.setCardsOnScreen.indices {
            let setCardView = SetCardVkew(frame: cardGrid[cardIndex]!,
                                          game.setCardsOnScreen[cardIndex], false, MatchState.unchecked)
            setCardButtons.append(setCardView)
            cardContainerView.addSubview(setCardView)
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
