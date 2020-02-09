//
//  ViewController.swift
//  Concentration
//
//  Created by Глеб Уваркин on 27/09/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    @IBOutlet weak var scoreCountLabel: UILabel!{
        didSet{
            updateScoreCountLabel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    
    var numberOfPairsOfCards : Int {
            return (cardButtons.count + 1) / 2
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards:  numberOfPairsOfCards)
    
    private func updateScoreCountLabel(){
        scoreCountLabel.text = "Score: \(game.scoreCount)"
    }
    
    private func updateFlipCountLabel(){
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 3.0,
                .strokeColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                ]
        let attributesString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        
            flipCountLabel.attributedText = attributesString
    }
    
    @IBAction private func touchStartNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards:  numberOfPairsOfCards)
        emojiChoices = emojiArray[themeOfEmoji]
        emoji.removeAll()
        updateViewFromModel()
    }
    
        
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender){
            if !game.cards[cardNumber].isMatched, !game.cards[cardNumber].isFaceUp {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            }
        }
        else {
            print("chosen card was not in cardButtons")
        }
        
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        updateFlipCountLabel()
        updateScoreCountLabel()
    }
    
    private var emojiArray = ["🐶🐱🐭🐹🐰🦊🐻🐼🐀🦓", "🍏🍐🍊🥑🥯🥥🥝🥕🍕🍟🍿", "🏀🏹🥊🥅🎽🛷🛹🥌🏂🏉", "🚗🏍🚒🚚🛴🚲🛥🚢🚀🚁", "📱⌚️💻🖥🖨📺⏰💡☎️📷", "🌪☀️❄️💧🌊🌬⛅️☁️🌈⚡️"]
    private var themeOfEmoji : Int {
        return emojiArray.count.arc4random
    }
    private lazy var emojiChoices = emojiArray[themeOfEmoji]
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random : Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else {
            if self < 0 {
                return -Int(arc4random_uniform(UInt32(abs(self))))
            } else {
                return 0
            }
        }
    }
}
