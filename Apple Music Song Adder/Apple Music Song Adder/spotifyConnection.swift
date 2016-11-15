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

    class func getAllTracks() {
        
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
        typealias JSON = [String: AnyObject]
        
        Alamofire.request(url, headers: headers).responseJSON(completionHandler: { response in
            do {
                let readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSON
                print(readableJSON)
                
                print(String(describing: readableJSON["total"]!))
            } catch {
                print(error)
            }
        })
        
    }
}
