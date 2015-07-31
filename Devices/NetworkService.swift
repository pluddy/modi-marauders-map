//
//  NetworkService.swift
//  Devices
//
//  Created by Jon Reynolds on 7/30/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation

let NotifGetUsersFromNetworkDidComplete: String = "NotifGetUsersFromNetworkDidComplete"
let NotifUpdateLocalDeviceDidComplete: String = "NotifUpdateLocalDeviceDidComplete"
let NotifUpdateRemoteDeviceDidComplete: String = "NotifUpdateRemoteDeviceDidComplete"
let NotifRegisterDeviceDidComplete: String = "NotifRegisterDeviceDidComplete"
let NotifUserInfoPayload: String = "NotifUserInfoPayload"

class NetworkService {
    static let baseURL: String = "http://104.131.19.33:4000/"
    
    class func getUsers() {
        let getEndpoint = NetworkService.baseURL + "users.json"
        
        request(.GET, getEndpoint).responseJSON { (request, response, data, error) in
            if let anError = error {
                println("error calling GET on /users.json")
                println(anError)
            }
            else if let data: AnyObject = data {
                let json = JSON(data).arrayValue
                var users = NSMutableArray()
                
                for user in json {
                    let id = user["id"].string
                    let firstName = user["firstName"].string
                    let lastName = user["lastName"].string
                    
                    if (id != nil && firstName != nil && lastName != nil) {
                        let user = User(id: id!, firstName: firstName!, lastName: lastName!)
                        users.addObject(user)
                    }
                    else {
                        println("Did not have enough info to create user from json")
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    let info = [NotifUserInfoPayload: users] as [NSObject : AnyObject]
                    NSNotificationCenter.defaultCenter().postNotificationName(NotifGetUsersFromNetworkDidComplete, object: nil, userInfo: info)
                })
            }
        }
    }
    
    class func updateLocalDevice() {
        let device = Device.sharedInstance
        let getEndpoint = NetworkService.baseURL + "devices/" + device.getId() + ".json"
        
        request(.GET, getEndpoint).responseJSON { (request, response, data, error) in
            if let anError = error {
                println("error calling GET on /devices/\(device.getId()).json")
                println(anError)
            }
            else if let data: AnyObject = data {
                let json = JSON(data)
                
                var user: User?
                if let userData = json["user"].dictionary {
                    let id = userData["id"]?.string
                    let firstName = userData["firstName"]?.string
                    let lastName = userData["lastName"]?.string
                    
                    if (id != nil && firstName != nil && lastName != nil) {
                        user = User(id: id!, firstName: firstName!, lastName: lastName!)
                    }
                }
                
                let uuid = json["udid"].string
                let checkedOut = json["checkedOut"].bool
                
                if (uuid != nil && checkedOut != nil && uuid == device.getId()) {
                    dispatch_async(dispatch_get_main_queue(), {
                        device.setUser(user)
                        device.setStatus(checkedOut! ? Checked.Out : Checked.In, updateTime: false)
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(NotifUpdateLocalDeviceDidComplete, object: nil)
                    })
                }
                else {
                    println("Did not have enough info to create device from json")
                }
            }
        }
    }
    
    class func registerDevice() {
        let device = Device.sharedInstance
        let name = device.getFullName().stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
        let udid = device.getId()
        let platform = "iOS"
        let osVersion = device.getOsVersion()
        let checkedOut = false
        let postEndpoint = NetworkService.baseURL + "devices"
//        let postEndpoint = NetworkService.baseURL + "devices?name=\(name)&udid=\(udid)&platform=\(platform)&osVersion=\(osVersion)&checkedOut=\(checkedOut)"
        let parameters = [
            "name": device.getFullName(),
            "udid": device.getId(),
            "platform": "iOS",
            "osVersion": device.getOsVersion(),
            "checkedOut": false
        ] as [String : AnyObject]
        
        request(.POST, postEndpoint, parameters: parameters, encoding: .JSON).responseJSON { (request, response, data, error) in
            if let anError = error {
                println("error calling POST on /devices/")
                println(anError)
            }
            else if let data: AnyObject = data {
                let json = JSON(data)
                println(json)
                dispatch_async(dispatch_get_main_queue(), {
                    NSNotificationCenter.defaultCenter().postNotificationName(NotifRegisterDeviceDidComplete, object: nil)
                })
            }
        }
    }
    
    class func updateRemoteDevice() {
        let device = Device.sharedInstance
        let zone = device.getZone().rawValue
        let udid = device.getId()
        let checkedOut = device.getStatus() == Checked.Out
        
        let putEndpoint = NetworkService.baseURL + "devices/\(udid)"
        let parameters = [
            "responseType": "json",
            "udid": device.getId(),
            "checkedOut": checkedOut
            ] as [String : AnyObject]
        
        request(.PUT, putEndpoint, parameters: parameters, encoding: .JSON).responseJSON { (request, response, data, error) in
            if let anError = error {
                println("error calling PUT on /devices/")
                println(anError)
            }
            else if let data: AnyObject = data {
                let json = JSON(data)
                println(json)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                NSNotificationCenter.defaultCenter().postNotificationName(NotifUpdateRemoteDeviceDidComplete, object: nil)
            })
        }
    }
}