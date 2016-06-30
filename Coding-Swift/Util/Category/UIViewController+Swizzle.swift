//
//  UIViewController+Swizzle.swift
//  Coding-Swift
//
//  Created by sean on 16/4/29.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

extension UIViewController {
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UIViewController.self {
            return
        }
        
        dispatch_once(&Static.token) {
            Swizzle(self, #selector(viewWillAppear(_:)), #selector(viewWillAppear_swizzle(_:)))
            Swizzle(self, #selector(viewDidAppear(_:)), #selector(viewDidAppear_swizzle(_:)));
            Swizzle(self, #selector(viewWillDisappear(_:)), #selector(viewWillDisappear_swizzle(_:)))
        }
    }
    
    // MARK: - Customer BackButton
    private func backButton() -> UIBarButtonItem {
        var textArributes: Dictionary<String, AnyObject>?
        let temporaryBarButtonItem = UIBarButtonItem()
        temporaryBarButtonItem.title = "返回"
        temporaryBarButtonItem.target = self
        if temporaryBarButtonItem.respondsToSelector(#selector(temporaryBarButtonItem.setTitleTextAttributes(_:forState:))) {
            //Set Title
            textArributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(CGFloat(kBackButtonFontSize)),
                             NSForegroundColorAttributeName: UIColor.whiteColor()]
            UIBarButtonItem.appearance().setTitleTextAttributes(textArributes, forState: .Normal)
            //Set Image
            let backButtonImage = UIImage.init(named: "backButtonBackImage")?.resizableImageWithCapInsets(UIEdgeInsetsMake(16, 16, 0, 0))
            temporaryBarButtonItem.setBackButtonBackgroundImage(backButtonImage, forState: .Normal, barMetrics: .Default)
        }
        temporaryBarButtonItem.action = #selector(goBack_Swizzle)
        return temporaryBarButtonItem
    }
    
    @objc private func goBack_Swizzle() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Private Method
    @objc private func viewWillAppear_swizzle(animated: Bool) {
        viewWillAppear_swizzle(animated)
    }
    
    @objc private func viewDidAppear_swizzle(animated: Bool) {
        viewDidAppear_swizzle(animated)
    }
    
    @objc private func viewWillDisappear_swizzle(animated: Bool) {
        viewWillDisappear_swizzle(animated)
        if self.navigationItem.backBarButtonItem == nil && self.navigationController?.viewControllers.count > 1 {
            self.navigationItem.backBarButtonItem = self.backButton()
        }
    }
    
}
