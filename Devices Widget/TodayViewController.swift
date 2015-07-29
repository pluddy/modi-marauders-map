//
//  TodayViewController.swift
//  Devices Widget
//
//  Created by Patrick Luddy on 7/28/15.
//  Copyright © 2015 Hudl. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var label: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if (Device.status = UIDevice.Checked.In) {
//            
//        }
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NoData)
    }
    
}
