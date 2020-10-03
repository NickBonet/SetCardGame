//
//  CardRender.swift
//  SetGame
//
//  Created by Nicholas Bonet on 10/1/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import Foundation
import UIKit

class CardRender {

    public static func renderButton(forCard: SetCard, forButton: UIButton, selected: Bool, matched: MatchState) {
        let attributes = buildAttributes(fromCard: forCard)
        let title = NSAttributedString(string: getShapeAndCount(fromCard: forCard), attributes: attributes)
        forButton.setAttributedTitle(title, for: UIControl.State.normal)
        forButton.isHidden = false

        if selected && matched == MatchState.matched {
            forButton.setBorder(color: UIColor.green.cgColor)
        } else if selected && matched == MatchState.unmatched {
            forButton.setBorder(color: UIColor.red.cgColor)
        } else if selected && matched == MatchState.unchecked {
            forButton.setBorder(color: UIColor.blue.cgColor)
        } else { forButton.removeBorder() }
    }

    private static func getShapeAndCount(fromCard: SetCard) -> String {
        var symbol = ""
        switch fromCard.shape {
        case SetCard.Shape.triangle:
            symbol = "▲"
        case SetCard.Shape.circle:
            symbol = "●"
        case SetCard.Shape.square:
            symbol = "◼︎"
        }

        switch fromCard.count {
        case 1:
            return "\(symbol)"
        case 2:
            return "\(symbol) \(symbol)"
        case 3:
            return "\(symbol) \(symbol) \(symbol)"
        default:
            return ""
        }
    }

    private static func getColor(fromCard: SetCard) -> UIColor {
        switch fromCard.color {
        case SetCard.Coloring.red:
            return UIColor.red
        case SetCard.Coloring.blue:
            return UIColor.blue
        case SetCard.Coloring.green:
            return UIColor.green
        }
    }

    private static func buildAttributes(fromCard: SetCard) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        switch fromCard.shade {
        case SetCard.Shade.filled:
            attributes[.strokeWidth] = -1
            attributes[.foregroundColor] = getColor(fromCard: fromCard)
            return attributes
        case SetCard.Shade.striped:
            attributes[.strokeWidth] = -1
            attributes[.foregroundColor] = getColor(fromCard: fromCard).withAlphaComponent(0.25)
            return attributes
        case SetCard.Shade.empty:
            attributes[.strokeWidth] = 5
            attributes[.foregroundColor] = getColor(fromCard: fromCard)
            return attributes
        }
    }
}
