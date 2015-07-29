//
//  User.swift
//  Devices
//
//  Created by Patrick Luddy on 7/29/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation

struct User {
    let id: String!
    let firstName: String!
    let lastName: String!
    
    init(id: String, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func fullName() -> String {
        return firstName + " " + lastName
    }
}