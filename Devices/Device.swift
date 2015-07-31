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

enum Zone: String{
    case West = "West"
    case East = "East"
    case Cart = "Cart"
    case Unknown = "Unknown"
}

enum BeaconLocation {
    case West
    case Cart
    case East
}

public enum DeviceTypes : String {
    case simulator      = "Simulator"
    case iPad2          = "iPad 2"
    case iPad3          = "iPad 3"
    case iPhone4        = "iPhone 4"
    case iPhone4S       = "iPhone 4S"
    case iPhone5        = "iPhone 5"
    case iPhone5S       = "iPhone 5S"
    case iPhone5c       = "iPhone 5c"
    case iPad4          = "iPad 4"
    case iPadMini1      = "iPad Mini 1"
    case iPadMini2      = "iPad Mini 2"
    case iPadAir1       = "iPad Air 1"
    case iPadAir2       = "iPad Air 2"
    case iPhone6        = "iPhone 6"
    case iPhone6plus    = "iPhone 6 Plus"
    case unrecognized   = "?unrecognized?"
}

public extension UIDevice {
    public var deviceType: DeviceTypes {
        var sysinfo : [CChar] = Array(count: sizeof(utsname), repeatedValue: 0)
        let modelCode = sysinfo.withUnsafeMutableBufferPointer {
            (inout ptr: UnsafeMutableBufferPointer<CChar>) -> DeviceTypes in
            uname(UnsafeMutablePointer<utsname>(ptr.baseAddress))
            // skip 1st 4 256 byte sysinfo result fields to get "machine" field
            let machinePtr = advance(ptr.baseAddress, Int(_SYS_NAMELEN * 4))
            var modelMap : [ String : DeviceTypes ] = [
                "i386"      : .simulator,
                "x86_64"    : .simulator,
                "iPad2,1"   : .iPad2,          //
                "iPad3,1"   : .iPad3,          // (3rd Generation)
                "iPhone3,1" : .iPhone4,        //
                "iPhone3,2" : .iPhone4,        //
                "iPhone4,1" : .iPhone4S,       //
                "iPhone5,1" : .iPhone5,        // (model A1428, AT&T/Canada)
                "iPhone5,2" : .iPhone5,        // (model A1429, everything else)
                "iPad3,4"   : .iPad4,          // (4th Generation)
                "iPad2,5"   : .iPadMini1,      // (Original)
                "iPhone5,3" : .iPhone5c,       // (model A1456, A1532 | GSM)
                "iPhone5,4" : .iPhone5c,       // (model A1507, A1516, A1526 (China), A1529 | Global)
                "iPhone6,1" : .iPhone5S,       // (model A1433, A1533 | GSM)
                "iPhone6,2" : .iPhone5S,       // (model A1457, A1518, A1528 (China), A1530 | Global)
                "iPad4,1"   : .iPadAir1,       // 5th Generation iPad (iPad Air) - Wifi
                "iPad4,2"   : .iPadAir2,       // 5th Generation iPad (iPad Air) - Cellular
                "iPad4,4"   : .iPadMini2,      // (2nd Generation iPad Mini - Wifi)
                "iPad4,5"   : .iPadMini2,      // (2nd Generation iPad Mini - Cellular)
                "iPhone7,1" : .iPhone6plus,    // All iPhone 6 Plus's
                "iPhone7,2" : .iPhone6         // All iPhone 6's
            ]
            if let model = modelMap[String.fromCString(machinePtr)!] {
                return model
            }
            return DeviceTypes.unrecognized
        }
        return modelCode
    }
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
    private var fullName: String!
    private var color = String()
            
    class var sharedInstance : Device {
        struct Static {
            static let instance : Device = Device()
        }
        return Static.instance
    }
    
    private init() {
        self.status = Checked.In
        self.location = Zone.Unknown
    }
    
    func setUser(user: User?) {
        self.user = user
    }
    
    func getUser() -> User? {
        return self.user
    }
    
    func setStatus(checked: Checked, updateTime: Bool) {
        self.status = checked
        if (updateTime) {
            self.timeStampChecked = NSDate()
        }
    }
    
    func getStatus() -> Checked {
        return self.status
    }
    
    func setZone(location: Zone) {
        self.location = location
        self.timeStampZone = NSDate()
    }
    
    func getZone() -> Zone {
        return self.location
    }
    
    func getId() -> String {
        return UIDevice.currentDevice().identifierForVendor.UUIDString
    }
    
    func setColor(color: String) {
        self.color = color
    }
    
    func getColor() -> String {
        return self.color
    }
    
    func getOsVersion() -> String {
        return UIDevice.currentDevice().systemVersion
    }
    
    func getFullName() -> String{
        let device = UIDevice.currentDevice()
        var fullName = ""
        
        if (!color.isEmpty) {
            fullName = color + " "
        }
        fullName = fullName + self.getCapacity() + " " + self.getDevice() + " iOS " + device.systemVersion
        
        return fullName
    }
    
    func getCapacity() -> String {
        var totalSpace: UInt64 = 0
        var totalFreeSpace: UInt64 = 0
        var errorPtr = NSErrorPointer()
        var paths: NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let path = paths.lastObject as! String
        
        if let dictionary = NSFileManager.defaultManager().attributesOfFileSystemForPath(path, error: errorPtr) {
            let fileSystemSizeInBytes: NSNumber = dictionary[NSFileSystemSize] as! NSNumber
            totalSpace = fileSystemSizeInBytes.unsignedLongLongValue
        }
        
        return String(totalSpace / 1073741824) + "GB"
    }
    
    func getDevice() -> String {
        let type = UIDevice.currentDevice().deviceType
        return type.rawValue
    }
}