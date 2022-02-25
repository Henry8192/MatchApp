//
//  SoundManager.swift
//  MatchApp
//
//  Created by Henry on 8/14/20.
//  Copyright © 2020 hexec. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundAffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect: SoundAffect) {
        var soundFileName = ""
        
        switch effect {
            case .flip:
                soundFileName = "cardflip"
            case .match:
                soundFileName = "dingcorrect"
            case .nomatch:
                soundFileName = "dingwrong"
            case .shuffle:
                soundFileName = "shuffle"
        }
        
        // Get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        // Check if it is nil
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create an audio player")
            return
        }
    }
}
