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

    let beaconManager = ESTBeaconManager()
    let NotificationCheckOutCategoryId = "CHECK_IN"
    let NotificationCheckOutActionId = "ACTION_CHECK_IN"
    
    func newRootViewController(vc: UIViewController) {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard.mainStoryboard()
        
        self.window!.rootViewController = vc
        self.window!.makeKeyAndVisible()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.beaconManager.delegate = self
        
        self.beaconManager.requestAlwaysAuthorization()
        
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
            major: 40435, minor: 8969, identifier: "Device Cart"))
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        
        if (!NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce")) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
            //TODO: Sync device information with server on first launch
        }
        
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
        let notification = UILocalNotification()
        notification.soundName = "Hello"
        notification.alertBody = "✅Checked in! Thanks!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    func beaconManager(manager: AnyObject!, didExitRegion region: CLBeaconRegion!) {
        let notification = UILocalNotification()
        notification.alertBody = "Please Check Out this Device"
        notification.alertAction = "check out"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
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

