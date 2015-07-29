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

    @IBOutlet var searchField : UISearchBar!
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
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let selectedUser = self.searchActive ? self.allUsers[row] : self.filteredUsers[row]
        
        println(selectedUser.fullName())
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredUsers = self.allUsers.filter({ (user) -> Bool in
            let tmp: String = user.fullName()
            if let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) {
                return !range.isEmpty
            }
            return false
        })
        if(self.filteredUsers.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchField.resignFirstResponder()
    }
    
//    func dataForPopoverInTextField(textfield: MPGTextField_Swift) -> [Dictionary<String, AnyObject>]
//    {
//        return users
//    }
//    
//    func textFieldShouldSelect(textField: MPGTextField_Swift) -> Bool{
//        return true
//    }
//    
//    func textFieldDidEndEditing(textField: MPGTextField_Swift, withSelection data: Dictionary<String,AnyObject>){
//        print("Dictionary received = \(data)")
//    }
    
}

