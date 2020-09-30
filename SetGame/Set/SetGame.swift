//
//  SetGame.swift
//  SetGame
//
//  Created by Nicholas Bonet on 9/30/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import Foundation

class SetGame {
    
    public var score = 0
    
    public func cardTouched(at index: Int) {
        
    }
    
    public func resetGame() {
        
    }
    
    public func addThreeCards() {
        score.changeScore(value: -1)
    }
}

extension Int {
    public mutating func changeScore(value: Int) {
        if (value > 0 || self >= abs(value) ) { self += value }
    }
}
