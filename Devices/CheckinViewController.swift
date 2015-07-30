//
//  CheckinViewController.swift
//  Devices
//
//  Created by Patrick Luddy on 7/29/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation
import UIKit

class CheckinViewController: UIViewController {
    
    @IBOutlet weak var CheckInButton: UIButton!
    @IBAction func CheckInPressed(sender: AnyObject) {
        //Update Server async
        self.performSegueWithIdentifier("idCheckIntoCheckOutSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = Device.sharedInstance
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}