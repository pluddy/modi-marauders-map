//
//  ViewController.swift
//  Devices
//
//  Created by Patrick Luddy on 7/27/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController, UISearchBarDelegate {
    
    var users = [Dictionary<String, AnyObject>()]

    @IBOutlet var searchField : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users[0] = ["0":"Patrick","1":"Pat","2":"PLuddy"]
        
        let device = Device.sharedInstance
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

