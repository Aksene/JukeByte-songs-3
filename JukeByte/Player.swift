//
//  Player.swift
//  JukeByte
//
//  Created by Abdou K Sene on 3/12/19.
//  Copyright © 2019 Abdou K Sene. All rights reserved.
//

import Foundation
import MediaPlayer

class Player
{
    var avPlayer: AVPlayer!
    
    init() {
        avPlayer = AVPlayer()
    }
    
    func playStream(fileURL: String){
        if let url = URL(string: fileURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!){
        
            avPlayer = AVPlayer(url: url)
            avPlayer.play()
        
            setPlayingScreen(fileURL: fileURL)
        
            print("Playing stream")
        }
    }
    
    func queueStream(fileURL: String){
        
    }
    
    func playAudio(){
        if(avPlayer.rate == 0 && avPlayer.error == nil){
            avPlayer.play()
        }
    }

    func pauseAudio(){
        if(avPlayer.rate > 0 && avPlayer.error == nil){
            avPlayer.pause()
        }
    }
    
    func setPlayingScreen(fileURL: String){
        let urlArray = fileURL.characters.split(separator: "/" ).map(String.init)
        
        let name = urlArray[urlArray.endIndex-1]
        
        print(name)
        
        let songInfo = [
            MPMediaItemPropertyTitle: name,
            MPMediaItemPropertyArtist: "JukeByte"
        ]

        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
    }

    
    
}
