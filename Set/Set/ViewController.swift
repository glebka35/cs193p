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

    @IBOutlet weak var boardView: BoardView!{
        didSet{
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(reshuffle))
            boardView.addGestureRecognizer(rotate)
        }
    }
    
    
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
            updateScoreCounterLabel()
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
    
    @objc private func touchCard(recognizedBy recognizer: UITapGestureRecognizer) {
        switch(recognizer.state){
        case .ended: if let view = recognizer.view as? ViewCard, let index = boardView.cardViews.firstIndex(of: view) {
                game.chooseCard(at: index)
                updateViewFromModel()
            
            }
        default: break
        }
//        if let cardNumber = cardButtons.firstIndex(of: sender){
//            game.chooseCard(at: cardNumber)
//            updateViewFromModel()
//        }
    }
    
    @IBAction func addCardsInGame(_ sender: Any) {
        game.addCards()
        updateViewFromModel()
    }
    
    @IBAction func touchNewGameButton(_ sender: Any) {
        game.newGame()
        updateViewFromModel()
    }
    
    private func updateViewFromModel(){
        updateCardViews()
        updateDeckCounterLabel()
        updateScoreCounterLabel()
    }
    
//    private func setAttributedStringToButton(for button: UIView, from card: Card){
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//        let attributes : [NSAttributedString.Key: Any] = [
//            .strokeWidth: button.strokeWidth[card.fill.getType()],
//            .strokeColor: button.colors[card.color.getType()],
//            .foregroundColor: button.colors[card.color.getType()].withAlphaComponent(CGFloat(button.alphas[card.fill.getType()])),
//            .paragraphStyle: paragraphStyle]
//        let title = button.symbols[card.shape.getType()].join(n: card.number.getType(), with: characterWrap)
//        let attributedString = NSAttributedString(string: title, attributes: attributes)
//        button.setAttributedTitle(attributedString, for: .normal)
//    }
    
    private func addBorderToButton(button: UIButton, color: CGColor){
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 10
        button.layer.borderColor = color
    }
    
    private func updateCardViews(){
        if boardView.cardViews.count > game.deckInGame.count {
                   boardView.cardViews = Array(boardView.cardViews[..<game.deckInGame.count])
        }
        
        for index in game.deckInGame.indices{
            if boardView.cardViews.count - 1 < index {
                let viewCard = ViewCard()
                updateCardView(viewCard, card: game.deckInGame[index])
                addTapGestureRecognizer(for: viewCard)
                boardView.cardViews.append(viewCard)
            } else {
                let viewCard = boardView.cardViews[index]
                updateCardView(viewCard, card: game.deckInGame[index])
            }
        }
    }
    
    private func updateDeckCounterLabel(){
        deckCounterLabel.text = "Deck: \(game.deckHidden.count)"
    }
    
    private func updateScoreCounterLabel(){
        scoreCounterLabel.text = "Score: \(game.scoreCounter)"
    }
    
    private func updateCardView(_ viewCard: ViewCard, card: Card){
        
        if game.cardsSelecting.contains(card){
            if game.numberOfChosenCards == game.defaultNumberOfAddingCards {
            viewCard.borderColor = game.isSet ? ViewCard.DefaultValues.BorderColors.matching : ViewCard.DefaultValues.BorderColors.nonMatching
            } else {
                viewCard.borderColor = ViewCard.DefaultValues.BorderColors.chosen
            }
        } else {
                viewCard.borderColor = ViewCard.DefaultValues.BorderColors.none
        }
        viewCard.colorInt = card.color.getType()
        viewCard.count = card.number.getType() + 1
        viewCard.fillInt = card.fill.getType()
        viewCard.symbolInt = card.shape.getType()
        viewCard.layer.cornerRadius = ViewCard.DefaultValues.cornerRadius
        viewCard.clipsToBounds = true
        viewCard.backgroundColor = UIColor.white
        viewCard.borderWidth = ViewCard.DefaultValues.borderWidth
    }
    
    private func addTapGestureRecognizer(for card: ViewCard){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchCard(recognizedBy:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        card.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func reshuffle(_ sender: UIRotationGestureRecognizer){
        switch(sender.state){
        case .ended:
            game.shuffle()
            updateViewFromModel()
        default: break
        }
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

