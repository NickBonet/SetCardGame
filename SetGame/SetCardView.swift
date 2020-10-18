//
//  SetCardVkew.swift
//  SetGame
//
//  Created by Nicholas Bonet on 10/14/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import UIKit

@IBDesignable class SetCardVkew: UIView {
    // Defaults for the view when created. They're overriden once the view is initialized fully.
    @IBInspectable private var borderColor: UIColor = UIColor.white
    @IBInspectable private var shapeColor: UIColor = UIColor.red
    private var shapeShade: SetCard.Shade = SetCard.Shade.filled
    private var shape: SetCard.Shape = SetCard.Shape.squiggle
    private var numberOfShapes = 3
    
    // Required initializers for subclassing UIView.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // Initializer for setting card view properties from a SetCard.
    public convenience init(_ card: SetCard, _ selected: Bool, _ matchState: MatchState) {
        self.init(frame: .zero)
        self.shapeColor = getColor(card.color)
        self.borderColor = getBorderColor(selected, matchState)
        self.shapeShade = card.shade
        self.shape = card.shape
        self.numberOfShapes = card.count
    }
    
    // Returns proper shape color depending on SetCard value.
    private func getColor(_ coloring: SetCard.Coloring) -> UIColor {
        switch coloring {
        case SetCard.Coloring.red:
            return UIColor.red
        case SetCard.Coloring.green:
            return UIColor.green
        case SetCard.Coloring.purple:
            return UIColor.purple
        }
    }
    
    // Sets the shading of the shapes.
    private func setShading(_ path: UIBezierPath) -> UIBezierPath {
        let shadePath = UIBezierPath()
        shadePath.append(path)
        
        switch shapeShade {
        case SetCard.Shade.filled:
            shapeColor.setFill()
        case SetCard.Shade.empty:
            UIColor.white.setFill()
        case SetCard.Shade.striped:
            UIColor.white.setFill()
            shadePath.addClip()
            // Borrowed this from the class demo, with slight modification to dy.
            var start = CGPoint(x: 0.0, y: 0.0)
            var end = CGPoint(x: bounds.size.width, y: 0.0)
            let dy: CGFloat = bounds.size.height * 0.1
            while start.y <= bounds.size.height {
                shadePath.move(to: start)
                shadePath.addLine(to: end)
                start.y += dy
                end.y += dy
            }
        }
        return shadePath
    }
    
    // Returns the proper color of border based on whether the current card view is selected/part of a match or mismatch.
    private func getBorderColor(_ selected: Bool, _ matched: MatchState) -> UIColor {
        if selected && matched == MatchState.matched {
            return UIColor.green
        } else if selected && matched == MatchState.unmatched {
            return UIColor.red
        } else if selected && matched == MatchState.unchecked {
            return UIColor.blue
        } else { return UIColor.white }
    }
    
    // Takes care of showing the shapes on the view, including coloring and shading.
    private func drawPath(_ path: UIBezierPath) {
        shapeColor.setStroke()
        let finalPath = setShading(path)
        finalPath.lineWidth = 2.0
        finalPath.fill()
        finalPath.stroke()
    }
    
    // Main draw method of the custom view.
    public override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true

        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
        roundRect.addClip()
        roundRect.lineWidth = 4.5
        UIColor.white.setFill()
        borderColor.setStroke()
        roundRect.fill()
        roundRect.stroke()

        let path = UIBezierPath()
        switch shape {
        case SetCard.Shape.diamond:
            path.drawDiamond(bounds, numberOfShapes)
        case SetCard.Shape.oval:
            path.drawOval(bounds, numberOfShapes)
        case SetCard.Shape.squiggle:
            path.drawSquiggle(bounds, numberOfShapes)
        }
        
        drawPath(path)
    }
}