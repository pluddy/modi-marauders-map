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

    @IBOutlet weak var constraintSearchBarToNavBar: NSLayoutConstraint!
    @IBOutlet var buttonCheckout: UIButton!
    @IBOutlet var searchField: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allUsers = [
            User(id: "1234", firstName: "Jon", lastName: "Reynolds"),
            User(id: "5678", firstName: "Patrick", lastName: "Luddy"),
            User(id: "1357", firstName: "Jesse", lastName: "Jurman"),
            User(id: "2468", firstName: "Derek", lastName: "Nordgren")
        ]
        
        let device = Device.sharedInstance
        
        self.styleButton()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleButton() {
        self.buttonCheckout.layer.cornerRadius = 5.0
    }
    
    func showButton(show: Bool) {
        self.constraintSearchBarToNavBar.constant = show ? 36.0 : 0.0
        
        UIView.animateWithDuration(0.2, animations: {
            self.buttonCheckout.alpha = show ? 1.0 : 0.0
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                self.buttonCheckout.hidden = !show
        })
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
        let selectedUser = self.searchActive ? self.filteredUsers[row] : self.allUsers[row]
        
        showButton(true)
        
        println(selectedUser.fullName())
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

