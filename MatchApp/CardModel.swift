//
//  CardModel.swift
//  MatchApp
//
//  Created by Henry on 8/11/20.
//  Copyright © 2020 hexec. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        // Declare an empty array
        var generateCards = [Card]()
        
        // Generate 8 pairs of cards randomly
        var cnt = 0
        while cnt < 8 {
            
            // Generate a random number
            let randomNumber = Int.random(in: 1...13)
            let temp = "card\(randomNumber)"
            
            // Check if dupilcate
            var flag = false
            for i in generateCards {
                if temp == i.imageName {
                    flag = true
                    break
                }
            }
            if flag {continue}
            cnt += 1
            
            // Create a pair of card objects
            let card1 = Card(), card2 = Card()
            
            // Set their image names
            card1.imageName = temp
            card2.imageName = temp
            
            // Add them to the array
            generateCards += [card1, card2]
            print("generated randomNumber \(randomNumber)")
        }
        // Randomize cards within the array
        generateCards.shuffle()
        
        // Return the array
        print("total objects generated: \(generateCards.count)")
        return generateCards
    }
}
