//
//  Login.swift
//  Coding-Swift
//
//  Created by sean on 16/4/26.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

private let kLoginStatus = "login_status"
private let kLoginPreUserEmail = "pre_user_email"
private let kLoginUserDict = "user_dict"
private let kLoginDataListPath = "login_data_list_path.plist"

class Login: NSObject {
    private static var _user: User?
    
    var email: String?, password: String?, j_captcha: String?
    var remember_me: Int?
}

extension Login {
    class var isLogin: Bool {
        let loginStatus = NSUserDefaults.standardUserDefaults().objectForKey(kLoginStatus)
        if let _ = loginStatus,
            let user = Login.curLoginUser {
            if user.status == 0 {
                return false
            }
            return true
        }
        return false
    }
    
    class var curLoginUser: User? {
        return User()
    }
}
