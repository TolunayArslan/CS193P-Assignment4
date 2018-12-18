//
//  ButtonView.swift
//  AssignmentThree
//
//  Created by Tolunay Arslan on 29.11.18.
//  Copyright © 2018 Tolunay Arslan. All rights reserved.
//

import UIKit

class ButtonView: UIView{

    var numberOfSymbols: Number = .one { didSet {setNeedsDisplay()} }
    var symbol: Symbol = .triangle { didSet {setNeedsDisplay()} }
    var color: Color = .red { didSet {setNeedsDisplay()} }
    var shading: Shading = .striped { didSet {setNeedsDisplay()} }

    var identifier: Int!
    
    override func draw(_ rect: CGRect) {
        if numberOfSymbols == .one {
            drawSymbol(position: .center, symbol: symbol)
        } else if numberOfSymbols == .two {
            drawSymbol(position: .top, symbol: symbol)
            drawSymbol(position: .center, symbol: symbol)
        } else {
            drawSymbol(position: .center, symbol: symbol)
            drawSymbol(position: .bottom, symbol: symbol)
            drawSymbol(position: .top, symbol: symbol)
        }
    }
    
    // Symbol : Color : Number : Shading
    var matrix = [Int]()  {
        didSet {
            symbol = Symbol.init(rawValue: matrix[0])!
            color = Color.init(rawValue: matrix[1])!
            numberOfSymbols = Number.init(rawValue: matrix[2])!
            shading = Shading.init(rawValue: matrix[3])!
            isChoosed = false
            isMatched = false
            misMatched = false
        }
    }
    
    // Simply set the bool value, then the color will be adjusted automatically
    var isChoosed = false { didSet {
        if isChoosed == true {
            layer.borderColor = Constants.borderColorChoosed
            layer.borderWidth = Constants.borderWidth
        } else {
            layer.borderWidth = 0
            }
        }
    }
    
    var misMatched = false {
        didSet {
            if misMatched == true {
                layer.borderColor = Constants.borderColorMiss
                layer.borderWidth = Constants.borderWidth
            } else {
                layer.borderWidth = 0
            }
        }
    }
    
    var isMatched = false {
        didSet {
            if isMatched == true {
                layer.borderColor = Constants.borderColorMatched
                layer.borderWidth = Constants.borderWidth

            }
        }
    }
    
    enum Number: Int {
        case one = 1
        case two
        case three
        
        static var all: [Number] = [.one,.two,.three]
    }
    
    enum Symbol: Int {
        case triangle = 1
        case circle
        case squiggles
        
        static var all: [Symbol] = [.triangle,.circle,.squiggles]
    }
    
    enum Color: Int {
        case red = 1
        case black
        case purple
        
        static var all: [Color] = [.red,.black,.purple]
    }
    
    enum Shading: Int {
        case solid = 1
        case striped
        case unfilled
        
        static var all: [Shading] = [.solid,.striped,.unfilled]
    }
    
    
    
    
    // Mark: Drawing
    
    
    private var origins: [CGPoint] {
    
        let xCoordinate = bounds.midX - (objectLength/2)

        var yCoordinate = bounds.minY + spaceBetweenObjects
        let firstOrigin = CGPoint(x: xCoordinate, y: yCoordinate)
        
        yCoordinate = yCoordinate + objectLength + spaceBetweenObjects
        let secondOrigin = CGPoint(x: xCoordinate, y: yCoordinate)
        
        yCoordinate = yCoordinate + objectLength + spaceBetweenObjects
        let thirdOrigin = CGPoint(x: xCoordinate, y: yCoordinate)
        
        return [firstOrigin,secondOrigin,thirdOrigin]
    
    }
    
    private func drawSymbol(position: Position, symbol: Symbol) {
        
        var centerOrigin: CGPoint!
        let path = UIBezierPath()

        if position == .center {
            centerOrigin = origins[1]
        } else if position == .bottom {
            centerOrigin = origins[2]
        } else {
            centerOrigin = origins[0]
        }
        
        if symbol == .triangle {
            path.move(to: CGPoint(x: centerOrigin.x + spaceBetweenObjects, y: centerOrigin.y))
            path.addLine(to: CGPoint(x: centerOrigin.x, y: centerOrigin.y + objectLength))
            path.addLine(to: CGPoint(x: centerOrigin.x+objectLength, y: centerOrigin.y + objectLength))
            path.close()
            
        } else if symbol == .squiggles {
            path.addSquare(origin: centerOrigin,
                           rightTop: CGPoint(x: centerOrigin.x + objectLength, y: centerOrigin.y),
                           rightBottom: CGPoint(x: centerOrigin.x + objectLength, y: centerOrigin.y + objectLength),
                           leftBottom: CGPoint(x: centerOrigin.x, y: centerOrigin.y + objectLength))
        } else {
            // Circle
            path.addArc(withCenter: CGPoint(x: centerOrigin.x + spaceBetweenObjects, y: centerOrigin.y + spaceBetweenObjects),
                        radius: spaceBetweenObjects, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        }
        setStrokeAndFillColor(path: path)
    }
    
  
    var widthOfLine: CGFloat {
        return self.bounds.size.height * 0.025
    }
    
    private func setStrokeAndFillColor(path: UIBezierPath) {
        drawColor.setStroke()
        drawColor.setFill()
        path.lineWidth = widthOfLine
        path.stroke()
        
        if shadingFloat == 1.0 {
            path.fill()
            
        } else if shadingFloat == 0.5 {
            // Stripe
            UIGraphicsGetCurrentContext()?.saveGState()
            path.addClip()
            let newPath = UIBezierPath()
            newPath.lineWidth = 1.0
            
            var length = (bounds.size.width - objectLength)/2
            let compareLength = (bounds.size.width-objectLength)/2+bounds.size.width/2
            while length < compareLength {
                
                length += 3
                var line = CGPoint(x: length, y: bounds.minY)
                newPath.move(to: line)
                line = CGPoint(x: length, y: bounds.maxY)
                newPath.addLine(to: line)
                
            }
            newPath.stroke();newPath.fill()
            UIGraphicsGetCurrentContext()?.restoreGState()

        }
        
      }
    }

extension ButtonView {
    
    private var spaceBetweenObjects: CGFloat {
        return bounds.height / 10
    }
    
    private var objectLength: CGFloat {
        return spaceBetweenObjects * 2
    }
    
    enum Position {
        case top
        case center
        case bottom
    }
    
    private struct Constants {
        static var borderColorChoosed: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static var borderColorMatched: CGColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        static var borderColorMiss: CGColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        static var borderWidth: CGFloat = 3.0
    }
    
    private var drawColor: UIColor {
        switch color {
        case .red: return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .black: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .purple: return #colorLiteral(red: 1, green: 0.4964648829, blue: 0.5699649748, alpha: 1)

        }
    }
    
    private var shadingFloat: CGFloat {
        switch shading {
        case .solid: return 1.0
        case .striped: return 0.5
        case .unfilled: return 0
        }
    }
}


extension UIBezierPath {
    func addSquare(origin: CGPoint, rightTop: CGPoint, rightBottom: CGPoint, leftBottom: CGPoint) {
        move(to: origin)
        addLine(to: rightTop)
        addLine(to: rightBottom)
        addLine(to: leftBottom)
        close()
    }
}



























