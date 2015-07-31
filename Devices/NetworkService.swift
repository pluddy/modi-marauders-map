//
//  NetworkService.swift
//  Devices
//
//  Created by Jon Reynolds on 7/30/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation

let NotifGetUsersFromNetworkDidComplete: String = "NotifGetUsersFromNetworkDidComplete"
let NotifUpdateDeviceFromNetworkDidComplete: String = "NotifGetDeviceFromNetworkDidComplete"
let NotifPutDeviceOnNetworkDidComplete: String = "NotifPutDeviceOnNetworkDidComplete"
let NotifUserInfoPayload: String = "NotifUserInfoPayload"

class NetworkService {
    static let baseURL: String = "http://104.131.19.33:4000/"
    
    class func getUsers() {
        let getEndpoint = NetworkService.baseURL + "users.json"
        
        request(.GET, getEndpoint).responseJSON { (request, response, data, error) in
            if let anError = error {
                println("error calling GET on /users.json")
                println(error)
            }
            else if let data: AnyObject = data {
                let post = JSON(data)
                // now we have the results, let's just print them though a tableview would definitely be better UI:
                println("The post is: " + post.description)
                if let title = post["title"].string
                {
                    // to access a field:
                    println("The title is: " + title)
                }
                else
                {
                    println("error parsing /posts/1")
                }
            }
        }
        
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let getEndpoint = NetworkService.baseURL + "users.json"
            var urlRequest = NSURLRequest(URL: NSURL(string: getEndpoint)!)
            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
            var requestError = NSErrorPointer()
            
            var data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: response, error: requestError)
            if (data != nil && requestError == nil) {
                var jsonError = NSErrorPointer()
                
                if let json: NSArray = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: jsonError) as? NSArray {
                    if (jsonError == nil) {
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
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let info = [NotifUserInfoPayload: users] as [NSObject : AnyObject]
                            NSNotificationCenter.defaultCenter().postNotificationName(NotifGetUsersFromNetworkDidComplete, object: nil, userInfo: info)
                        })
                    }
                    else {
                        println("aww man, json produced an error")
                    }
                }
                else {
                    println("aww man, no json today.")
                }
            }
            else {
                println("aww man, request produced an error")
            }
        }
    }
    
    class func updateDevice() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let device = Device.sharedInstance
            let getEndpoint = NetworkService.baseURL + "devices/" + device.getId() + ".json"
            var urlRequest = NSURLRequest(URL: NSURL(string: getEndpoint)!)
            
            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
            var requestError = NSErrorPointer()
            
            var data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: response, error: requestError)
            if (data != nil && requestError == nil) {
                var jsonError = NSErrorPointer()
                
                if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: jsonError) as? NSDictionary {
                    println("Synchronous reponse: \(json)")
                    
                    if (jsonError == nil) {
                        var user: User?
                        if let userData = json["user"] as? NSDictionary {
                            let id = userData["id"] as? String
                            let firstName = userData["firstName"] as? String
                            let lastName = userData["lastName"] as? String
                            if (id != nil && firstName != nil && lastName != nil) {
                                user = User(id: id!, firstName: firstName!, lastName: lastName!)
                            }
                        }
                        
                        let uuid = json["uuid"] as? String
                        let checkedOut = json["checkedOut"] as? Bool
                        
                        if (uuid != nil && checkedOut != nil && user != nil && uuid == device.getId()) {
                            dispatch_async(dispatch_get_main_queue(), {
                                device.setUser(user!)
                                device.setStatus(checkedOut! ? Checked.Out : Checked.In, updateTime: false)
                                
                                NSNotificationCenter.defaultCenter().postNotificationName(NotifUpdateDeviceFromNetworkDidComplete, object: nil)
                            })
                        }
                        else {
                            println("aww man, no dictionary values today.")
                        }
                    }
                    else {
                        println("aww man, json produced an error")
                    }
                }
                else {
                    println("aww man, no json today.")
                }
            }
            else {
                println("aww man, request produced an error")
            }
        }
    }
    
    class func registerDevice() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let device = Device.sharedInstance
            let name = device.getFullName().stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
            let udid = device.getId()
            let platform = "iOS"
            let osVersion = device.getOsVersion()
            let checkedOut = false
            
            let postEndpoint = NetworkService.baseURL + "devices?name=\(name)&udid=\(udid)&platform=\(platform)&osVersion=\(osVersion)&checkedOut=\(checkedOut)"
            var urlRequest = NSMutableURLRequest(URL: NSURL(string: postEndpoint)!)
            urlRequest.HTTPMethod = "POST"
            
            var newPost: NSDictionary = [
                "name": device.getFullName(),
                "udid": device.getId(),
                "platform": "iOS",
                "osVersion": device.getOsVersion(),
                "checkedOut": false
            ];
            var jsonError = NSErrorPointer()
            var postJson = NSJSONSerialization.dataWithJSONObject(newPost, options: nil, error:  jsonError)
            urlRequest.HTTPBody = postJson
            
            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
            var requestError = NSErrorPointer()
            var data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: response, error: requestError)
            if (data != nil && requestError == nil) {
                var jsonError: NSError?
                
                if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) {
                    
                    if (jsonError == nil) {
                        println("Synchronous reponse: \(json)")
                        
                        println(json.description)
                    }
                    else {
                        println("aww man, json produced an error")
                    }
                }
                else {
                    jsonError != nil ? println(jsonError) : println("aww man, no json today.")
                }
            }
            else {
                println("aww man, request produced an error")
            }
        }
    }
    
//    class func updateDeviceStatus(device: Device, checkIn: Bool) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            let device = Device.sharedInstance
//            let putEndpoint = NetworkService.baseURL + "devices"
//            var urlRequest = NSMutableURLRequest(URL: NSURL(string: putEndpoint)!)
//            urlRequest.HTTPMethod = "POST"
//            
//            var newPut: NSDictionary = ["title": "Frist Psot", "body": "I iz fisrt", "userId": 1];
//            var putJsonError = NSErrorPointer()
//            var jsonPut = NSJSONSerialization.dataWithJSONObject(newPut, options: nil, error:  putJsonError)
//            urlRequest.HTTPBody = jsonPut
//            
//            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
//            var requestError = NSErrorPointer()
//            var data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: response, error: requestError)
//            if (data != nil && requestError == nil) {
//                var jsonError: NSError?
//                
//                if let json: NSArray = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSArray {
//                    
//                    if (jsonError == nil) {
//                        println("Synchronous reponse: \(json)")
//                        
//                        println(json.description)
//                    }
//                    else {
//                        println("aww man, json produced an error")
//                    }
//                }
//                else {
//                    jsonError != nil ? println(jsonError) : println("aww man, no json today.")
//                }
//            }
//            else {
//                println("aww man, request produced an error")
//            }
//        }
//    }
}