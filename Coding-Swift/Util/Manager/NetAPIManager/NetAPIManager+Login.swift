//
//  NetAPIManager+Login.swift
//  Coding-Swift
//
//  Created by Sean on 16/7/12.
//  Copyright © 2016年 sean. All rights reserved.
//

import Foundation
import ObjectMapper

extension NetAPIManager {
    func request_Login(path: String, params: [String:AnyObject], block: (AnyObject?, NSError?) -> Void) {
        let router = Router(requestMethod: RequestMethod.Post(path, params))
        NetAPIClient.sharedInstance().requestData(router) { (result, error) in
            guard error == nil else {
                block(nil, error)
                return
            }
            if let keyValues = result?["data"] {
                let data = keyValues as! [String : AnyObject]
                let unreadRouter = Router(requestMethod: RequestMethod.Get("api/user/unread-count", nil))
                NetAPIClient.sharedInstance().requestData(unreadRouter) { (result, error_check) in //检查当前帐号未设置邮箱或GK
                    if error_check?.userInfo["msg"]?["user_need_activate"] != nil {
                        block(nil, error_check)
                    } else {
                        let curLoginUser = Mapper<User>().map(data)
                        if curLoginUser != nil {
                            Login.doLogin(data)
                        }
                        block(curLoginUser, nil)
                    }
                }
            }
        }
    }
    
    func request_SendActivateEmail(email: String, block: (AnyObject?, NSError?) -> Void) {
        let router = Router(requestMethod: RequestMethod.Post("api/account/register/email/send", ["email":email]))
        NetAPIClient.sharedInstance().requestData(router) { (result, error) in
            if let result = result {
                let value = result["data"] as! Int
                if Bool(value) {
                    block(result, nil)
                } else {
                    NSObject.showHudTipStr("发送失败")
                    block(nil, nil)
                }
            } else {
                 block(nil, error)
            }
        }
    }
    
    func request_CaptchaNeeded(path: String, block: (AnyObject?, NSError?) -> Void) {
        let router = Router(requestMethod: RequestMethod.Get(path, nil))
        NetAPIClient.sharedInstance().requestData(router) { (result, error) in
            if let result = result {
                let value = result["data"]
                block(value, nil)
            } else {
                block(nil, error)
            }
        }
    }
}
