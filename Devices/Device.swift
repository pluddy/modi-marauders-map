//
//  Device.swift
//  Devices
//
//  Created by Patrick Luddy on 7/28/15.
//  Copyright © 2015 Hudl. All rights reserved.
//

import Foundation
import UIKit

enum Checked {
    case In
    case Out
}

enum Zone {
    case West
    case Middle
    case East
    case Cart
    case Unknown
}

extension NSDate {
    func timeAsString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(self)
    }
}

class Device {
    private var status: Checked
    private var location: Zone
    private var user: User?
    private var timeStampChecked: NSDate?
    private var timeStampZone: NSDate?
    
    class var sharedInstance : Device {
        struct Static {
            static let instance : Device = Device()
        }
        return Static.instance
    }
    
    init(){
        self.status = Checked.In
        self.location = Zone.Unknown
    }
    
    
}