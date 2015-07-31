//
//  SettingsViewController.swift
//  Devices
//
//  Created by Patrick Luddy on 7/29/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
        
    @IBOutlet var locationLabel: UILabel!
    
    @IBAction func DismissSettings(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            Device.sharedInstance
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }

    func locationLabelText(var zone:Zone) {
        switch (zone){
        case Zone.West:
            locationLabel.text = "Location: West"
            break
        case Zone.East:
            locationLabel.text = "Location: East"
            break
        case Zone.Cart:
            locationLabel.text = "Location: Cart"
            break
        case Zone.Unknown:
            locationLabel.text = "Location: Unknown"
            break
        default:
            locationLabel.text = "Location: Fail"
        }
        locationLabel.layoutIfNeeded()
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