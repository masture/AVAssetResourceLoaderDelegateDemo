//
//  ViewController + UserInteractions.swift
//  AVAssetResourceLoader
//
//  Created by Pankaj Kulkarni on 11/12/23.
//

import UIKit

extension ViewController {
    
    @objc func playTapped(_ sender: UIButton) {
        
//            if isCustomScheme {
//                player.automaticallyWaitsToMinimizeStalling = false
//            }
        if sender.titleLabel?.text == "Play" {
            print("Playing video")
            sender.setTitle("Pause", for: .normal)
            player.play()
        } else {
            print("Pausing video")
            sender.setTitle("Play", for: .normal)
            player.pause()
        }
    }
    
    @objc func seekForwardTapped(_ sender: UIButton) {

    }
    
}
