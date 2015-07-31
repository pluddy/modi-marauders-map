//
//  CheckinViewController.swift
//  Devices
//
//  Created by Patrick Luddy on 7/29/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation
import UIKit

class CheckinViewController: UIViewController, UITableViewDataSource {
    
    private var activityIndicatorButton: UIActivityIndicatorView!
    private var details = [String]()
    var containerDelegate: ContainerViewController!
    
    private let RowHeight = CGFloat(44.0)
    
    @IBOutlet var buttonCheckin: UIButton!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func CheckInPressed(sender: AnyObject) {
        self.startSpinningButton()
        let device = Device.sharedInstance
        device.setStatus(Checked.In, updateTime: true)
        device.setUser(nil)
        NetworkService.updateStatus()
    }
    
    @IBAction func settingsPressed(sender: AnyObject) {
        let vc = ViewController.Settings.viewController(self.containerDelegate)
        containerDelegate.switchToViewController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorButton = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)

        self.buttonCheckin.layer.cornerRadius = 5.0
        
        let device = Device.sharedInstance
        
        details = [
            "Device Name: \(device.getFullName())",
            "Status: \(device.getStatus().rawValue)",
            "Owner: \(device.getUser() != nil ? device.getUser()!.fullName() : String())",
            "Zone: \(device.getZone().rawValue)"
        ]
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateRemoteDeviceFinished:"), name: NotifStatusUpdateRemoteDeviceDidComplete, object: nil)
        
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel!.text = details[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RowHeight
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}