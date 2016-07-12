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
        if error.userInfo.count > 0 {
            var tipStr = ""
            if (error.userInfo["msg"] != nil)  {
                let msgArray = error.userInfo["msg"] as! [String: String]
                for value in msgArray.enumerate() {
                    let msgStr = value.element.1
                    if value.index + 1 < msgArray.count {
                        tipStr.appendContentsOf("\(msgStr)\n")
                    } else {
                        tipStr.appendContentsOf("\(msgStr)")
                    }
                }
            } else {
                if error.userInfo["NSLocalizedDescription"] != nil {
                    tipStr = error.userInfo["NSLocalizedDescription"] as! String
                } else {
                    tipStr.appendContentsOf("ErrorCode\(error.code)")
                }
            }
            return tipStr
        }
        return " "
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
        if errorCode != 0 {
            error = NSError(domain: baseUrl, code: errorCode, userInfo: responseJSON) as NSError
            if errorCode == 1000 || errorCode == 3207 { //用户未登陆
                if Login.isLogin {
                    Login.doLogout() //已经登录的状态要清除
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(1.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                    (UIApplication.sharedApplication().delegate as! AppDelegate).setupLoginViewController()
                    kTipAlert(NSObject.tipFromError(error!))
                })
            } else {
                var params = [String: AnyObject]()
                if errorCode == 907 { //每日新关注用户超过20
                    params["type"] = 3
                } else if errorCode == 1018 { //操作太频繁
                    params["type"] = 1
                }
                if params.count > 0 {
                    NSObject.showHudTipStr("发生错误")
                }
                if autoShowError {
                    NSObject.showError(error!)
                }
            }
        }
        return error;
    }
}
