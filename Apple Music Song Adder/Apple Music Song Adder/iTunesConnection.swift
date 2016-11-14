//
//  iTunesConnection.swift
//  Apple Music Song Adder
//
//  Created by Joe Liu on 2016-11-14.
//  Copyright © 2016 Joe. All rights reserved.
//

import UIKit

class iTunesConnection: NSObject {

    class func getTrackIDForString(searchString: String, completionHandler:@escaping (String, String, String)->()) {
        
        let escapedString = searchString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        
        let url = URL(string: "https://itunes.apple.com/search?term=\(escapedString!)&media=music")
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in 
            if error == nil {
                var itunesDict = NSDictionary()
                do {
                    itunesDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                } catch {
                    print("soemthing went wrong with itunes lookup")
                }
                
                let resultsArray = itunesDict.object(forKey: "results") as! [Dictionary<String, AnyObject>]
                
                if resultsArray.count > 0 {
                    if let resultDict = resultsArray.first {
                        let trackName = resultDict["trackName"] as! String
                        let artistName = resultDict["artistName"] as! String
                        let trackID = resultDict["trackId"] as! NSNumber
                        
                        completionHandler(String(describing: trackID), trackName, artistName)
                    }
                }
            }
            
        })
        
        task.resume()
    }
    
}
