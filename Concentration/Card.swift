//
//  Card.swift
//  Concentration
//
//  Created by Глеб Уваркин on 29/09/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import Foundation

struct Card: Hashable, Equatable
{
    var hashValue: Int { return identifier }
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var wasFaceUp = false
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifiedFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifiedFactory += 1
        return identifiedFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
