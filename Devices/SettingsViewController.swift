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
        let device = Device.sharedInstance
        switch sender.selectedSegmentIndex
        {
        case 0:
            device.setColor("Black")
            break
        case 1:
            device.setColor("White")
            break
        case 2:
            device.setColor("Gold")
            break
        default:
            break
        }
        
        NetworkService.updateName()
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