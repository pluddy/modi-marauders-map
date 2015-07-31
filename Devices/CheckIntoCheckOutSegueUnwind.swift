//
//  CheckIntoCheckOutSegue.swift
//  Devices
//
//  Created by Patrick Luddy on 7/30/15.
//  Copyright (c) 2015 Hudl. All rights reserved.
//

import UIKit

class CheckIntoCheckOutSegueUnwind: UIStoryboardSegue {
    
    override func perform() {
        var firstVCView = self.sourceViewController.view as UIView!
        var secondVCView = self.destinationViewController.view as UIView!
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        secondVCView.frame = CGRectMake(screenWidth, 0.0, screenWidth, screenHeight)
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, -screenWidth, 0.0)
            secondVCView.frame = CGRectOffset(secondVCView.frame, -screenWidth, 0.0)
            
            }) { (Finished) -> Void in
                self.sourceViewController.dismissAnimated(false as Bool)
        }
    }
    
}
