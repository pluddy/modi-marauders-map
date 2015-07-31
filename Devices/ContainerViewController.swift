//
//  ContainerViewController.swift
//  Devices
//
//  Created by Jon Reynolds on 7/31/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    private var currentViewController: UIViewController?
    var isFirstLaunch = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if (isFirstLaunch) {
            NetworkService.registerDevice()
        }
        else {
            NetworkService.updateLocalDevice()
        }
        
        var vc: UIViewController!
        if (isFirstLaunch) {
            // onboarding
            vc = ViewController.OnBoarding.viewController(self)
            isFirstLaunch = false
        }
        else if (Device.sharedInstance.getStatus() != Checked.In) {
            // checkin
            vc = ViewController.CheckIn.viewController(self)
        }
        else {
            // checkout
            vc = ViewController.CheckOut.viewController(self)
        }
        startWithViewController(vc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startWithViewController(vc: UIViewController) {
        self.view.addSubview(vc.view)
        vc.view.center = self.view.center
        self.addChildViewController(vc)
        vc.didMoveToParentViewController(self)
        
        self.currentViewController = vc
    }
    
    func switchToViewController(newVC: UIViewController) {
        if let oldVC = self.currentViewController {
            self.view.addSubview(newVC.view)
            newVC.view.center = CGPoint(x: self.view.frame.width * 1.5, y: self.view.center.y)
            
            self.addChildViewController(newVC)
            newVC.didMoveToParentViewController(self)
            
            // slide new vc onto screen and old off screen
            UIView.animateWithDuration(0.5, animations: {
                oldVC.view.center.x -= self.view.frame.width
                newVC.view.center.x = self.view.center.x
                }, completion: { (finished: Bool) -> () in
                    oldVC.removeFromParentViewController()
                    // update currentVC
                    self.currentViewController = newVC
            })
        }
    }
}
