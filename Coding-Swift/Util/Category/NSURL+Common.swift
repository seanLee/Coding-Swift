//
//  NSURL+Common.swift
//  Coding-Swift
//
//  Created by sean on 16/5/6.
//  Copyright © 2016年 sean. All rights reserved.
//

import Foundation

extension NSURL {
    class func addSkipBackupAttributeToItemAtURL(url: NSURL) -> Bool {
        if NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
            do {
                try url.setResourceValue(Int(true), forKey: NSURLIsExcludedFromBackupKey)
            } catch {
                return false
            }
            return true
        }
        return false
    }
}