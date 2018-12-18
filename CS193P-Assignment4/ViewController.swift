//
//  ViewController.swift
//  CS193P-Assignment4
//
//  Created by Tolunay Arslan on 18.12.18.
//  Copyright © 2018 Tolunay Arslan. All rights reserved.
//

import UIKit

struct Constants {
    static let cornerFontSizeToBoundsHeight: CGFloat = 0.07
}

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var newGame: UIButton!
    @IBOutlet weak var dealCards: UIButton!
    @IBOutlet weak var sets: UILabel!
    
    @IBOutlet weak var containerView: ContainerView! { didSet {
        let panGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        panGesture.direction = [.left,.right]
        containerView.addGestureRecognizer(panGesture)
        } }
    var game: Set! {
        didSet {
            score = 0
            updateFontSizes()
            start12Cards()
        }
    }
    
    // necessary whenever those things change
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateFontSizes()
    }
    
    private var fontSize: CGFloat {
        return containerView.bounds.size.height * Constants.cornerFontSizeToBoundsHeight
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
    
    private func start12Cards() {
        for card in game.cardsOnTable {
            initButton(with: card)
        }
    }
    
    var score: Int = 0 {
        didSet {
            countLabel.text = "Score: \(score)"
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        containerView.setNeedsLayout()
    }
    
    @objc func swipe(recognizer: UISwipeGestureRecognizer) {
        guard game.countOfDeck >= 3 else { return }
        draw3Cards()
    }
    
    
    private func initButton(with card: Card) {
        let button = ButtonView()
        button.color = ButtonView.Color(rawValue: card.color.rawValue)!
        button.shading = ButtonView.Shading(rawValue: card.shading.rawValue)!
        button.symbol = ButtonView.Symbol(rawValue: card.symbol.rawValue)!
        button.numberOfSymbols = ButtonView.Number(rawValue: card.number.rawValue)!
        
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTapped)))
        
        button.identifier = card.hashValue
        button.contentMode = .redraw
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
    
    @objc func cardTapped(recognizer: UITapGestureRecognizer) {
        
        guard let buttonView = recognizer.view as? ButtonView else {return}
        
        var choosedCards = game.getChoosedCards()
        
        if choosedCards.count == 3 && !game.isThereASet(identifier: nil) {
            // There was no Set therefore please cancel every choosed card to false
            containerView.cancelIsChoosed()
            let _ = game.cardsOnTable.map({$0.isChoosed = false})
            
        }   else if choosedCards.count == 3 && game.isThereASet(identifier: nil) {
            // There was a Set! Replace matchedCards
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
    
    private func draw3Cards() {
        if let cards = game.getThreeCards() {
            for card in cards {
                initButton(with: card)
            }
        }
    }
    
    
    @IBAction func threeMorePressed(_ sender: UIButton) {
        guard game.countOfDeck >= 3 else {return}
        if game.wasThereAnySet() {
            score = game.score
        }
        draw3Cards()
    }
    
    
    @IBAction func newGamePressed(_ sender: UIButton) {
        for card in containerView.subviews {
            card.removeFromSuperview()
        }
        updateFontSizes()
        game = Set()
        score = 0
        
    }
    
}



