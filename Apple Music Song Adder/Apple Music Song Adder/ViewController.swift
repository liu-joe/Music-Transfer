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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var getLibrary: UIButton!
    
    
    // Spotify authentication
    let kClientID = "1d6ea3f79e00454181272a547a23a6aa"
    let kCallbackURL = "musictransfer://returnafterlogin"
    let kTokenSwapURL = "http://localhost:1234/swap"
    let kTokenRefreshServiceURL = "http://localhost:1234/refresh"
    
    var session: SPTSession!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCloudServiceAuth()
        
        loginButton.alpha = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)
        
        let userDefaults = UserDefaults.standard
        if let sessionObj = userDefaults.object(forKey: "SpotifySession") {
            let sessionDataObj = sessionObj as! Data
            
            let session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            if !session.isValid() {
                SPTAuth.defaultInstance().renewSession(session, callback: { (error: Error?, session: SPTSession?) in
                    if error == nil {
                        let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
                        userDefaults.set(sessionData, forKey: "SpotifySession")
                        userDefaults.synchronize()
                        
                        self.session = session!
                        
                    } else {
                        print("Error refreshing session")
                    }
                })
            } else {
                print("Session valid")
            }
            
        } else {
            loginButton.alpha = 1
        }
        
        // Using iTunes search API to return the top result of a query
        iTunesConnection.getTrackIDForString(searchString: "closer", completionHandler: { (trackID: String, trackName: String, artistName: String) -> () in
            print("Adding Track \(trackID): \(trackName) by \(artistName)")
        })
        
    }
    
    func updateAfterFirstLogin () {
        loginButton.alpha = 0
    }
    
    @IBAction func getLibrary(_ sender: Any) {
        spotifyConnection.getAllTracks()
    }
    
    @IBAction func loginWithSpotify(_ sender: UIButton) {
        let loginURL = SPTAuth.loginURL(forClientId: kClientID, withRedirectURL: URL(string: kCallbackURL), scopes: ["playlist-read-private", "user-library-read"], responseType: "token")
    
        UIApplication.shared.open(loginURL!, completionHandler: { resultBool in 
            print (resultBool)
        })
    }
    
    func requestCloudServiceAuth() -> Void {
        
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
        let mediaLibrary = MPMediaLibrary()
        mediaLibrary.addItem(withProductID: "255991760")
    }
    
    func playSong(trackID: String) -> Void {
        let player = MPMusicPlayerController()

        player.setQueueWithStoreIDs(["1135647629"])
        player.play()
    }
    
    func printCurrentLibrary() -> Void {
        var query: MPMediaQuery!
        var collection: [MPMediaItemCollection]!
        
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

