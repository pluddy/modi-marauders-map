//
//  ViewController.swift
//  Devices
//
//  Created by Patrick Luddy on 7/27/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MPGTextFieldDelegate {
    
    var users = [Dictionary<String, AnyObject>()]

    @IBOutlet var userField : MPGTextField_Swift!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users[0] = ["0":"Patrick","1":"Pat","2":"PLuddy"]
        userField = MPGTextField_Swift()
        userField.popoverBackgroundColor = UIColor.redColor();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataForPopoverInTextField(textfield: MPGTextField_Swift) -> [Dictionary<String, AnyObject>]
    {
        return users
    }
    
    func textFieldShouldSelect(textField: MPGTextField_Swift) -> Bool{
        return true
    }
    
    func textFieldDidEndEditing(textField: MPGTextField_Swift, withSelection data: Dictionary<String,AnyObject>){
        print("Dictionary received = \(data)")
    }
    
}

