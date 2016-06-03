//
//  FunctionTipsManager.swift
//  Coding-Swift
//
//  Created by sean on 16/5/6.
//  Copyright © 2016年 sean. All rights reserved.
//

import Foundation

private let kFunctionTipStr_Version = "version"

class FunctionTipsManager: NSObject {
    private static var share_manager: FunctionTipsManager?
    
    var tipsDict: NSMutableDictionary
    
    class func shareManager() -> FunctionTipsManager {
        var onceToken:dispatch_once_t = 0
        dispatch_once(&onceToken) {
            share_manager = FunctionTipsManager()
        }
        return share_manager!
    }
    
    override init() {
        tipsDict = NSMutableDictionary(contentsOfFile: FunctionTipsManager.p_cacheFilePath)!
        if let version = tipsDict.valueForKey("version") {
            if !version.isEqual(kVersionBuild_Coding) {
                tipsDict = NSMutableDictionary(object: kVersionBuild_Coding!, forKey: kFunctionTipStr_Version)
                tipsDict.writeToFile(FunctionTipsManager.p_cacheFilePath, atomically: true)
            }
        }
        super.init()
        
    }
    
    static var p_cacheFilePath: String {
        let fileName = "FunctionNeedTips.plist"
        let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first
        return (cachePath! as NSString).stringByAppendingPathComponent(fileName)
    }
    
    func needToTip(functionStr: String) -> Bool {
        let needToTip = tipsDict.valueForKey(functionStr) as! Bool
        if needToTip {
            return functionStr.hasPrefix(kFunctionTipStr_Prefix)
        }
        return needToTip
    }
    
    func markTiped(functionStr: String) -> Bool {
        if !needToTip(functionStr) {
            return false
        }
        tipsDict.setValue(false, forKey: functionStr)
        return tipsDict.writeToFile(FunctionTipsManager.p_cacheFilePath, atomically: true)
    }
}