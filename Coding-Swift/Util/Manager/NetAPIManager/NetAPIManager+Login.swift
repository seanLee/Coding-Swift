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
                        if let user = curLoginUser {
                            Login.doLogin(data)
                        }
                        block(curLoginUser, nil)
                    }
                }
            }
        }
    }
}
