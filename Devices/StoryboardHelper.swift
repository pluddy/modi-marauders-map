//
//  StoryboardHelper.swift
//  Devices
//
//  Created by Jon Reynolds on 7/29/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import Foundation
import UIKit

enum ViewController {
    case OnBoarding
    case CheckIn
    case CheckOut
    
    func viewController(container: ContainerViewController) -> UIViewController {
        switch (self) {
        case OnBoarding:
            let vc = UIStoryboard.onboardViewController()
            vc.containerDelegate = container
            return vc
        case CheckIn:
            let vc = UIStoryboard.checkinViewController()
            vc.containerDelegate = container
            return vc
        case CheckOut:
            let vc = UIStoryboard.checkoutViewController()
            vc.containerDelegate = container
            return vc
        default:
            return UIViewController()
        }
    }
}

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    class func containerViewController() -> ContainerViewController {
        if let vc = mainStoryboard().instantiateViewControllerWithIdentifier("ContainerViewController") as? ContainerViewController {
            return vc
        }
        return ContainerViewController()
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
    
    class func onboardViewController() -> OnboardViewController {
        if let vc = mainStoryboard().instantiateViewControllerWithIdentifier("OnboardViewController") as? OnboardViewController {
            return vc
        }
        return OnboardViewController()
    }
}
