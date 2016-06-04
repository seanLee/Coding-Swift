//
//  AppDelegate.swift
//  Coding-Swift
//
//  Created by sean on 16/4/16.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        //Network
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening();
        NetworkActivityIndicatorManager.sharedManager.isEnabled = true;
        
        //AlamofireImage加载数据类型
        
        //customizeInterface
        customizeInterface()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        
        if Login.isLogin {
            setupTabViewController()
        } else {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            setupIntroductionViewController()
        }
        window?.makeKeyAndVisible();
        
        let startView = EaseStartView.startView()
        startView.startAnimationWithCompletionBlock { (easeStartView) in
            self.completionStartAnimationWithOptions(launchOptions)
        }
        return true
    }
    
    
    func applicationDocumentsDirectory() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!;
    }
    
}

private extension AppDelegate {
    private func customizeInterface() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHexString("0x28303b")), forBarMetrics: .Default)
        navigationBarAppearance.tintColor = UIColor.whiteColor()
        let textAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(CGFloat(kNavTitleFontSize)),
                              NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBarAppearance.titleTextAttributes = textAttributes
    }
    
    private func setupTabViewController() {
        let rootVC = RootTabViewController()
        rootVC.tabBar.translucent = true
        
        window?.rootViewController = rootVC
    }
    
    private func setupIntroductionViewController() {
        let vc = IntroductionViewController()
        window?.rootViewController = vc
    }
    
    private func completionStartAnimationWithOptions(launchOptions: [NSObject: AnyObject]?) {
        
    }
}
