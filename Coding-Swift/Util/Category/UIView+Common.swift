//
//  UIView+Common.swift
//  Coding-Swift
//
//  Created by sean on 16/5/23.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

extension UIView {
    func setBorderColor(borderColor: UIColor) {
        layer.borderColor = borderColor.CGColor
    }
    
    func setBorderWidth(borderWidth: CGFloat) {
        layer.borderWidth = borderWidth
    }
    
    func setCornerRadius(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
    
    func setMaskToBounds(maskToBounds: Bool) {
        layer.masksToBounds = maskToBounds
    }
    
    func doCircleFrame() {
        layer.masksToBounds = true
        layer.cornerRadius = self.width / 2.0
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.colorWithHexString("0xdddddd").CGColor
    }
    
    func doNotCirleFrame() {
        layer.cornerRadius = 0.0
        layer.borderWidth = 0.0
    }
    
    func doubleSizeOfFrame() -> CGSize {
        return CGSize(width: self.width*2, height: self.height*2)
    }
}
