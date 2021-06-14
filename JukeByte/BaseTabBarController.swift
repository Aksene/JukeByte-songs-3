//
//  BaseTabBarController.swift
//  JukeByte
//
//  Created by Abdou K Sene on 8/25/19.
//  Copyright © 2019 Abdou K Sene. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    var nowPlaying = String()
    var nowPlayingArtist = String()
    var nowPlayingId: Int!
    var nextOne: Int = 1

    var currentIndexPath: IndexPath = []
    var player: Player!
    

    
    override func viewDidLoad() {
        player = Player()
        
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func likeSong(id: Int){
        print(id)
        
        let path = "http://jukebyte.co/music/like_song.php?id=" + String(id)
        let url = URL(string: path)
        let session = URLSession.shared
        let task = session.dataTask(with:url!) { (data, response,error) in
            let retrievedData = String(data: data!, encoding: String.Encoding.utf8)
            print(retrievedData!)
            
        }
        task.resume()
        print("LIKING SONG")
    }
    
    func songPlayed(id: Int){
        print(id)
        
        let path = "http://jukebyte.co/music/add_play.php?id=" + String(id)
        let url = URL(string: path)
        let session = URLSession.shared
        let task = session.dataTask(with:url!) { (data, response,error) in
            let retrievedData = String(data: data!, encoding: String.Encoding.utf8)
            print(retrievedData!)
            
        }
        task.resume()
        print("SONG PLAYED")
    }
    
    func nextIndexPath(){
        let main = UIViewController() as! ViewController
        
        if currentIndexPath.isEmpty{
            print("Queue empty")
            main.nextSong = main.songs[currentIndexPath.row]
        }else {
            print("Not empty")
            main.nextSong = main.songs[currentIndexPath.row+nextOne]
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
