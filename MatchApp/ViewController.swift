//
//  ViewController.swift
//  MatchApp
//
//  Created by Henry on 8/11/20.
//  Copyright © 2020 hexec. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var model = CardModel()
    var cardsArray = [Card]()
    var timer: Timer?
    var firstFlippedCardIndex: IndexPath?
    var milliseconds: Int = 60 * 1000
    var cnt = 0
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // Set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
        
        // Check user's status
//        showAlert(title: "Are You Ready?", message: "Hit \"OK\" to start")
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    // MARK: - Timer Methods
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2lf", seconds)
        
        // Stop the timer if reaches 0
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // TODO: Check if user has cleared all the pairs
            checkForGameEnd()
        }
    }

    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return it
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Configure the state of the cell based on the properties of the card that it represents
        let cardCell = cell as? CardCollectionViewCell

        // Get card from cardArray and configure the cell
        cardCell?.configureCell(card: cardsArray[indexPath.row])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check the status of the card to determine how to flip it
        if cell?.card?.isMatched == false && cell?.card?.isFlipped == false {
            // Flip the card up
            cell?.flipUp()
            
            // Play flip sound
            soundPlayer.playSound(effect: .flip)
            
            // Check if it is the first card that was flipped or the second card
            if firstFlippedCardIndex == nil {
                
                // First card flipped over
                firstFlippedCardIndex = indexPath
                
                
            }
            else {
                
                // Second card flipped over, run the comparison logic
                checkForMatch(indexPath)
                
            }
            
        }
    }
    
    // MARK: - Game Logic Methods
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the two card objects from the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two card collection view cells that represent cardOne and cardTwo
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // Match! Play match sound
            soundPlayer.playSound(effect: .match)
            
            // Set status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            cardOneCell?.removeCards()
            cardTwoCell?.removeCards()
            
            // Counting total pairs cleared
            cnt += 1
            
            // Check if game ends
            checkForGameEnd()
        }
        else {
            // Don't match. Play nomatch sound
            soundPlayer.playSound(effect: .nomatch)
            
            //Flip them back over
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown() 
            
        }
        // Reset firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        
        // Check if there's any cards unmatched
        
        if cnt == 8 {
            
            // User has won, show the alert
            showAlert(title: "Congratulations!", message: "You've won the game in \(60.0-Double(milliseconds)/1000.0) seconds!")
            timer?.invalidate()
        }
        else if milliseconds <= 0 {
            
            // User hasn't won yet, check if there's any time remaining
            showAlert(title: "Time's Up!", message: "Better luck next time!")
            
        }
    }
    func showAlert(title: String, message: String) {
        
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button for user to dismiss it
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Show alert
        present(alert, animated: true, completion: nil)
        
        /*
        // Restart
        cardsArray = [Card]()
        firstFlippedCardIndex = nil
        milliseconds = 60 * 1000
        cnt = 0
        viewDidLoad()
        viewDidAppear(true)
        */
    }
}
