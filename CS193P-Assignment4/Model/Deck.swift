//
//  Deck.swift
//  AssignmentThree
//
//  Created by Tolunay Arslan on 01.12.18.
//  Copyright © 2018 Tolunay Arslan. All rights reserved.
//

import Foundation

// TODO: Provide a documentation for every single variable, method, class, and struct in your code.
// https://swift.org/documentation/api-design-guidelines/ -> Fundamentals -> Write a documentation

// TODO: Organize your code into logical chunks with the // MARK: name of the section.

// FIXME: Use structs for simple types, like a Deck.
class Deck {

    // FIXME: A better name for this collection would be cards (the ones inside a deck).
    var deck = [Card]()

    func getThreeCards() -> [Card]? {
        // TODO: This could be written this way: return getRandomCards(byAmount: 3)
        guard deck.count >= 3 else {return nil}
        var cards = [Card]()
        for _ in closedRangeThree {
            cards.append(deck.remove(at: deck.count.arc4Random))
        }
        return cards
    }

    // FIXME: A better name would be getRandomCard()
    func getOneCard() -> Card? {
        // TODO: This could be written this way: return getRandomCards(byAmount: 1)
        guard deck.count >= 1 else {return nil}
        return deck.remove(at: deck.count.arc4Random)
    }

    // FIXME: A better name would be getRandomCards(byAmount amount: Int = 12)
    // TODO: You can reuse the code for the getRandomCards(byAmount: x) in the getRandomCard() and getRandomCardsForDealing()
    func getTwelveCards() -> [Card]? {
        guard deck.count >= 12 else {return nil}
        var cards = [Card]()
        for _ in 1...12 {
            cards.append(deck.remove(at: deck.count.arc4Random))
        }
        return cards
        
    }

    // FIXME: This could be declared internally, in the init scope.
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












