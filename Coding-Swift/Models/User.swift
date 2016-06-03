//
//  User.swift
//  Coding-Swift
//
//  Created by sean on 16/4/16.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class User: NSObject {
    var avatar:String?, name:String?, global_key:String?, path:String?, slogan:String?, company:String?, tags_str:String?, tags:String?, location:String?, job_str:String?, job:String?, email:String?, birthday:String?, pinyinName:String?
    
    var curPassword:String?, resetPassword:String?, resetPasswordConfirm:String?, phone:String?, introduction:String?
    
    var id:Int?, sex:Int?, follow:Int?, followed:Int?, fans_count:Int?, follows_count:Int?, tweets_count:Int?, status:Int?, points_left:Int?, email_validation:Int?, is_phone_validated:Int?
    
    var created_at:NSDate?, last_logined_at:NSDate?, last_activity_at:NSDate?, updated_at:NSDate?
}

extension User {
    static func userWithGlobalKey(globalKey: String) -> User {
        let user = User()
        user.global_key = globalKey
        return user
    }
    
    func isSameToUser(user: User) -> Bool {
        return (self.id == user.id) || (self.global_key == user.global_key)
    }
}
