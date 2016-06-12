//
//  BaseViewController.swift
//  Coding-Swift
//
//  Created by sean on 16/4/29.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        if kScreenOrientation != .Portrait && (supportedInterfaceOrientations().rawValue & UIInterfaceOrientationMask.LandscapeLeft.rawValue) == 0 {
            forceChangeToOrientation(.Portrait)
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = kColorTableBG
        
        if kScreenOrientation != .Portrait && (supportedInterfaceOrientations().rawValue & UIInterfaceOrientationMask.LandscapeLeft.rawValue) == 0 {
            forceChangeToOrientation(.Portrait)
        }
    }
    
    class func presentingVC() -> UIViewController? {
        var window = UIApplication.sharedApplication().keyWindow!
        if window.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.sharedApplication().windows
            for tempWin in windows {
                if tempWin.windowLevel == UIWindowLevelNormal {
                    window = tempWin
                    break;
                }
            }
        }
        
        var result = window.rootViewController
        while let tempResult = result?.presentedViewController {
            result = tempResult
        }
        
        if result is RootTabViewController {
            result = (result as! RootTabViewController).selectedViewController
        }
        
        if result is UINavigationController {
            result = (result as! UINavigationController).topViewController
        }
        
        return result
    }
    
    // MARK: - Orientations
    override func shouldAutorotate() -> Bool {
        return UIInterfaceOrientationIsLandscape(kScreenOrientation)
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    func forceChangeToOrientation(interfaceOrientation: UIInterfaceOrientation) {
        UIDevice.currentDevice().setValue(NSNumber(integer: interfaceOrientation.rawValue), forKey: "orientation")
    }
}
