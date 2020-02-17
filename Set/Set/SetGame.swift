//
//  Set.swift
//  Set
//
//  Created by Глеб Уваркин on 13/02/2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import Foundation

class SetGame {
    
    private let defaultNumberOfStartCards = 12
    private let defaultNumberOfAddingCards = 3
    private(set) var deckInGame = [Card]()
    private(set) var cardsSelecting = [Card]()
    private(set) var deckHidden = [Card]()
    private var wasSet = false
    private(set) var scoreCounter = 0
    
    private var numberOfChosenCards: Int {cardsSelecting.count}
    
    init(){
        makeDeck()
    }
    
    func isSet() -> Bool {
        guard cardsSelecting.count == defaultNumberOfAddingCards  else {return false}
        let setArray = [
            cardsSelecting.reduce(0, {$0+$1.color.getType()}),
            cardsSelecting.reduce(0, {$0+$1.shape.getType()}),
            cardsSelecting.reduce(0, {$0+$1.fill.getType()}),
            cardsSelecting.reduce(0, {$0+$1.number.getType()})]
        wasSet = setArray.reduce(true, {$0 && ($1 % 3 == 0)})
        return wasSet
    }
    
    func chooseCard(at index: Int) {
        switch numberOfChosenCards {
        case 0...2: if let indexInMatchingCards = cardsSelecting.firstIndex(of: deckInGame[index]) {
            cardsSelecting.remove(at: indexInMatchingCards)
        } else {cardsSelecting.append(deckInGame[index])}
        case 3:
            if wasSet {replaceCardsInGameFromHidden()}
            cardsSelecting.removeAll()
            cardsSelecting.append(deckInGame[index])
            
        default: break
        }
    }
    
    func addCards() {
        if isSet() {
            replaceCardsInGameFromHidden()
            scoreCounter += 5
        } else {
            scoreCounter = cardsSelecting.count == 3 ? scoreCounter - 3 : scoreCounter - 1
            addCardInGameFromHidden(number: defaultNumberOfAddingCards)
        }
    }
    
    private func addCardInGameFromHidden(number: Int){
        if number > 0 {
            let minNumber = min(number, deckHidden.count)
            for _ in 1...minNumber{
                deckInGame += [deckHidden.remove(at: 0)]
            }
        }
    }
    
    private func replaceCardsInGameFromHidden(){
            if deckHidden.count > 0 && deckInGame.count < defaultNumberOfStartCards{
                for card in cardsSelecting {
                    if let index = deckInGame.firstIndex(of: card) {
                        deckInGame[index] = deckHidden.remove(at: 0)
                    }
                }
            } else {
                for card in cardsSelecting {
                    if let index = deckInGame.firstIndex(of: card) {
                        deckInGame.remove(at: index)
                    }
                }
            }
        cardsSelecting.removeAll()
    }
    
    func newGame(){
        deckInGame.removeAll()
        deckHidden.removeAll()
        cardsSelecting.removeAll()
        scoreCounter = 0
        makeDeck()
        
    }
    
    private func makeDeck(){
        let numbers = Card.Variant.getAll()
        let colors = Card.Variant.getAll()
        let shapes = Card.Variant.getAll()
        let fills = Card.Variant.getAll()
        
        for number in numbers{
            for color in colors {
                for shape in shapes{
                    for fill in fills {
                        deckHidden += [Card(number: number, color: color, shape: shape, fill: fill)]
                    }
                }
            }
        }
        deckHidden.shuffle()
        addCardInGameFromHidden(number: defaultNumberOfStartCards)
    }
    
}
