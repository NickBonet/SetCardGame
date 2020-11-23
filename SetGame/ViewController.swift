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
    @IBOutlet weak var cardsOnScreenView: UIView!
    private var setCardButtons = [UIView]()
    private var setCardFrontViews = [SetCardFrontView]()
    private var setCardBackViews = [SetCardBackView]()
    private lazy var game = SetGame()
    private lazy var cardGrid = Grid(layout: Grid.Layout.aspectRatio(1.5))

    // Take care of some gesture initialization here since it's called on controller creation.
    public override func viewDidLoad() {
        super.viewDidLoad()

        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(addThreeCards(_:)))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)

        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(_:)))
        self.view.addGestureRecognizer(rotateGesture)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardGrid.frame = cardsOnScreenView.bounds
        updateGameView()
    }

    @objc private func touchCard(_ sender: UITapGestureRecognizer) {
        if let card = sender.view as? SetCardFrontView {
            if let cardNumber = setCardFrontViews.firstIndex(of: card) {
                game.cardTouched(at: cardNumber)
            }
        }
        updateGameView()
    }

    // Handles shuffling the cards on screen.
    @objc private func shuffleCards(_ sender: UIRotationGestureRecognizer) {
        game.setCardsOnScreen.shuffle()
        updateGameView()
    }

    // Resets game model state and card views for new game.
    @IBAction private func startNewGame(_ sender: Any) {
        game.resetGame()
        setCardButtons.removeAll()
        setCardFrontViews.removeAll()
        setCardBackViews.removeAll()
        cardsOnScreenView.subviews.forEach({ $0.removeFromSuperview() })
        updateGameView()
    }

    @IBAction private func addThreeCards(_ sender: Any) {
        game.addThreeCards()
        updateGameView()
    }

    // Handles updating game view state on each action.
    private func updateGameView() {
        print("Cards in deck: \(game.setDeck.count)")
        print("Cards selected: \(game.setCardsSelected.count)")
        print("Cards left unselected: \(game.setCardsOnScreen.count)")
        updateCards()
        updateScoreLabel()
        update3CardsButton()
    }

    // Manages state of the Deal 3 Cards button, only disabled when no cards left in deck.
    private func update3CardsButton() {
        if game.setDeck.count == 0 {
            addThreeCards.isEnabled = false
        } else { addThreeCards.isEnabled = true }
        addThreeCards.alpha = (addThreeCards.isEnabled == true) ? 1 : 0.5
    }

    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }

    // Handles updating card views throughout the game, and removing them if needed when cards
    // are running out.
    private func updateCards() {
        createCards()
        for cardView in setCardButtons {
            let cardIndex = setCardButtons.firstIndex(of: cardView)!
            if game.setCardsOnScreen.indices.contains(cardIndex) {
                let card = game.setCardsOnScreen[cardIndex]
                let frontCardView = setCardFrontViews[cardIndex]
                let backCardView = setCardBackViews[cardIndex]
                UIView.animate(withDuration: 0.5, animations: {
                    cardView.frame = self.cardGrid[cardIndex]!.insetBy(dx: 2, dy: 2)
                    for subview in cardView.subviews { subview.frame = cardView.bounds }
                }, completion: { _ in
                    if !frontCardView.isCardFaceUp() {
                        UIView.transition(from: backCardView, to: frontCardView, duration: 0.6, options: [.transitionFlipFromLeft, .beginFromCurrentState], completion: { _ in
                            frontCardView.setFaceUp()
                            backCardView.removeFromSuperview()
                        })
                    }
                })
                frontCardView.updateCardView(newCard: card, selected: game.isCardSelected(card),
                                        matchState: game.isCardMatched(card))
            } else {
                setCardButtons.remove(at: cardIndex)
                setCardFrontViews.remove(at: cardIndex)
                setCardBackViews.remove(at: cardIndex)
                cardView.removeFromSuperview()
            }
        }
    }

    // Handles keeping number of card views consistent with current cards on screen
    // in the game model. Sets up tap gesture for them as well.
    private func createCards() {
        cardGrid.cellCount = game.setCardsOnScreen.count
        while game.setCardsOnScreen.count > setCardButtons.count {
            let cardIndex = setCardButtons.count
            let card = game.setCardsOnScreen[cardIndex]
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchCard(_:)))
            let cardParentView = UIView(frame: cardGrid[cardIndex]!.insetBy(dx: 2, dy: 2))
            let setCardView = SetCardFrontView(frame: cardParentView.bounds,
                                          card: card, selected: false, matchState: MatchState.unchecked)
            let setCardBackView = SetCardBackView(frame: cardParentView.bounds)
            cardParentView.addSubview(setCardView)
            cardParentView.addSubview(setCardBackView)
            setCardView.addGestureRecognizer(tapGesture)
            setCardButtons.append(cardParentView)
            setCardFrontViews.append(setCardView)
            setCardBackViews.append(setCardBackView)
            cardsOnScreenView.addSubview(cardParentView)
        }
    }
}
