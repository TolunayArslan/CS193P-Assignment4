//
//  Deck.swift
//  AssignmentThree
//
//  Created by Tolunay Arslan on 01.12.18.
//  Copyright © 2018 Tolunay Arslan. All rights reserved.
//

import Foundation

class Deck {
    
    var deck = [Card]()
    
    func getThreeCards() -> [Card]? {
        guard deck.count >= 3 else {return nil}
        var cards = [Card]()
        for _ in closedRangeThree {
            cards.append(deck.remove(at: deck.count.arc4Random))
        }
        return cards
    }
    
    func getOneCard() -> Card? {
        guard deck.count >= 1 else {return nil}
        return deck.remove(at: deck.count.arc4Random)
    }
    
    func getTwelveCards() -> [Card]? {
        guard deck.count >= 12 else {return nil}
        var cards = [Card]()
        for _ in 1...12 {
            cards.append(deck.remove(at: deck.count.arc4Random))
        }
        return cards
        
    }
    
    private let closedRangeThree = 1...3
    init() {
        // declare 81 cards
        deck = []

        for color in closedRangeThree {
            for symbol in closedRangeThree {
                for shading in closedRangeThree {
                    for number in closedRangeThree {
                        let card = Card(color: color, symbol: symbol, shading: shading, number: number)
                        deck.append(card)
                    }
                }
            }
        }
        //getCardsOnTable(count: .twelve)
    }
}

extension Int {
    var arc4Random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self == 0 {
            return 0
        } else {
            return Int(arc4random_uniform(UInt32(self)))
        }
    }
}












