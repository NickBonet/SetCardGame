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

    // Take care of some initialization here since it's called on controller creation.
    // (First 12 cards, swipe down gesture for add 3 more)
    public override func viewDidLoad() {
        super.viewDidLoad()
        cardGrid.cellCount = game.setCardsOnScreen.count
        createCards()

        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(addThreeCards(_:)))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)

        updateGameView()
    }

    @objc private func touchCard(_ sender: UITapGestureRecognizer) {
        if let card = sender.view as? SetCardVkew {
            if let cardNumber = setCardButtons.firstIndex(of: card) {
                game.cardTouched(at: cardNumber)
            }
        }
        updateGameView()
    }

    @IBAction private func startNewGame(_ sender: Any) {
        game.resetGame()
        setCardButtons.removeAll()
        cardContainerView.subviews.forEach({ $0.removeFromSuperview() })
        cardGrid.cellCount = game.setCardsOnScreen.count
        updateGameView()
    }

    @IBAction private func addThreeCards(_ sender: Any) {
        game.addThreeCards()
        updateGameView()
    }

    private func updateGameView() {
        // TODO: Update for new card view.
        print("Cards in deck: \(game.setDeck.count)")
        print("Cards selected: \(game.setCardsSelected.count)")
        print("Cards left unselected: \(game.setCardsOnScreen.count)")
        cardGrid.cellCount = game.setCardsOnScreen.count
        updateCards()
        updateScoreLabel()
        update3CardsButton()
    }

    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }

    private func update3CardsButton() {
        if game.setDeck.count == 0 {
            addThreeCards.isEnabled = false
        } else { addThreeCards.isEnabled = true }
        addThreeCards.alpha = (addThreeCards.isEnabled == true) ? 1 : 0.5
    }

    private func createCards() {
        // If new cards were added in the model, add more to the view as well.
        // Works on initializing the view or when new cards are added in model.
        while game.setCardsOnScreen.count > setCardButtons.count {
            let cardIndex = setCardButtons.count
            let card = game.setCardsOnScreen[cardIndex]
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(_:)))
            let setCardView = SetCardVkew(frame: cardGrid[cardIndex]!,
                                          card: card, selected: false, matchState: MatchState.unchecked)
            setCardView.addGestureRecognizer(tapGesture)
            setCardButtons.append(setCardView)
            cardContainerView.addSubview(setCardView)
        }
    }

    private func updateCards() {
        // TODO: Remove card views if no more cards in the deck.
        createCards()
        for cardIndex in setCardButtons.indices {
            let card = game.setCardsOnScreen[cardIndex]
            let cardView = setCardButtons[cardIndex]
            cardView.frame = cardGrid[cardIndex]!
            cardView.updateCardView(newCard: card, selected: game.isCardSelected(card),
                                    matchState: game.isCardMatched(card))
        }
    }
}
