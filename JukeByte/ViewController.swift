//
//  ViewController.swift
//  JukeByte
//
//  Created by Abdou K Sene on 1/12/19.
//  Copyright © 2019 Abdou K Sene. All rights reserved.
//

import UIKit
import MediaPlayer
import Social
import Accounts
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var artistsLabel: UILabel!
    @IBOutlet weak var songsLabel: UILabel!
    @IBOutlet weak var nowPlayingArtistLabel: UILabel!
    var nowPlayingId: Int!
    var player: Player!
    var songs: [Song] = []
    var currentId: Int!
    var currentSong: Song!
    var nextSong: Song!
    var prevSong: Song!
    var prevOne: Int = 1
    var nextOne: Int = 1
    var currentName = String()
    var currentArtist = String()
    //var currentIndexPath: IndexPath = []

    @IBAction func nextButton(_ sender: UIButton) {
        let tabbar = tabBarController as! BaseTabBarController
        
        
        tabbar.player.playStream(fileURL: "http://jukebyte.co/music/" + nextSong.getArtists() + " - " + nextSong.getName())
        tabbar.nowPlaying = nextSong.getName()
        tabbar.nowPlayingArtist = nextSong.getArtists()
        nowPlayingLabel.text = nextSong.getName()
        nowPlayingArtistLabel.text = nextSong.getArtists()
        //nextSong = songs[currentIndexPath.row]

        nextIndexPath()
        nextOne += 1

    }
    
    @IBAction func prevButton(_ sender: UIButton) {
        let tabbar = tabBarController as! BaseTabBarController
        
        
        tabbar.player.playStream(fileURL: "http://jukebyte.co/music/" + nextSong.getArtists() + " - " + nextSong.getName())
        tabbar.nowPlaying = nextSong.getName()
        tabbar.nowPlayingArtist = nextSong.getArtists()
        nowPlayingLabel.text = nextSong.getName()
        nowPlayingArtistLabel.text = nextSong.getArtists()
        //nextSong = songs[currentIndexPath.row]
        
        nextIndexPath()
        nextOne = 1
        nextOne -= 1
    
    }
    
   @IBAction func likeButton(_ sender: UIButton) {
    let tabbar = tabBarController as! BaseTabBarController

        if let id = currentId{
            tabbar.likeSong(id: id)
        }
    }

    /*@IBAction func Artist(_ sender: Any) {
        performSegue(withIdentifier: "segue", sender: self)
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption),name: AVAudioSession.interruptionNotification, object: nil)

        
        player = Player()
        tableView.delegate = self
        tableView.dataSource = self
       
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

        retrieveSongs()

    }
    
    //delegate and source for tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coolCell", for: indexPath)
        

        cell.textLabel?.text = songs[indexPath.row].getName()
        
        cell.detailTextLabel?.text = songs[indexPath.row].getArtists()

        print("POPULATE")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tabbar = tabBarController as! BaseTabBarController
        tabbar.currentIndexPath = indexPath

        tabbar.player.playStream(fileURL: "http://jukebyte.co/music/" + songs[indexPath.row].getArtists() + " - " + songs[indexPath.row].getName())
        changePlayButton()
        nowPlayingLabel.text = songs[indexPath.row].getName()
        nowPlayingArtistLabel.text = songs[indexPath.row].getArtists()
        tabbar.songPlayed(id: songs[indexPath.row].getId())
        
        currentId = songs[indexPath.row].getId()
        currentSong = songs[indexPath.row]
        currentName = songs[indexPath.row].getName()
        currentArtist = songs[indexPath.row].getArtists()
        
        nextOne = 1
        tabbar.currentIndexPath = indexPath

        
        if tabbar.currentIndexPath.isEmpty{
            print("Queue empty")
            tabbar.currentIndexPath = indexPath
        }else {
            print("Not empty")
            tabbar.currentIndexPath.row = indexPath.row
            nextIndexPath()
            
        }

        
        tabbar.nowPlaying = songs[indexPath.row].getName()
        tabbar.nowPlayingArtist = songs[indexPath.row].getArtists()
        tabbar.nowPlayingId = songs[indexPath.row].getId()
        
    }
    
    func nextIndexPath(){
        let tabbar = tabBarController as! BaseTabBarController

        if tabbar.currentIndexPath.isEmpty{
            print("Queue empty")
            nextSong = songs[tabbar.currentIndexPath.row]
        }else {
            print("Not empty")
            nextSong = songs[tabbar.currentIndexPath.row+nextOne]

        }
        
        //nextSong.getName() == songs[currentIndexPath.row].getName()
       // nextSong.getArtists() == songs[currentIndexPath.row].getArtists()

        
    }
    //END
    
    func prevIndexPath(){
        let tabbar = tabBarController as! BaseTabBarController
        
        if tabbar.currentIndexPath.isEmpty{
            print("Queue empty")
            nextSong = songs[tabbar.currentIndexPath.row]
        }else {
            print("Not empty")
            nextSong = songs[tabbar.currentIndexPath.row-nextOne]
            
        }
    }

    override var canBecomeFirstResponder: Bool{
        return true
    }

    func setSession (){
        do{
           try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                        mode: .default,
                                                        policy: .longForm,
                                                        options: [])
        }
        catch{
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setLabels()
    }
    
    func setLabels(){
        let tabbar = tabBarController as! BaseTabBarController
        
        print("Updating Now Playing")
        print("-----------------------")
        print(tabbar.nowPlaying)
        print(tabbar.nowPlayingArtist)
        print("-----------------------")
        
        //player = Player()
        nowPlayingLabel.text = tabbar.nowPlaying
        nowPlayingArtistLabel.text = tabbar.nowPlayingArtist
        nowPlayingId = tabbar.nowPlayingId
    }
    
    
    @IBAction func playpauseButtonClick(_ sender: Any) {
        let tabbar = tabBarController as! BaseTabBarController

        if (tabbar.player.avPlayer.rate > 0) {
            tabbar.player.pauseAudio()
        }else{ tabbar.player.playAudio()}
        changePlayButton()

    }
    
    func changePlayButton(){
        let tabbar = tabBarController as! BaseTabBarController

        if(tabbar.player.avPlayer.rate > 0){
            playPauseButton.setImage(UIImage(named: "pauseIcon"), for: UIControl.State.normal)
        }
        else{
            playPauseButton.setImage(UIImage(named: "playIcon"), for: UIControl.State.normal)
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        if event!.type == UIEvent.EventType.remoteControl{
            if event!.subtype == UIEvent.EventSubtype.remoteControlPause{
                print("pause")
                player.pauseAudio()
            }
            else if event!.subtype ==  UIEvent.EventSubtype.remoteControlPlay{
                print("playing")
                player.playAudio()
            }
        }
    }
    
    @objc func handleInterruption(notification: NSNotification){
        player.pauseAudio()
        
        let interruptionTypeAsObject = notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSNumber
        
        /* let interruptionType = AVAudioSessionInterruptionTypeKey(rawValue: interruptionTypeAsObject.unsignedLongVal)
         
         if let type = interruptionType{
         if type == .ended {
         player.playAudio()

            }
        }
        //add heasphone handling
    */}
    
    //Retrieve & Parse Songs
    func retrieveSongs(){
        let path = "http://jukebyte.co/music/getmusic.php"
        
        let url = URL(string: path)
        let session = URLSession.shared
        let task = session.dataTask(with:url!) { (data, response,error) in

            let retrievedList = String(data: data!, encoding: String.Encoding.utf8)

            print(retrievedList!)
            self.parseSongs(data: retrievedList!)
            print("STORE SONGS")

        }
        task.resume()
        print("GETTING SONGS")
    }
    
    
    func parseSongs(data: String){
        if (data.contains("*")){
            let dataArray = (data as String).split{$0 == "*"}.map(String.init)
            for item in dataArray{
                let itemData = item.split{$0 == ","}.map(String.init)
                let newSong = Song(id: itemData[0], name: itemData[1], numLikes: itemData[2], numPlays: itemData[3], artists: itemData[4])
                songs.append(newSong!)
                print("PARSING NAME")

            }
            for s in songs{
                print ("--------------")
                print (s.getName())
                print (s.getId())
                print("GET NAME")

            }
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }
    //END
    
}
