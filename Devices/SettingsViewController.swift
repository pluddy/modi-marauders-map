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
    
    var containerDelegate: ContainerViewController!
    
    @IBOutlet weak var segmentedDeviceColor: UISegmentedControl!
    
    @IBAction func DismissSettings(sender: UIButton) {
        let vc = containerDelegate.checkinOrCheckout()
        containerDelegate.switchToViewController(vc)
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