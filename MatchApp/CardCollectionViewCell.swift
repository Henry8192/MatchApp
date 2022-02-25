//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Henry on 8/12/20.
//  Copyright © 2020 hexec. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        
        // Keep track of the card this cell represents
        self.card = card
        
        // Set front image view to image that represents the card
        frontImageView.image = UIImage(named: card.imageName)
        
        // Reset the state of the cell by checking the flip status of the card and then showing the front/back image view
        if card.isMatched == true {
            frontImageView.alpha = 0
            backImageView.alpha = 0
            return
        }
        else {
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        
        if card.isFlipped {
            // Show front image view
            flipUp(speed: 0)
            
        }
        else {
            // Show back image view
            flipDown(speed: 0, delay: 0)
        }
        
    }
    
    func flipUp(speed: TimeInterval = 0.3) {
        
        //Flip up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
        // Set the status of the card
        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            //Flip down animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
        // Set the status of the card
        card?.isFlipped = false
    }
    
    func removeCards() {
        
        // Make image views invisible
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
