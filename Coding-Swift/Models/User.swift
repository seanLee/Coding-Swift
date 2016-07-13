//
//  User.swift
//  Coding-Swift
//
//  Created by sean on 16/4/16.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import ObjectMapper

class User: Mappable {
    var avatar:String?, name:String?, global_key:String?, path:String?, slogan:String?, company:String?, tags_str:String?, tags:String?, location:String?, job_str:String?, job:String?, email:String?, birthday:String?, pinyinName:String?
    
    var curPassword:String?, resetPassword:String?, resetPasswordConfirm:String?, phone:String?, introduction:String?
    
    var id:Int?, sex:Int?, follow:Int?, followed:Int?, fans_count:Int?, follows_count:Int?, tweets_count:Int?, status:Int?, points_left:Int?, email_validation:Int?, is_phone_validated:Int?
    
    var created_at:NSDate?, last_logined_at:NSDate?, last_activity_at:NSDate?, updated_at:NSDate?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        avatar      <- map["avatar"]
        name        <- map["name"]
        global_key  <- map["global_key"]
        path        <- map["path"]
        slogan      <- map["slogan"]
        company     <- map["company"]
        tags_str    <- map["tags_str"]
        tags        <- map["tags"]
        location    <- map["location"]
        job_str     <- map["job_str"]
        job         <- map["job"]
        email       <- map["email"]
        birthday    <- map["birthday"]
        pinyinName  <- map["pinyinName"]
        phone       <- map["phone"]
        id          <- map["id"]
        sex         <- map["sex"]
        follow      <- map["follow"]
        followed    <- map["followed"]
        fans_count  <- map["fans_count"]
        status      <- map["status"]
        points_left <- map["points_left"]
        tweets_count  <- map["tweets_count"]
        introduction  <- map["introduction"]
        follows_count <- map["follows_count"]
        email_validation <- map["email_validation"]
        is_phone_validated <- map["is_phone_validated"]
        
        created_at          <- (map["created_at"], MilisecondDateTransform())
        last_logined_at     <- (map["last_logined_at"], MilisecondDateTransform())
        last_activity_at    <- (map["last_activity_at"], MilisecondDateTransform())
        updated_at          <- (map["updated_at"], MilisecondDateTransform())
    }
    
    init() {
        
    }
    
    static func userWithGlobalKey(globalKey: String) -> User {
        let user = User()
        user.global_key = globalKey
        return user
    }
    
    func isSameToUser(user: User) -> Bool {
        return (self.id == user.id) || (self.global_key == user.global_key)
    }
}

private class MilisecondDateTransform: TransformType {
    typealias Object = NSDate
    typealias JSON = Int
    
    init() {}
    
    func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let timeInt = value as? Int {
            return NSDate(timeIntervalSince1970: NSTimeInterval(timeInt/1000))
        }
        return nil
    }
    
    func transformToJSON(value: NSDate?) -> Int? {
        if let date = value {
            return Int(date.timeIntervalSince1970 * 1000)
        }
        return nil
    }
}
