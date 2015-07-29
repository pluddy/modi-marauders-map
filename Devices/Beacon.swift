//
//  File.swift
//  Devices
//
//  Created by Patrick Luddy on 7/29/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation
import UIKit

struct Beacon {
    let UUID: String!
    let major: Int!
    let minor: Int!
    let identifier: String!
    let nearby: Bool
    let manager: ESTBeaconManager?
    
    init(UUID:String, major:Int, minor:Int, identifier:String) {
        self.UUID = UUID
        self.major = major
        self.minor = minor
        self.identifier = identifier
        self.nearby = false;
        self.manager = ESTBeaconManager()
        self.manager!.requestAlwaysAuthorization()
        self.manager!.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: self.UUID),
            major: CLBeaconMajorValue(self.major), minor: CLBeaconMinorValue(self.minor), identifier: "mintWest"))
    }
}