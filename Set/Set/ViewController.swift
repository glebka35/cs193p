//
//  ViewController.swift
//  Set
//
//  Created by Глеб Уваркин on 13/02/2020.
//  Copyright © 2020 Gleb Uvarkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    private var characterWrap = "\n"

    @IBOutlet private var cardButtons: [ButtonCard]!
    
    @IBOutlet weak var addCardsButton: UIButton! {
        didSet{
            addBorderToButton(button: addCardsButton, color: #colorLiteral(red: 0.8168384433, green: 0.9453642964, blue: 0.3423162103, alpha: 1))
        }
    }
    @IBOutlet weak var newGameButton: UIButton!{
        didSet {
            addBorderToButton(button: newGameButton, color: #colorLiteral(red: 0.8168384433, green: 0.9453642964, blue: 0.3423162103, alpha: 1))
        }
    }
    
    @IBOutlet weak var deckCounterLabel: UILabel!{
        didSet{
            updateDeckCounterLabel()
        }
    }
   
    @IBOutlet weak var scoreCounterLabel: UILabel!{
        didSet{
            updateSetsCounterLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait {
            characterWrap = "\n"
        } else {
            characterWrap = ""
        }
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: ButtonCard) {
        if let cardNumber = cardButtons.firstIndex(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction func addCardsInGame(_ sender: Any) {
        if game.deckInGame.count <= 21 || game.isSet() {
            game.addCards()
            updateViewFromModel()
        }
    }
    
    @IBAction func touchNewGameButton(_ sender: Any) {
        game.newGame()
        updateViewFromModel()
    }
    
    private func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if game.deckInGame.indices.contains(index){
                setAttributedStringToButton(for: button, from: game.deckInGame[index])
                let card = game.deckInGame[index]
                if game.cardsSelecting.contains(card){
                    if game.cardsSelecting.count == 3 {
                        button.borderColor = game.isSet() ? ButtonCard.DefaultValues.BorderColors.matching : ButtonCard.DefaultValues.BorderColors.nonMatching
                    } else {
                        button.borderColor = ButtonCard.DefaultValues.BorderColors.chosen
                    }
                } else {
                    button.borderColor = ButtonCard.DefaultValues.BorderColors.none
                }
                button.activate()
            } else {
                button.deactivate()
            }
        }
        updateDeckCounterLabel()
        updateSetsCounterLabel()
    }
    
    private func setAttributedStringToButton(for button: ButtonCard, from card: Card){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes : [NSAttributedString.Key: Any] = [
            .strokeWidth: button.strokeWidth[card.fill.getType()],
            .strokeColor: button.colors[card.color.getType()],
            .foregroundColor: button.colors[card.color.getType()].withAlphaComponent(CGFloat(button.alphas[card.fill.getType()])),
            .paragraphStyle: paragraphStyle]
        let title = button.symbols[card.shape.getType()].join(n: card.number.getType(), with: characterWrap)
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
    }
    
    private func addBorderToButton(button: UIButton, color: CGColor){
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 10
        button.layer.borderColor = color
    }
    
    private func updateDeckCounterLabel(){
        deckCounterLabel.text = "Deck: \(game.deckHidden.count)"
    }
    
    private func updateSetsCounterLabel(){
        scoreCounterLabel.text = "Score: \(game.scoreCounter)"
    }
}

extension String {
    func join(n: Int, with separator: String) -> String{
        guard n > 0 else {return self}
        var concatString = self
        for _ in 1...n {
            concatString += separator
            concatString += self
        }
        return concatString
    }
}

