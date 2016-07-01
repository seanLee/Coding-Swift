//
//  Login.swift
//  Coding-Swift
//
//  Created by sean on 16/4/26.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import ObjectMapper

private let kLoginStatus = "login_status"
private let kLoginPreUserEmail = "pre_user_email"
private let kLoginUserDict = "user_dict"
private let kLoginDataListPath = "login_data_list_path.plist"

class Login: NSObject {
    private static var _user: User?
    
    var email: String = "", password: String = "", j_captcha: String = ""
    var remember_me: Int = 1
    
    override init() {
        super.init()
    }
    
    var toPath: String {
        return "api/v2/account/login"
    }
    
    var toParams: NSDictionary {
        var params = ["account":self.email,
                      "password":self.password.sha1Str(),
                      "remember_me":Bool(self.remember_me) ? "true" : "false"]
        if j_captcha.length > 0 {
            params["j_captcha"] = j_captcha
        }
        return params
    }
    
    func goToLoginTipWithCaptcha(needCaptcha: Bool) -> String? {
        if email.length == 0 {
            return "请填写「手机号码/电子邮箱/个性后缀」"
        }
        
        if password.length == 0 {
            return "请填写密码"
        }
        
        if needCaptcha && j_captcha.length == 0 {
            return "请填写验证码"
        }
        
        return nil
    }
    
    // MARK: - Authority
    class var curLoginUser: User? {
        if let user = _user {
            return user
        }
        let loginData = NSUserDefaults.standardUserDefaults().objectForKey(kLoginUserDict)
        _user = Mapper<User>().map(loginData)
        return _user
    }
    
    static var isLogin: Bool {
        let loginStatus = NSUserDefaults.standardUserDefaults().objectForKey(kLoginStatus)
        if let loginStatus = loginStatus,
            let user = Login.curLoginUser {
            if let _ = loginStatus.boolValue {
                if user.status == 0 {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    class func doLogin(loginData: [String : AnyObject]?) {
        if let loginData = loginData {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(NSNumber(bool: true), forKey: kLoginStatus)
            defaults.setObject(loginData, forKey: kLoginUserDict)
            _user = Mapper<User>().map(loginData)
            defaults.synchronize()
            
            saveLoginData(loginData)
        } else {
            doLogout()
        }
    }
    
    class func readLoginDataList() -> NSMutableDictionary {
        var loginDataList = NSMutableDictionary(contentsOfFile: loginDataListPath())
        if loginDataList == nil {
            loginDataList = NSMutableDictionary()
        }
        return loginDataList!
    }
    
    class func saveLoginData(loginData: [String: AnyObject]) -> Bool {
        var saved: Bool = false
        if loginData.keys.count > 0 {
            let loginDataList = readLoginDataList()
            let curUser = Mapper<User>().map(loginData)
            //save the data
            if let global_key = curUser?.global_key {
                if global_key.length > 0 {
                    loginDataList.setObject(loginData, forKey: global_key)
                    saved = true
                }
            }
            
            if let email = curUser?.email {
                if email.length > 0 {
                    loginDataList.setObject(loginData, forKey: email)
                    saved = true
                }
            }
            
            if let phone = curUser?.phone {
                if phone.length > 0 {
                    loginDataList.setObject(loginData, forKey: phone)
                    saved = true
                }
            }
            
            if saved {
                saved = loginDataList.writeToFile(loginDataListPath(), atomically: true)
            }
        }
        
        return saved
    }
    
    private class func loginDataListPath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
        return documentPath.stringByAppendingPathComponent(kLoginDataListPath)
    }
    
    class func userWithGlobaykeyOrEmail(key: String) -> User? {
        if key.length == 0 {
            return nil
        }
        let loginDataList = readLoginDataList()
        let loginData = loginDataList[key]
        return Mapper<User>().map(loginData)
    }
    
    class func doLogout() {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSNumber(bool: false), forKey: kLoginStatus)
        defaults.synchronize()
        //删除cookie
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
        if let cookies = cookies {
            for cookie in cookies {
                if cookie.domain.hasSuffix(".coding.net") {
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
                }
            }
        }
    }
    
    class func setPreUserEmail(emailStr: String) {
        if emailStr.length <= 0 {
            return
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(emailStr, forKey: kLoginPreUserEmail)
        defaults.synchronize()
    }
    
    class func preUserEmail() -> String? {
        let defauls = NSUserDefaults.standardUserDefaults()
        return defauls.objectForKey(kLoginPreUserEmail) as? String
    }
    
    class func isLoginUserGlobalKey(global_key: String) -> Bool {
        if global_key.length == 0 {
            return false
        }
        return (curLoginUser!.global_key == global_key)
    }
}
