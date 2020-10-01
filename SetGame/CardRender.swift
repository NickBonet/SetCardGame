//
//  CardRender.swift
//  SetGame
//
//  Created by Nicholas Bonet on 10/1/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import Foundation

class CardRender {
    
    public static func renderButton(forCard: SetCard) -> NSAttributedString {
        return NSAttributedString(string: getShapeAndCount(from: forCard))
    }

    private static func getShapeAndCount(from: SetCard) -> String {
        var symbol = ""
        switch from.shape {
        case SetCard.Shape.triangle:
            symbol = "▲"
        case SetCard.Shape.circle:
            symbol = "●"
        case SetCard.Shape.square:
            symbol = "◼"
        }
        
        switch from.count {
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
}
