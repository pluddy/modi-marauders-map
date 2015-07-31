//
//  ViewController.swift
//  Devices
//
//  Created by Patrick Luddy on 7/27/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private let RowHeight: CGFloat = 44.0
    
    private var searchActive = false
    private var allUsers = [User]()
    private var filteredUsers = [User]()
    private var selectedUser: User?
    
    private var activityIndicator: UIActivityIndicatorView!
    private var activityIndicatorButton: UIActivityIndicatorView!

    @IBOutlet weak var constraintSearchBarToNavBar: NSLayoutConstraint!
    @IBOutlet var buttonCheckout: UIButton!
    @IBOutlet var searchField: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func checkout(sender: AnyObject) {
        self.startSpinningButton()
        if (selectedUser != nil) {
            let device = Device.sharedInstance
            device.setStatus(Checked.Out, updateTime: true)
            device.setUser(self.selectedUser!)
            NetworkService.updateStatus()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicatorButton = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        
        self.styleButton()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("newUsers:"), name: NotifGetUsersFromNetworkDidComplete, object: nil)
        notificationCenter.addObserver(self, selector: Selector("updateRemoteDeviceFinished:"), name: NotifUpdateRemoteDeviceDidComplete, object: nil)
        
        
        NetworkService.getUsers()
        self.startSpinningTable()
        
        var yCoord = (tableView.frame.height / 2) + tableView.frame.origin.y
        var xCoord = (tableView.frame.width / 2) + tableView.frame.origin.x
        activityIndicator.center = CGPoint(x: xCoord, y: yCoord)
        self.view.addSubview(activityIndicator)
        
        yCoord = (buttonCheckout.frame.height / 2) + buttonCheckout.frame.origin.y
        xCoord = (buttonCheckout.frame.width / 2) + buttonCheckout.frame.origin.x
        activityIndicatorButton.center = CGPoint(x: xCoord, y: yCoord)
        self.view.addSubview(activityIndicatorButton)
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func newUsers(notification: NSNotification) {
        if let info = notification.userInfo {
            self.allUsers = info[NotifUserInfoPayload] as! [User]
        }
        
        self.tableView.reloadData()
        self.stopSpinningTable()
    }
    
    func updateRemoteDeviceFinished(notification: NSNotification) {
        self.performSegueWithIdentifier("idCheckOuttoCheckInSegue", sender: self)
    }
    
    func styleButton() {
        self.buttonCheckout.layer.cornerRadius = 5.0
    }
    
    func showButton(show: Bool) {
        self.constraintSearchBarToNavBar.constant = show ? 84.0 : 8.0
        
        UIView.animateWithDuration(0.2, animations: {
            self.buttonCheckout.alpha = show ? 1.0 : 0.0
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                self.buttonCheckout.hidden = !show
        })
    }
    
    func startSpinningTable() {
        self.tableView.hidden = true
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
    }
    
    func startSpinningButton() {
        self.buttonCheckout.setTitle("", forState: UIControlState.Normal)
        self.buttonCheckout.enabled = false
        self.activityIndicatorButton.hidden = false
        self.activityIndicatorButton.startAnimating()
    }
    
    func stopSpinningTable() {
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
        self.tableView.hidden = false
        self.tableView.reloadData()
    }
    
    func stopSpinningButton() {
        self.activityIndicatorButton.hidden = true
        self.buttonCheckout.enabled = true
        self.buttonCheckout.setTitle("Check Out", forState: UIControlState.Normal)
        self.activityIndicatorButton.stopAnimating()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell

        cell.textLabel!.text = self.searchActive ? self.filteredUsers[indexPath.row].fullName() : self.allUsers[indexPath.row].fullName()
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchActive ? self.filteredUsers.count : self.allUsers.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        self.selectedUser = self.searchActive ? self.filteredUsers[row] : self.allUsers[row]
        
        showButton(true)
        
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.searchField.resignFirstResponder()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        showButton(false)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchActive = true
        
        self.filteredUsers = self.allUsers.filter({ (user) -> Bool in
            let tmp: String = user.fullName()
            if let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) {
                return !range.isEmpty
            }
            return false
        })
        if(self.filteredUsers.count == 0 || searchText.isEmpty){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchField.resignFirstResponder()
    }
}

