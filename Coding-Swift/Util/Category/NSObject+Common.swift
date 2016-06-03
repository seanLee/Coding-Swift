//
//  NSObject+Common.swift
//  Coding-Swift
//
//  Created by sean on 16/4/30.
//  Copyright © 2016年 sean. All rights reserved.
//

import Foundation
import MBProgressHUD

extension NSObject {
    // MARK: - Tip
    class func tipFromError(error: NSError) -> String {
        return ""
    }
    
    class func showError(error: NSError) -> Bool {
        if JDStatusBarNotification.isVisible() {
            //如果statusBar上面正在显示信息，则不再用hud显示error
            return false
        }
        let tipStr = NSObject.tipFromError(error)
        NSObject.showHudTipStr(tipStr)
        return true
    }
    
    class func showHudTipStr(tip: String) {
        if tip.length > 0 {
            let hud = MBProgressHUD.showHUDAddedTo(kKeyWindow, animated: true)
            hud.mode = MBProgressHUDModeText
            hud.detailsLabelFont = UIFont.boldSystemFontOfSize(15.0)
            hud.detailsLabelText = tip
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1.0)
        }
    }
    
    // MARK: - NetError
    func handleResponse(responseJSON: [String: AnyObject]) -> NSError? {
        return handleResponse(responseJSON, autoShowError: true)
    }
    
    func handleResponse(responseJSON: [String: AnyObject], autoShowError: Bool) -> NSError? {
        var error: NSError?
        
        let errorCode = responseJSON["code"] as! Int
        if errorCode == 1 {
            error = NSError(domain: baseUrl, code: errorCode, userInfo: responseJSON)
            if autoShowError {
                NSObject.showError(error!)
            }
        }
        return error;
    }
}
