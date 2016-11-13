//
//  ViewController.swift
//  Apple Music Song Adder
//
//  Created by Joe Liu on 2016-11-13.
//  Copyright © 2016 Joe. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    @IBOutlet var testLabel: UILabel!
    var controller: SKCloudServiceController!
    var status: SKCloudServiceAuthorizationStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKCloudServiceController.requestAuthorization { (status) in
            // create the alert
            let alert = UIAlertController(title: String(status.rawValue), message: String(status.rawValue), preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

