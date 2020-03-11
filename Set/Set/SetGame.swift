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
    let defaultNumberOfAddingCards = 3
    private(set) var deckInGame = [Card]()
    private(set) var cardsSelecting = [Card]()
    private(set) var deckHidden = [Card]()
    private(set) var isSet = false
    private(set) var scoreCounter = 0
    
    var checkSet: Bool {
        get{
            return isSet
        }
        
        set{
            guard cardsSelecting.count == defaultNumberOfAddingCards  else {
                isSet = false
                return
            }
            let setArray = [
                cardsSelecting.reduce(0, {$0+$1.color.getType()}),
                cardsSelecting.reduce(0, {$0+$1.shape.getType()}),
                cardsSelecting.reduce(0, {$0+$1.fill.getType()}),
                cardsSelecting.reduce(0, {$0+$1.number.getType()})]
            isSet = setArray.reduce(true, {$0 && ($1 % 3 == 0)})
            if !isSet {scoreCounter -= 3} else {scoreCounter += 5}
        }
    }
    
    var numberOfChosenCards: Int {cardsSelecting.count}
    
    init(){
        makeDeck()
    }
    
    func chooseCard(at index: Int) {
        switch numberOfChosenCards {
        case 0...2:
            if let indexInMatchingCards = cardsSelecting.firstIndex(of: deckInGame[index]) {
                cardsSelecting.remove(at: indexInMatchingCards)
        } else {cardsSelecting.append(deckInGame[index])}
            checkSet = true
        case 3:
            let selectedCard = deckInGame[index]
            let isNewCardChosen = !cardsSelecting.contains(selectedCard)
            if isSet {
                replaceCardsInGameFromHidden()
            }
            cardsSelecting.removeAll()
            if isNewCardChosen{cardsSelecting.append(selectedCard)}
            checkSet = false
        default: break
        }
    }
    
    func addCards() {
        if isSet {
            replaceCardsInGameFromHidden()
            cardsSelecting.removeAll()
            checkSet = true
        } else {
            scoreCounter -= 1
            addCardInGameFromHidden(number: defaultNumberOfAddingCards)
        }
    }
    
    private func addCardInGameFromHidden(number: Int){
        if number > 0 {
            let minNumber = min(number, deckHidden.count)
            if minNumber >= 3{
                for _ in 1...minNumber{
                    deckInGame += [deckHidden.remove(at: 0)]
                }
            }
        }
    }
    
    private func replaceCardsInGameFromHidden(){
            if deckHidden.count > 0 && deckInGame.count <= defaultNumberOfStartCards{
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
    }
    
    func newGame(){
        deckInGame.removeAll()
        deckHidden.removeAll()
        cardsSelecting.removeAll()
        scoreCounter = 0
        isSet = false
        makeDeck()
    }
    
    func shuffle(){
        deckInGame.shuffle()
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
