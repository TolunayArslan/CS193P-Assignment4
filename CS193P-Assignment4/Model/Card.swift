//
//  Card.swift
//  AssignmentThree
//
//  Created by Tolunay Arslan on 01.12.18.
//  Copyright © 2018 Tolunay Arslan. All rights reserved.
//

import Foundation

// TODO: Provide a documentation for every single variable, method, class, and struct in your code.
// https://swift.org/documentation/api-design-guidelines/ -> Fundamentals -> Write a documentation

// TODO: Organize your code into logical chunks with the // MARK: name of the section.

// FIXME: Use structs for simple types, like a card model.
class Card: Hashable, Equatable {

    var hashValue: Int
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    static var identifier = 0
    static func getUniqueIdentifier() -> Int {
        identifier += 1
        return identifier
    }
    
    
    var isMatched = false
    // FIXME: A better name would be isSelected
    var isChoosed = false
    
    init(color: Int, symbol: Int, shading: Int, number: Int) {
        self.color = Color.init(rawValue: color)
        self.symbol = Symbol.init(rawValue: symbol)
        self.shading = Shading.init(rawValue: shading)
        self.number = Number.init(rawValue: number)
        
        hashValue = Card.getUniqueIdentifier()
    }

    // TODO: This matrix could be a tuple. And this tuple could be defined as part of the controller.
    // Why in the controller? Because the controller is in charge of linking the model to the views.
    // You add extensions for the model and the view in the controller.
    // And this piece of code is used primarily for this purpose (to communicate what goes in the view and the model).
    var matrix: [Int] {
        return [symbol.rawValue,color.rawValue,number.rawValue,shading.rawValue]
    }
    
    var color: Color!
    var symbol: Symbol!
    var shading: Shading!
    var number: Number!
    
    enum Color: Int {
        case firstColor = 1
        case secondColor
        case thirdColor
    }
    
    enum Symbol: Int {
        case firstSymbol = 1
        case secondSymbol
        case thirdSymbol
    }
    
     enum Shading: Int {
        case firstShading = 1
        case secondShading
        case thirdShading
    }
    
     enum Number: Int {
        case one = 1
        case two
        case three
    }
    
    
}

