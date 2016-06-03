//
//  BaseNavigationController.swift
//  Coding-Swift
//
//  Created by sean on 16/4/29.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func shouldAutorotate() -> Bool {
        return self.visibleViewController!.shouldAutorotate()
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return self.visibleViewController!.preferredInterfaceOrientationForPresentation()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if self.visibleViewController!.isKindOfClass(UIAlertController.classForCoder()) {
            return self.visibleViewController!.supportedInterfaceOrientations()
        } else {
            return .Portrait
        }
    }
}
