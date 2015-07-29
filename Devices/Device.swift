//
//  Device.swift
//  Devices
//
//  Created by Patrick Luddy on 7/28/15.
//  Copyright © 2015 Hudl. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
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
    

}

class Device {
    var status: UIDevice.Checked
    var location: UIDevice.Zone
    var user: String
    var timeStamp: NSDate
    
    init(checked: UIDevice.Checked, location: UIDevice.Zone, user: String, time: NSDate){
        self.status = checked
        self.location = location
        self.user = user
        self.timeStamp = time
    }
    
    func timeAsString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(timeStamp)
    }
}