//
//  OnboardViewController.swift
//  Devices
//
//  Created by Patrick Luddy on 7/30/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {
    
    var containerDelegate: ContainerViewController!
    
    @IBOutlet weak var mapPageLeft: UIImageView!
    @IBOutlet weak var mapPageRight: UIImageView!
    @IBOutlet weak var mapInk: UIImageView!
    @IBOutlet weak var labelSolemnlySwear: UILabel!
    @IBOutlet weak var mapBackground: UIImageView!
    @IBOutlet weak var viewSettings: UIView!
    @IBOutlet weak var labelDeviceColor: UILabel!
    @IBOutlet weak var segmentedDeviceColor: UISegmentedControl!
    @IBOutlet weak var buttonMischief: UIButton!
    
    @IBAction func mischiefManaged(sender: AnyObject) {
        switch segmentedDeviceColor.selectedSegmentIndex {
        case 0:
            Device.sharedInstance.setColor("Black")
            break
        case 1:
            Device.sharedInstance.setColor("White")
            break
        case 2:
            Device.sharedInstance.setColor("Gold")
            break
        default:
            break
        }
        if(Device.sharedInstance.getStatus() == Checked.In){
            self.performSegueWithIdentifier("showCheckout", sender: self)
        }
        else {
            self.performSegueWithIdentifier("showCheckin", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        let pageWidth = ceil(self.view.frame.width)
        
        self.buttonMischief.layer.cornerRadius = 5.0
        
        UIView.animateKeyframesWithDuration(8, delay: 5, options: nil, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.06125, animations: { () -> Void in
                self.mapPageLeft.frame = CGRect(x: -pageWidth/2, y: 0, width: self.mapPageLeft.frame.width, height: self.mapPageLeft.frame.height)
                self.mapPageRight.frame = CGRect(x: pageWidth, y: 0, width: self.mapPageRight.frame.width, height: self.mapPageRight.frame.height)
                self.view.layoutIfNeeded()
            })
            UIView.addKeyframeWithRelativeStartTime(0.125, relativeDuration: 0.1875, animations: { () -> Void in
                self.labelSolemnlySwear.alpha = 1
            })
            UIView.addKeyframeWithRelativeStartTime(0.4, relativeDuration: 0.1875, animations: { () -> Void in
                self.labelSolemnlySwear.alpha = 0
            })
            UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.15, animations: { () -> Void in
                self.mapInk.alpha = 0.1
                
            })
            UIView.addKeyframeWithRelativeStartTime(0.85, relativeDuration: 0.15, animations: { () -> Void in
                self.labelDeviceColor.alpha = 1
                self.segmentedDeviceColor.alpha = 1
                self.buttonMischief.alpha = 1
            })
            }) { (complete: Bool) -> Void in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}