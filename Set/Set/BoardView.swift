//
//  BoardView.swift
//  Set
//
//  Created by Глеб Уваркин on 11/03/2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

class BoardView: UIView {

    var cardViews = [ViewCard](){
        didSet {
            addSubviews()
            setNeedsLayout()
        }
        
        willSet{removeSubviews()}
    }
    
    private func removeSubviews(){
        for card in cardViews {
            card.removeFromSuperview()
        }
    }
    
    private func addSubviews(){
        for card in cardViews{
            addSubview(card)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: .aspectRatio(Constant.aspectRatioConstant), frame: self.bounds)
        grid.cellCount = cardViews.count
        for row in 0..<grid.dimensions.rowCount {
            for column in 0..<grid.dimensions.columnCount {
                if cardViews.count > row * grid.dimensions.columnCount + column {
                    if let frameForCard = grid[row,column]{
                        cardViews[row * grid.dimensions.columnCount + column].frame = frameForCard.insetBy(dx: Constant.constantSpacingX, dy: Constant.constantSpacingY)
                    }
                }
            }
        }
        
    }
}

struct Constant{
    static let aspectRatioConstant : CGFloat = 0.7
    static let constantSpacingX : CGFloat = 2.0
    static let constantSpacingY : CGFloat = 2.0

}
