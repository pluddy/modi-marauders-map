//
//  NetworkService.swift
//  Devices
//
//  Created by Jon Reynolds on 7/30/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation

let NotifGetUsersFromNetworkDidComplete: String = "NotifGetUsersFromNetworkDidComplete"
let NotifGetDeviceFromNetworkDidComplete: String = "NotifGetDeviceFromNetworkDidComplete"
let NotifPutDeviceOnNetworkDidComplete: String = "NotifPutDeviceOnNetworkDidComplete"
let NotifUserInfoPayload: String = "NotifUserInfoPayload"

class NetworkService {
    static let baseURL: String = "http://104.131.19.33:4000/"
    
    class func getUsers() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let getEndpoint = NetworkService.baseURL + "users.json"
            var urlRequest = NSURLRequest(URL: NSURL(string: getEndpoint)!)
            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
            var error = NSErrorPointer()
            
            var data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: response, error: nil)
            if data != nil {
                if let json: NSArray = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: error) as? NSArray {
                    println("Synchronous reponse: \(json)")
                    
                    var users = NSMutableArray()
                    for (var i = 0; i < json.count; i++) {
                        if let userData = json[i] as? NSDictionary {
                            let id = userData["id"] as? String
                            let firstName = userData["firstName"] as? String
                            let lastName = userData["lastName"] as? String
                            if (id != nil && firstName != nil && lastName != nil) {
                                let user = User(id: id!, firstName: firstName!, lastName: lastName!)
                                users.addObject(user)
                            }
                            else {
                                println("aww man, no dictionary values today.")
                            }
                        }
                        else {
                            println("aww man, no casting today.")
                        }
                    }
                    
                    let info = [NotifUserInfoPayload: users] as [NSObject : AnyObject]
                    NSNotificationCenter.defaultCenter().postNotificationName(NotifGetUsersFromNetworkDidComplete, object: nil, userInfo: info)
                }
                else {
                    println("aww man, no json today.")
                }
            } else {
                println("well shit, no data.")
            }
        }
    }
    
    class func getDevice(udid: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let getEndpoint = NetworkService.baseURL + udid + ".json"
            var urlRequest = NSURLRequest(URL: NSURL(string: getEndpoint)!)
            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
            var error = NSErrorPointer()
            
            var data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: response, error: nil)
            if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary {
                println("Synchronous reponse: \(json)")
                
                var user: User?
                if let userData = json["user"] as? NSDictionary {
                    let id = userData["id"] as? String
                    let firstName = userData["firstName"] as? String
                    let lastName = userData["lastName"] as? String
                    if (id != nil && firstName != nil && lastName != nil) {
                        user = User(id: id!, firstName: firstName!, lastName: lastName!)
                    }
                }
                
                let udid = json["udid"] as? String
                let checkedOut = json["checkedOut"] as? Bool
                
                if (udid != nil && checkedOut != nil && user != nil) {
                    let device = Device()
                    device.setUser(user!)
                    device.setStatus(checkedOut! ? Checked.Out : Checked.In)
                    // set user
                }
                else {
                    println("aww man, no dictionary values today.")
                }
                
//                let info = [NotifUserInfoPayload: devic] as [NSObject : AnyObject]
//                NSNotificationCenter.defaultCenter().postNotificationName(NotifGetUsersFromNetworkDidComplete, object: nil, userInfo: info)
            }
            else {
                println("aww man, no json today.")
            }
        }
    }
    
    class func registerDevice() {
        // set the user on device
    }
    
//    class func updateDeviceStatus(device: Device, checkIn: Bool) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            let getEndpoint = NetworkService.baseURL +  + ".json"
//            var urlRequest = NSURLRequest(URL: NSURL(string: getEndpoint)!)
//            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
//            var error = NSErrorPointer()
//            
//            var data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: response, error: nil)
//            if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary {
//                println("Synchronous reponse: \(json)")
//                
//                var user: User?
//                if let userData = json["user"] as? NSDictionary {
//                    let id = userData["id"] as? String
//                    let firstName = userData["firstName"] as? String
//                    let lastName = userData["lastName"] as? String
//                    if (id != nil && firstName != nil && lastName != nil) {
//                        user = User(id: id!, firstName: firstName!, lastName: lastName!)
//                    }
//                }
//                
//                let udid = json["udid"] as? String
//                let checkedOut = json["checkedOut"] as? Bool
//                
//                if (udid != nil && checkedOut != nil && user != nil) {
//                    let device = Device()
//                    device.setUser(user!)
//                    device.setStatus(checkedOut! ? Checked.Out : Checked.In)
//                    // set user
//                }
//                else {
//                    println("aww man, no dictionary values today.")
//                }
//                
//                //                let info = [NotifUserInfoPayload: devic] as [NSObject : AnyObject]
//                //                NSNotificationCenter.defaultCenter().postNotificationName(NotifGetUsersFromNetworkDidComplete, object: nil, userInfo: info)
//            }
//            else {
//                println("aww man, no json today.")
//            }
//        }
//    }
    
}