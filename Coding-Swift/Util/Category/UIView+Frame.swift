//
//  UIView+Frame.swift
//  Coding-Swift
//
//  Created by sean on 16/4/25.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

extension UIView {
    var origin: CGPoint {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
    
    var x: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var centerX: CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get {
           return self.center.y
        }
    }
    
    var size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    
    var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
           return self.frame.size.height
        }
    }
    
    var top: CGFloat {
        return CGRectGetMinY(self.frame)
    }
    
    var bottom: CGFloat {
        return CGRectGetMaxY(self.frame)
    }
    
    var left: CGFloat {
        return CGRectGetMinX(self.frame)
    }
    
    var right: CGFloat {
        return CGRectGetMaxX(self.frame)
    }
}
