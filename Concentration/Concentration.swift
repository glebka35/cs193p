//
//  Concentration.swift
//  Concentration
//
//  Created by Глеб Уваркин on 29/09/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import Foundation

class Concentration
{  
    private(set) var cards = [Card]()
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (newValue == index)
            }
        }
    }
    private(set) var flipCount = 0
    private(set) var scoreCount = 0
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at \(index): chosen index is not available")
        flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if card match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    scoreCount += 2
                } else {
                    if cards[matchIndex].wasFaceUp {scoreCount -= 1}
                    if cards[index].wasFaceUp {scoreCount -= 1}
                    
                    cards[matchIndex].wasFaceUp = true
                    cards[index].wasFaceUp = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards): game should have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
    }
}

extension Collection{
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
