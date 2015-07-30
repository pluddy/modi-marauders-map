//
//  AppDelegate.swift
//  Devices
//
//  Created by Patrick Luddy on 7/27/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard?
    var checkinViewController: UIViewController?
    var checkoutViewController: UIViewController?

    let NotifDeviceZoneDidChange = "NotifDeviceZoneDidChange"
    let beaconManager = ESTBeaconManager()
    let NotificationCheckOutCategoryId = "CHECK_IN"
    let NotificationCheckOutActionId = "ACTION_CHECK_IN"
    
    var beaconCart = false
    var beaconWest = false
    var beaconEast = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if (!NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //TODO: Register device with the server
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        self.checkinViewController = storyboard!.instantiateViewControllerWithIdentifier("CheckinViewController") as? UIViewController
        self.checkoutViewController = storyboard!.instantiateViewControllerWithIdentifier("CheckoutViewController") as? UIViewController
        if (Device.sharedInstance.getStatus() != Checked.In){
            self.window!.rootViewController = checkinViewController
        } else {
            self.window!.rootViewController = checkoutViewController
        }
        self.window!.makeKeyAndVisible()
        
        println(UIDevice.currentDevice().identifierForVendor.UUIDString)
        
        self.beaconManager.delegate = self
        
        self.beaconManager.requestAlwaysAuthorization()
        
        //West Region beacon
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
            major: 31206, minor: 28466, identifier: "mintWest"))
        
        //Cart beacon
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
            major: 18712, minor: 42723, identifier: "blueberryCart"))
        
        //East Region beacon
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
            major: 40435, minor: 8969, identifier: "iceEast"))
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func beaconManager(manager: AnyObject!, didEnterRegion region: CLBeaconRegion!) {
        switch(region.identifier){
        case "blueberryCart":
            beaconCart = true
            println("Entered Blueberry Cart Zone")
            break
        case "iceEast":
            beaconEast = true
            println("Entered Ice East Zone")
            break
        case "mintWest":
            beaconWest = true
            println("Entered Mint West Zone")
            break
        default:
            break
        }
        updateDeviceZoneFromActiveBeacons()
    }
    
    func beaconManager(manager: AnyObject!, didExitRegion region: CLBeaconRegion!) {
        switch(region.identifier){
        case "blueberryCart":
            beaconCart = false
            println("Exited Blueberry Cart Zone")
            break
        case "iceEast":
            beaconEast = false
            println("Exited Ice East Zone")
            break
        case "mintWest":
            beaconWest = false
            println("Exited Mint West Zone")
            break
        default:
            break
        }
        updateDeviceZoneFromActiveBeacons()
    }
    
    func updateDeviceZoneFromActiveBeacons() {
        var newZone: Zone
        if (beaconCart) {
            newZone = Zone.Cart
        } else if (beaconWest && beaconEast) {
            newZone = Zone.Middle
        } else if (!beaconWest && beaconEast) {
            newZone = Zone.East
        } else if (beaconWest && !beaconEast) {
            newZone = Zone.West
        } else {
            newZone = Zone.Unknown
        }
        
        Device.sharedInstance.setLocation(newZone)
        NSNotificationCenter.defaultCenter().postNotificationName(NotifDeviceZoneDidChange, object: nil)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.github.com")!)
    }
    
    func registerForNotification() {
        let checkoutAction = UIMutableUserNotificationAction()
        checkoutAction.activationMode = UIUserNotificationActivationMode.Background
        checkoutAction.title = "Check Out"
        checkoutAction.identifier = NotificationCheckOutActionId
        checkoutAction.destructive = false
        checkoutAction.authenticationRequired = false
        
        let checkoutCategory = UIMutableUserNotificationCategory()
        checkoutCategory.identifier = NotificationCheckOutCategoryId
        checkoutCategory.setActions([checkoutAction], forContext: UIUserNotificationActionContext.Default)
        
        let categories = Set<UIUserNotificationCategory>([checkoutCategory])
        let checkoutSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: categories)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(checkoutSettings)
    }
}

