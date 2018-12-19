//
//  Set.swift
//  AssignmentThree
//
//  Created by Tolunay Arslan on 29.11.18.
//  Copyright © 2018 Tolunay Arslan. All rights reserved.
//

// TODO: remove not necessary comments.
// Core Graphics: underlying drawing system for normal 2d drawing in iOS

import Foundation

// TODO: Provide a documentation for every single variable, method, class, and struct in your code.
// https://swift.org/documentation/api-design-guidelines/ -> Fundamentals -> Write a documentation

// TODO: Organize your code into logical chunks with the // MARK: name of the section.

// FIXME: Use structs for simple types, like a Set game.
class Set {
    
    var deck = Deck()
    var cardsOnTable = [Card]()
    
    var firstDate = Date()
    
    func beginTime() {
        firstDate = Date()
    }
    
    var score = 0
    func changeScoreMisMatch() {
        score -= 4
    }

    // FIXME: selectedCards is a better name.
    var choosedCards: [Card] {
        return getChoosedCards()
    }
    
    // Go through all cards and give me the card back where the identifiers match
    func identifierMatch(identifier: Int) -> Card? {
        for card in cardsOnTable {
            if card.hashValue == identifier {
                return card
            }
        }
        return nil
    }
    
    // Choose card with identifer instead of index
    func chooseCard(identifier: Int) {
        
        // Contains Identifier of the Card?
        var card = cardsOnTable.filter { (card) -> Bool in
            if card.hashValue == identifier {
                return true
            } else {
                return false
            }
        }
        if card.count == 1 {
            
            card[0].isChoosed = card[0].isChoosed ? false : true
        } else {
            print("Error in chooseCard: There are more")
        }
    }

    // FIXME: The correct name would be getChosenCards() (passive of the choose action)
    // you might use selected cards as well: getSelectedCards().
    func getChoosedCards() -> [Card] {
        var returningCards = [Card]()
        for card in cardsOnTable {
            if card.isChoosed {
                returningCards += [card]
            }
        }
        return returningCards
    }
    
    func calculateScore() {
        let currentTime = Date()
        let timeInSeconds = (currentTime.timeIntervalSince(firstDate))
        if timeInSeconds < 2 {
            score += 5
        } else if timeInSeconds < 3 && timeInSeconds > 2 {
            score += 4
        } else {
            score += 3
        }
    }

    // FIXME: deckCount is a better name.
    var countOfDeck: Int {
        return deck.deck.count
    }
    
    init() {
        deck = Deck()
        cardsOnTable.removeAll()
        score = 0
        cardsOnTable = deck.getTwelveCards()!
    }
    
    func getThreeCards() -> [Card]? {
        if let cards = deck.getThreeCards() {
            for card in cards {
                cardsOnTable += [card]
            }
            return cards
        } else {
            print("Set.getThreeCards(): No more Cards in the Deck to return")
            return nil
        }
    }
    

    // FIXME: IsThereASet() is a better name.
    // Check whether set or not
    func wasThereAnySet() -> Bool {
        var getAllIndexes = cardsOnTable.map({return $0.hashValue})

        for firstIndex in 0..<cardsOnTable.index(before: cardsOnTable.indices.endIndex-1) {
            for secondIndex in (firstIndex+1)..<cardsOnTable.indices.endIndex-1 {
                for thirdIndex in (secondIndex+1)..<cardsOnTable.indices.endIndex {
                    
                    if isThereASet(identifier: [getAllIndexes[firstIndex],getAllIndexes[secondIndex],getAllIndexes[thirdIndex]]) {
                        score -= 1
                        return true
                    }
                }
            }
        }
        return false
    }

    // FIXME: The parameter name should be identifiers, because it's a collection.
    // Is this parameter needed? The game struct already has direct access to the selected cards.
    func isThereASet(identifier: [Int]? ) -> Bool {

        // FIXME: Since this is a collection, use numbers, instead of number.
        var number = [0,0,0,0]
        // FIXME: return returning is redundant, use a better name for this variable, like doesSelectionMatch
        var returning = false
        
        // Was there already any set?
        if identifier == nil {
            // TODO: For this kind of construct, you can use the assertionFailure("some mistake").
            // This would tell you if an unexpected error occurs while developing.
            guard choosedCards.count == 3 else {print("some mistake"); return false}

            for index in number.indices {
                for card in choosedCards {
                    number[index] += card.matrix[index]
                }
            }
            
            for sum in number {
                // FIXME: You can use the boolean expressions direclty, like this: returning = sum % 3 == 0
                if sum % 3 == 0 {
                    returning = true
                } else {
                    returning = false
                }
            }
            return returning
        } else {
            
            for index in number.indices {
                for identifier in identifier! {
                    let card = identifierMatch(identifier: identifier)!
                    number[index] += card.matrix[index]
                }
            }
            
            for sum in number {
                // FIXME: You can use the boolean expressions direclty, like this: returning = sum % 3 == 0
                if sum % 3 == 0 {
                    returning = true
                } else {
                    return false
                }
            }
            return returning
        }
    }

    // FIXME: This method is not intuitive. A better method name could be: replaceMatchedCards()
    // TODO: Inform what this method returns by using the - Return: documentation comment.
    func thereIsASet() -> [Card]{
        var returningCards = [Card]()
        
        // replace three + remove rest
        for card in choosedCards {
            let index = cardsOnTable.index(of: card)
//            cardsOnTable.remove(at: index!)
            if let newCard = deck.getOneCard() {
                cardsOnTable[index!] = newCard
                returningCards += [newCard]
            }
        }
        return returningCards
    }
}
