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
    
    private var activityIndicatorButton: UIActivityIndicatorView!
    var containerDelegate: ContainerViewController!
    
    @IBOutlet weak var buttonCheckin: UIButton!
    
    @IBAction func CheckInPressed(sender: AnyObject) {
        self.startSpinningButton()
        //Update Server async
        let device = Device.sharedInstance
        device.setStatus(Checked.In, updateTime: true)
        device.setUser(nil)
        NetworkService.updateStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorButton = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)

        self.buttonCheckin.layer.cornerRadius = 5.0
        
        let device = Device.sharedInstance
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateRemoteDeviceFinished:"), name: NotifUpdateRemoteDeviceDidComplete, object: nil)
        
        let yCoord = (buttonCheckin.frame.height / 2) + buttonCheckin.frame.origin.y
        let xCoord = (buttonCheckin.frame.width / 2) + buttonCheckin.frame.origin.x
        activityIndicatorButton.center = CGPoint(x: xCoord, y: yCoord)
        self.view.addSubview(activityIndicatorButton)
    }
    
    func startSpinningButton() {
        self.buttonCheckin.setTitle("", forState: UIControlState.Normal)
        self.activityIndicatorButton.hidden = false
        self.buttonCheckin.enabled = false

        self.activityIndicatorButton.startAnimating()
    }
    func stopSpinningButton() {
        self.activityIndicatorButton.hidden = true
        self.buttonCheckin.enabled = true
        self.buttonCheckin.setTitle("Check In", forState: UIControlState.Normal)
        self.activityIndicatorButton.stopAnimating()
    }
    
    func updateRemoteDeviceFinished(notification: NSNotification) {
        self.stopSpinningButton()
        let vc = ViewController.CheckOut.viewController(self.containerDelegate)
        self.containerDelegate.switchToViewController(vc)
//        self.performSegueWithIdentifier("idCheckIntoCheckOutSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}