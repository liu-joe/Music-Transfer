//
//  ViewController.swift
//  Apple Music Song Adder
//
//  Created by Joe Liu on 2016-11-13.
//  Copyright © 2016 Joe. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet var testLabel: UILabel!
    var controller: SKCloudServiceController!
    var status: SKCloudServiceAuthorizationStatus!
    
    let mediaLibrary = MPMediaLibrary()
    var query: MPMediaQuery!
    var collection: [MPMediaItemCollection]!
    
    let player = MPMusicPlayerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuth()
        
        // Using iTunes search API to return the top result of a query
        iTunesConnection.getTrackIDForString(searchString: "closer", completionHandler: { (trackID: String, trackName: String, artistName: String) -> () in
            print("Adding Track \(trackID): \(trackName) by \(artistName)")
        })
        
        spotifyConnection.getAllTracks()
        
    }
    
    func requestAuth() -> Void {
        SKCloudServiceController.requestAuthorization { (status) in
            // create the alert
            let alert = UIAlertController(title: String(status.rawValue), message: String(status.rawValue), preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addToLibrary(trackID: String) -> Void {
        mediaLibrary.addItem(withProductID: "255991760")
    }
    
    func playSong(trackID: String) -> Void {
        player.setQueueWithStoreIDs(["1135647629"])
        player.play()
    }
    
    func printCurrentLibrary() -> Void {
        query = MPMediaQuery.albums()
        collection = query!.collections
        
        for idx in 0..<collection!.count {
            for idx2 in 0...collection![idx].items.count - 1 {
                print(String(describing: collection![idx].items[idx2].persistentID))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

