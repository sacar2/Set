//
//  ViewController.swift
//  2019-03-14-Assignment2-Set
//
//  Created by Selin Denise Acar on 2019-03-14.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        for index in cardButtons.indices{
            cardButtons[index].isHidden = true
        }
        updateViewFromModel()
    }
    
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
    }
    
    @IBAction func tappedCardButton(_ sender: UIButton) {
        if let buttonIndex = cardButtons.index(of: sender){
            game.selectCard(forIndex: buttonIndex)
            updateViewFromModel()
        }
    }
    
    override func viewDidLoad() {
        updateViewFromModel()
    }
    
    private func updateViewFromModel(){
        for index in game.cardsOnTable.indices{
            let card = game.cardsOnTable[index]
            let cardButton = cardButtons[index]
            var cardString = ""
            for _ in 1...card.number{
                cardString += card.symbol.rawValue
            }
            
            var attributes: [NSAttributedString.Key: Any] = [:]
            if card.shading == SetCard.Shading.open{
                attributes = [
                    NSAttributedString.Key.strokeWidth: 5,
                    NSAttributedString.Key.strokeColor: card.color
                ]
            } else if card.shading == SetCard.Shading.solid{
                attributes = [
                    NSAttributedString.Key.strokeWidth: -1,
                    NSAttributedString.Key.foregroundColor: card.color
                ]
            } else if card.shading == SetCard.Shading.striped{
                attributes = [
                    NSAttributedString.Key.strokeWidth: -1,
                    NSAttributedString.Key.strokeColor: card.color,
                    NSAttributedString.Key.foregroundColor: card.color.withAlphaComponent(0.15)
                ]
            }
            
            let attributedCardString = NSAttributedString(string: cardString, attributes: attributes)
            cardButton.isHidden = false
            cardButton.setTitle(cardString, for: UIControl.State.normal)
            cardButton.setAttributedTitle(attributedCardString, for: UIControl.State.normal)
            cardButton.layer.cornerRadius = 8.0
            
            if card.isSelected{
                cardButton.layer.borderWidth = 3.0
                cardButton.layer.borderColor = UIColor.blue.cgColor
            }else{
                cardButton.layer.borderWidth = 0
            }
            
            //if there's no space on the table or no cards in the deck
            dealMoreCardsButton.isEnabled = game.cardsOnTable.count < 24 && game.cardsInDeck.count > 0
            
            print("\(index) card symbol in data: \(card.symbol.rawValue)\nderived string that must have been set: \(cardString) card \ntitle of card button supposedly: \(String(describing: cardButton.titleLabel!.text))")
        }
    }
}

