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
    private var cardBackgroundColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    @IBOutlet weak var themeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTheme()
        updateViewFromModel()
    }
    
    var numberOfPairsOfCards : Int {
            return (cardButtons.count + 1) / 2
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards:  numberOfPairsOfCards)
    
    
    private func updateScoreCountLabel(){
        scoreCountLabel.text = "Score: \(game.scoreCount)"
    }
    
    private func updateFlipCountLabel(){
//        let attributes: [NSAttributedString.Key:Any] = [
//            .strokeWidth: 3.0,
//                .strokeColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
//                ]
//        let attributesString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
//            flipCountLabel.attributedText = attributesString
        flipCountLabel.text = "Flips:\(game.flipCount)"
    }
    
    @IBAction private func touchStartNewGame(_ sender: UIButton) {
        game.reset()
        changeTheme()
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardBackgroundColor
            }
        }
        updateFlipCountLabel()
        updateScoreCountLabel()
    }
    typealias Theme = (emojies: String, backgroundColor: UIColor, cardBackColor: UIColor)
    private var emojiDict: [String : Theme] = [
        "Animals": ("🐶🐱🐭🐹🐰🦊🐻🐼🐀🦓🐿🦌🐃🐖", #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        "Food": ("🍏🍐🍊🥑🥯🥥🥝🥕🍕🍟🍿🥓🍝🧀🍖", #colorLiteral(red: 1, green: 0.7395653725, blue: 0.6138527989, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)),
        "Sport": ("🏀🏹🥊🥅🎽🛷🛹🥌🏂🏉⛳️🏋️‍♀️🧗‍♂️⛸", #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)),
        "Transport": ("🚗🏍🚒🚚🛴🚲🛥🚢🚀🚁🛩⛵️🚅🚋",#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
        "Electronics": ("📱⌚️💻🖥🖨📺⏰💡☎️📷🎙🎛🔋🕹", #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)),
        "Weather": ("🌪☀️❄️💧🌊🌬⛅️☁️🌈⚡️☔️☃️🌖🌕", #colorLiteral(red: 0.6801015735, green: 1, blue: 0.8474055529, alpha: 1), #colorLiteral(red: 0.5741410851, green: 1, blue: 0.4411562681, alpha: 1))]
    
    private var themeOfEmoji : String {
        let themes = Array(emojiDict.keys)
        let theme = themes[Array(emojiDict.keys).count.arc4random]
        themeLabel.text = theme
        return theme
    }
    private var emojiChoices = ""
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            
        }
        return emoji[card] ?? "?"
    }
    
    private func changeTheme(){
        if let currentTheme = emojiDict[themeOfEmoji]{
            emojiChoices = currentTheme.emojies
            view.backgroundColor = currentTheme.backgroundColor
            cardBackgroundColor = currentTheme.cardBackColor
        } else {
            emojiChoices = ""
        }
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
