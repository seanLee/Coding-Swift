//
//  GlobalDefine.swift
//  Coding-Swift
//
//  Created by sean on 16/5/1.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

// MARK: - BaseUrl
let baseUrl = "https://raw.githubusercontent.com"

//版本号
let kVersion_Coding = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")
let kVersionBuild_Coding = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion")

// MARK: - kFunctionTipStr
let kFunctionTipStr_Prefix = "Prefix"

// MARK: - Define
let kNavTitleFontSize = 18.0
let kBackButtonFontSize = 16.0

// MARK: - Window
let kKeyWindow      = UIApplication.sharedApplication().keyWindow
let kScreen_Bounds  = UIScreen.mainScreen().bounds
let kScreen_Height  = kScreen_Bounds.height
let kScreen_Width   = kScreen_Bounds.width

func kScaleFrom_iPhone5_Desgin(origin: CGFloat) -> CGFloat {
    return (kScreen_Width / 320.0) * origin
}

var kDevice_Is_iPhone5: Bool {
    if let currentMode = UIScreen.mainScreen().currentMode {
        return CGSizeEqualToSize(CGSizeMake(640, 1136), currentMode.size)
    } else {
        return false
    }
}

var kDevice_Is_iPhone6: Bool {
    if let currentMode = UIScreen.mainScreen().currentMode {
        return CGSizeEqualToSize(CGSizeMake(750, 1334), currentMode.size)
    } else {
        return false
    }
}

var kDevice_Is_iPhone6Plus: Bool {
    if let currentMode = UIScreen.mainScreen().currentMode {
        return CGSizeEqualToSize(CGSizeMake(1242, 2208), currentMode.size)
    } else {
        return false
    }
}