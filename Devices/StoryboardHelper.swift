//
//  StoryboardHelper.swift
//  Devices
//
//  Created by Jon Reynolds on 7/29/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    class func checkinViewController() -> CheckinViewController {
        if let vc = mainStoryboard().instantiateViewControllerWithIdentifier("CheckinViewController") as? CheckinViewController {
            return vc
        }
        return CheckinViewController()
    }
    
    class func checkoutViewController() -> CheckoutViewController {
        if let vc = mainStoryboard().instantiateViewControllerWithIdentifier("CheckoutViewController") as? CheckoutViewController {
            return vc
        }
        return CheckoutViewController()
    }
    
    class func settingsViewController() -> SettingsViewController {
        if let vc = mainStoryboard().instantiateViewControllerWithIdentifier("SettingsViewController") as? SettingsViewController {
            return vc
        }
        return SettingsViewController()
    }
}