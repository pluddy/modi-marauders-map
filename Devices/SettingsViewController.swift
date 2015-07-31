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
    
    @IBOutlet weak var segmentedDeviceColor: UISegmentedControl!
    
    @IBAction func DismissSettings(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch Device.sharedInstance.getColor()
        {
        case "Black":
            self.segmentedDeviceColor.selectedSegmentIndex = 0
            break
        case "White":
            self.segmentedDeviceColor.selectedSegmentIndex = 1
            break
        case "Gold":
            self.segmentedDeviceColor.selectedSegmentIndex = 2
            break
        default:
            break
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}