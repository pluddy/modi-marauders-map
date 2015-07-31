//
//  SegueManager.swift
//  Devices
//
//  Created by Patrick Luddy on 7/31/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation
import UIKit

enum segueId {
    case CheckIntoCheckOut
    case CheckOuttoCheckIn
    case None
}

class FirstSegue {
    private var id: segueId
    private init(){
        id = segueId.None
    }
    class var sharedInstance : FirstSegue {
        struct Static {
            static let instance : FirstSegue = FirstSegue()
        }
        return Static.instance
    }
    func setId (id: segueId) {
        self.id = id
    }
    func getId() -> segueId {
        return id
    }
}