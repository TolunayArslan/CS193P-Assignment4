//
//  ViewController.swift
//  CS193P-Assignment4
//
//  Created by Tolunay Arslan on 18.12.18.
//  Copyright © 2018 Tolunay Arslan. All rights reserved.
//

import UIKit

// FIXME: Is this a private constant? If so, mark it as private.
// Good job for making this a constant with the struct construct. You can also do this with enums:
//enum EnumConstants {
//    static let cornerFontSizeToBoundsHeight: CGFloat = 0.07
//}
// The advantage of using enums like this, is that nobody can intantiate it, like so:
//let enumConstant = EnumConstants()

struct Constants {
    static let cornerFontSizeToBoundsHeight: CGFloat = 0.07
}
// TODO: Remove this.
let contants = Constants()

// TODO: Provide a documentation for every single variable, method, class, and struct in your code.
// https://swift.org/documentation/api-design-guidelines/ -> Fundamentals -> Write a documentation
// It doesn't need to be long, but it's a good practice to provide a meaningful phrase explaining the porpuse
// of a varaible, method, or class. And if necessary (for methods), what it returns, which params does it take.
// TODO: After doing this, press alt + click in the variable you've added documentation to. See what happens.

// TODO: Organize your code into logical chunks with the // MARK: comment. I'm providing one just for example.
// TODO: After doing this, check the breadcrumb of this file (the document items).
// https://i.stack.imgur.com/K1E7n.png
class ViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var newGame: UIButton!
    @IBOutlet weak var dealCards: UIButton!
    @IBOutlet weak var sets: UILabel!
    
    @IBOutlet weak var containerView: ContainerView! {
        didSet {
            let panGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
            panGesture.direction = [.left,.right]
            containerView.addGestureRecognizer(panGesture)
        }
    }
    var game: Set! {
        didSet {
            score = 0
            updateFontSizes()
            start12Cards()
        }
    }

    private var fontSize: CGFloat {
        return containerView.bounds.size.height * Constants.cornerFontSizeToBoundsHeight
    }

    var score: Int = 0 {
        didSet {
            countLabel.text = "Score: \(score)"
        }
    }

    // FIXME: Add a mark for the controller life cycle methods, IBActions, and other imperatives.
    // MARK: ...
    
    // necessary whenever those things change
    // FIXME: What things?
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateFontSizes()
    }
    
    private func updateFontSizes()  {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        // I want ot make my fontSize bigger or smaller depending on the users choice
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        countLabel.font = font
        newGame.titleLabel?.font = font
        sets.font = font
        dealCards.titleLabel?.font = font
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Set()
    }

    // FIXME: A better name would be dealInitialCards()
    private func start12Cards() {
        for card in game.cardsOnTable {
            initButton(with: card)
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        containerView.setNeedsLayout()
    }
    
    @objc func swipe(recognizer: UISwipeGestureRecognizer) {
        guard game.countOfDeck >= 3 else { return }
        draw3Cards()
    }
    
    // FIXME: Begin names of factory methods with “make”. A better name would be makeButton(card: Card)
    // This method would only be used for constructing new button instances.
    // https://swift.org/documentation/api-design-guidelines/#naming -> Strive for fluent usage.
    private func initButton(with card: Card) {
        let button = ButtonView()
        button.color = ButtonView.Color(rawValue: card.color.rawValue)!
        button.shading = ButtonView.Shading(rawValue: card.shading.rawValue)!
        button.symbol = ButtonView.Symbol(rawValue: card.symbol.rawValue)!
        button.numberOfSymbols = ButtonView.Number(rawValue: card.number.rawValue)!
        
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTapped)))
        
        button.identifier = card.hashValue
        button.contentMode = .redraw
        // FIXME: Don't add the card to the view in this method. Make the caller function do this job.
        view.addSubview(button)
        containerView.addSubview(button)
    }
    
    private func replaceMatchedCards(with cards: [Card]) {
        let matchedCards = containerView.subviews.filter { (button: UIView) -> Bool in
            if let buttonView = button as? ButtonView {
                return buttonView.isMatched ? true : false
            }
            return false
        }
        
        for index in 0...2 {
            if let buttonView = matchedCards[index] as? ButtonView {
                buttonView.matrix = cards[index].matrix
                buttonView.identifier = cards[index].hashValue
            }
        }
    }

    // FIXME: Use command names for IBActions and target-action mechanisms.
    // A better name could be selectCard(recognizer).
    // https://blog.cocoafrog.de/2018/04/12/How-to-name-IBActions.html
    @objc func cardTapped(recognizer: UITapGestureRecognizer) {
        guard let buttonView = recognizer.view as? ButtonView else {return}

        // FIXME: This entire code is part of the model layer.
        // Think of what would happen if the model was to be used in a different controller.
        // Would the card selection mechanism work independently of the controller?
        // What about the score mechanism?
        var choosedCards = game.getChoosedCards()

        if choosedCards.count == 3 && !game.isThereASet(identifier: nil) {
            // There was no Set therefore please cancel every choosed card to false
            containerView.cancelIsChoosed()
            // FIXME: Don't use map for configuring values in a collection.
            // It's better to use this (which is clearer in intent):
//            for card in game.cardsOnTable {
//                card.isChoosed = false
//            }
            // Also, this should be placed in the model. It can even be a method, like clearSelection()
            let _ = game.cardsOnTable.map({$0.isChoosed = false})
            
        }   else if choosedCards.count == 3 && game.isThereASet(identifier: nil) {
            // There was a Set! Replace matchedCards

            // TODO: In order to tell the controller if the cards were matched, we'd need to use the Delegation pattern.
            replaceMatchedCards(with: game.thereIsASet())
        }
        
        if choosedCards.count == 0 {
            game.beginTime()
        }
        
        game.chooseCard(identifier: buttonView.identifier)
        choosedCards = game.getChoosedCards()
        let touchedCard = game.identifierMatch(identifier: buttonView.identifier)!
        buttonView.isChoosed = touchedCard.isChoosed ? true : false
        
        if choosedCards.count == 3 {
            let identifier = choosedCards.map({$0.hashValue})
            if game.isThereASet(identifier: identifier) {
                for card in choosedCards {
                    let identifier = card.hashValue
                    card.isMatched = true
                    let button = containerView.identifierMatch(identifier: identifier)!
                    button.isMatched = true
                }
                game.calculateScore()
                score = game.score
                
            } else {
                // Not Set despite three cards choosen
                game.changeScoreMisMatch()
                score = game.score
                for card in choosedCards {
                    let identifier = card.hashValue
                    let button = containerView.identifierMatch(identifier: identifier)!
                    button.misMatched = true
                }
            }
        }
        //        updateLabel()
    }

    // FIXME: A better method name could be simply dealCards(byAmount amount: Int = 3).
    private func draw3Cards() {
        if let cards = game.getThreeCards() {
            for card in cards {
                initButton(with: card)
            }
        }
    }
    
    // FIXME: Use command names for IBActions and target-action mechanisms.
    // A better name could be dealMoreCardsForUser()
    // https://blog.cocoafrog.de/2018/04/12/How-to-name-IBActions.html
    @IBAction func threeMorePressed(_ sender: UIButton) {
        guard game.countOfDeck >= 3 else {return}
        if game.wasThereAnySet() {
            score = game.score
        }
        draw3Cards()
    }
    
    // FIXME: Use command names for IBActions and target-action mechanisms.
    // A better name could be startNewGame()
    // https://blog.cocoafrog.de/2018/04/12/How-to-name-IBActions.html
    @IBAction func newGamePressed(_ sender: UIButton) {
        for card in containerView.subviews {
            card.removeFromSuperview()
        }
        updateFontSizes()
        game = Set()
        score = 0
        
    }
    
}



