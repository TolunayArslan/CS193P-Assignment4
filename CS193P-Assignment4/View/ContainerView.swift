//
//  ContainerView.swift
//  AssignmentThree
//
//  Created by Tolunay Arslan on 29.11.18.
//  Copyright © 2018 Tolunay Arslan. All rights reserved.
//

import UIKit

class ContainerView: UIView {
    var insetNum: CGFloat = 3.0
    
    func cancelIsChoosed() {
        for button in subviews {
            if let buttonView = button as? ButtonView {
                buttonView.isChoosed = false
            }
        }
    }
    // Go through all buttonViews and give me the buttonView back where the identifiers match
    func identifierMatch(identifier: Int) -> ButtonView? {
        for index in subviews.indices  {
            if let button = subviews[index] as? ButtonView {
                if button.identifier == identifier {
                    return button
                }
            }
        }
        return nil
    }

    
    override func didAddSubview(_ subview: UIView) {
        adjustFrameSizes()
    }


    func adjustFrameSizes() {
        var grid = Grid(layout: .aspectRatio(0.6), frame: self.bounds)
        grid.cellCount = self.subviews.count
        for index in subviews.indices{
            if let button = subviews[index] as? ButtonView {
                let theFrame = grid[index]!
                let buttonFrame = theFrame.insetBy(dx: insetNum, dy: insetNum)
//                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3.0,
//                                                               delay: 2.0,
//                                                               options: [],
//                                                               animations: {button.frame}
//                )
                button.frame = buttonFrame
                button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            }
        }
    }
    
    override func layoutSubviews() {
        adjustFrameSizes()
    }

}


