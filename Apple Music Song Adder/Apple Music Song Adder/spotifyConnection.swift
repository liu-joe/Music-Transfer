//
//  spotifyConnection.swift
//  Apple Music Song Adder
//
//  Created by Joe Liu on 2016-11-14.
//  Copyright © 2016 Joe. All rights reserved.
//

import UIKit
import Alamofire

class spotifyConnection: NSObject {

    typealias JSON = [String: AnyObject]
    
    class func getAllTracks() {
        
        getTracks(offset: 0, completionHandler: {(total: NSNumber, songList: NSArray) -> () in
            print("total songs: \(total)")
        })
    }
    
    class func getTracks(offset: NSNumber, completionHandler:@escaping (NSNumber, NSArray)->()) {
        var token: String = ""
        
        let userDefaults = UserDefaults.standard
        if let sessionObj = userDefaults.object(forKey: "SpotifySession") {
            let sessionDataObj = sessionObj as! Data
            
            let session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            token = session.accessToken
            
        } 
        
        let url = "https://api.spotify.com/v1/me/tracks?limit=50&offset=0"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        
        Alamofire.request(url, headers: headers).responseJSON(completionHandler: { response in
            do {
                let readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSON
                
                let trackList: NSArray = readableJSON["items"] as! NSArray
                
                let returnArray: NSArray = []
                
                print(readableJSON["total"]! as! NSNumber)
            
                for idx in 0..<trackList.count {
                    let item: JSON = trackList[idx] as! JSON
                    let track: JSON = item["track"] as! JSON
                    let trackName: String = track["name"] as! String
                    
                    
                    print(trackName)
                }
            } catch {
                print(error)
            }
        })
    }
}
