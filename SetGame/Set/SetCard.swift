//
//  SetCard.swift
//  SetGame
//
//  Created by Nicholas Bonet on 9/30/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import Foundation

struct SetCard {

    let color: Coloring
    let shade: Shade
    let shape: Shape
    var count: Int

    enum Coloring {
        case red
        case blue
        case green
        static let all = [red, green, blue]
    }

    enum Shade {
        case empty
        case filled
        case striped
        static let all = [empty, filled, striped]
    }

    enum Shape {
        case triangle
        case circle
        case square
        static let all = [triangle, circle, square]
    }
}
