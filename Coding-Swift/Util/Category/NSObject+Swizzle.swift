//
//  NSObject+Swizzle.swift
//  Coding-Swift
//
//  Created by sean on 16/4/29.
//  Copyright © 2016年 sean. All rights reserved.
//

import Foundation

extension NSObject {
    static func Swizzle(cls: AnyClass, _ origSEL: Selector, _ newSEL: Selector) {
        let originalMethod = class_getInstanceMethod(cls, origSEL)
        let swizzledMethod = class_getInstanceMethod(cls, newSEL)
        
        if originalMethod == nil {
            return
        }
        if swizzledMethod == nil {
            return;
        }
        
        let didAddedMethod = class_addMethod(cls, origSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddedMethod {
            class_replaceMethod(cls, newSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
