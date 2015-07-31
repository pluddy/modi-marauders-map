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
    
    @IBOutlet weak var buttonCheckin: UIButton!
    @IBAction func CheckInPressed(sender: AnyObject) {
        self.startSpinningButton()
        //Update Server async
        if(FirstSegue.sharedInstance.getId() == segueId.CheckOuttoCheckIn){
            self.performSegueWithIdentifier("idCheckOuttoCheckInSegueUnwind", sender: self)
        }
        else {
            self.performSegueWithIdentifier("idCheckIntoCheckOutSegue", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorButton = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)

        self.buttonCheckin.layer.cornerRadius = 5.0
        
        let device = Device.sharedInstance
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        let yCoord = (buttonCheckin.frame.height / 2) + buttonCheckin.frame.origin.y
        let xCoord = (buttonCheckin.frame.width / 2) + buttonCheckin.frame.origin.x
        activityIndicatorButton.center = CGPoint(x: xCoord, y: yCoord)
        self.view.addSubview(activityIndicatorButton)
    }
    
    func startSpinningButton() {
        self.buttonCheckin.titleLabel?.text = ""
        self.activityIndicatorButton.hidden = false
        
        self.activityIndicatorButton.startAnimating()
    }
    func stopSpinningButton() {
        self.activityIndicatorButton.hidden = true
        self.buttonCheckin.titleLabel?.text = "Check In"
        self.activityIndicatorButton.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}