//
//  SetGame.swift
//  2019-03-14-Assignment2-Set
//
//  Created by Selin Denise Acar on 2019-03-18.
//  Copyright © 2019 Selin Denise Acar. All rights reserved.
//

import UIKit

class SetGame{
    
    private(set) var score = 0
    private(set) var cardsInDeck = [SetCard]()
    private(set) var cardsOnTable = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    
    init(){
        createDeck()
        for _ in 1...4{ deal3Cards() }
    }
    
    private func createDeck(){
        for symbol in SetCard.Symbol.allCases{
            for shade in SetCard.Shading.allCases{
                for number in 1...3{
                    for color in [UIColor.red, UIColor.blue, UIColor.yellow]{
                        cardsInDeck.append(SetCard(isSelected: false, withSymbol: symbol, withNumberOfSymbols: number, hasShading: shade, withColor: color))
                    }
                }
            }
        }
        cardsInDeck.shuffle()
    }
    
    //only deal cards if there's space on the table
    func deal3Cards(){
        for _ in 1...3{
            if cardsOnTable.count < 24, let randomCard = cardsInDeck.popLast(){
                    cardsOnTable.append(randomCard)
            }
        }
    }
    
    func selectCard(forIndex index: Int){
        //assert that the cards on the table contains that index (if it doesn't then something else is screwed up, so crash!
        assert (cardsOnTable.indices.contains(index), "card tapped is out of bounds of playable cards")
        let card = cardsOnTable[index]
        
        //if card is already an active card, unselect the card
        if card.isSelected == true {
            cardsOnTable[index].isSelected = false
        }else{ //if the card is not already selected
            
            //check if there are already 3 cards selected
            let selectedCards = cardsOnTable.indices.filter{cardsOnTable[$0].isSelected}
            //if there is then unelect them
            if (selectedCards.count == 3) {
                for selectedCardIndex in selectedCards{
                    cardsOnTable[selectedCardIndex].isSelected = false
                }
            }
            cardsOnTable[index].isSelected = true //select the selected card
            
            if (selectedCards.count == 2) {
                //if there are now 3 selected cards, then check if they are a set
                let newlySelectedCards = cardsOnTable.indices.filter{cardsOnTable[$0].isSelected}
                if newlySelectedCards.count == 3{
                    verifySet(forCardIndices: newlySelectedCards)
                }
            }
        }
    }
    
    //check if they are all equal or all different for each property. as soon as one is false, return and do nothing
    func verifySet(forCardIndices indices: [Int]){
        //had to template the equatable type: call function with type T, where T is a template for all equatable types
        func checkIfAllEqualForValues<T: Equatable>(_ values: [T]) -> Bool{
            return (values[0] == values[1] && values[1] == values[2])
        }
        
        func checkIfAllDifferentForValues<T: Equatable>(_ values: [T]) -> Bool{
            return values[0] != values[1] && values[1] != values[2] && values[0] != values[2]
        }
        
        //cards must all be the same colour or all different colours
        if checkIfAllEqualForValues([cardsOnTable[indices[0]].color, cardsOnTable[indices[1]].color, cardsOnTable[indices[2]].color]) || checkIfAllDifferentForValues([cardsOnTable[indices[0]].color, cardsOnTable[indices[1]].color, cardsOnTable[indices[2]].color]){
            //cards must all be the same number or all different numbers
            if checkIfAllEqualForValues([cardsOnTable[indices[0]].number, cardsOnTable[indices[1]].number, cardsOnTable[indices[2]].number]) || checkIfAllDifferentForValues([cardsOnTable[indices[0]].number, cardsOnTable[indices[1]].number, cardsOnTable[indices[2]].number]){
                //cards must all be the same shading or all different shades
                if checkIfAllEqualForValues([cardsOnTable[indices[0]].shading, cardsOnTable[indices[1]].shading, cardsOnTable[indices[2]].shading]) || checkIfAllDifferentForValues([cardsOnTable[indices[0]].shading, cardsOnTable[indices[1]].shading, cardsOnTable[indices[2]].shading]){
                    //cards must all be the same symbol or all different symbols
                    if checkIfAllEqualForValues([cardsOnTable[indices[0]].symbol, cardsOnTable[indices[1]].symbol, cardsOnTable[indices[2]].symbol]) || checkIfAllDifferentForValues([cardsOnTable[indices[0]].symbol, cardsOnTable[indices[1]].symbol, cardsOnTable[indices[2]].symbol]){
                        //TODO: if you make it here then yeah they're a set! wooooo.
                        //now add it to your matched cards (next time something is highlighted, check if it's matched, if it is then remove it from the cards on the table and replace these matched cards with 3 from the deck)
                    }
                }
            }
        }
        
    }
}

