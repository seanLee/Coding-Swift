//
//  UIButton+Bootstrap.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/29.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import FontAwesome_swift

enum StrapButtonStyle: Int {
    case StrapBootstrapStyle = 0
    case StrapDefaultStyle
    case StrapPrimaryStyle
    case StrapSuccessStyle
    case StrapInfoStyle
    case StrapWarningStyle
    case StrapDangerStyle
}

extension UIButton {
    func bootstrapStyle() {
        layer.borderWidth = 1.0
        layer.cornerRadius = CGRectGetHeight(self.bounds)/2.0;
        layer.masksToBounds = true
        adjustsImageWhenHighlighted = false
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.titleLabel?.font = UIFont.fontAwesomeOfSize(self.titleLabel!.font.pointSize);
    }
    
    func defaultStyle() {
        bootstrapStyle()
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.colorWithHexString("0xcccccc").CGColor
        self.setTitleColor(UIColor.colorWithHexString("0x3bbd79"), forState: .Normal)
        self.setTitleColor(UIColor.colorWithHexString("0x3bbd79"), forState: .Highlighted)
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0xe9e9e9")), forState: .Highlighted)
    }
    
    func primaryStyle() {
        bootstrapStyle()
        self.backgroundColor = UIColor.colorWithHexString("0x3bbd79")
        self.layer.borderColor = UIColor.colorWithHexString("0x3bbd79").CGColor
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0x28a464")), forState: .Highlighted)
    }
    
    func successStyle() {
        bootstrapStyle()
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0x3bbc79")), forState: .Normal)
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0x3bbc79").colorWithAlphaComponent(0.5)), forState: .Disabled)
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0x32a067")), forState: .Highlighted)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.setTitleColor(UIColor(white: 1.0, alpha: 0.5), forState: .Disabled)
        self.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    }
    
    func infoStyle() {
        bootstrapStyle()
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0x4E90BF")), forState: .Normal)
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0x4E90BF").colorWithAlphaComponent(0.5)), forState: .Disabled)
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0x4E90BF")), forState: .Highlighted)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.setTitleColor(UIColor(white: 1.0, alpha: 0.5), forState: .Disabled)
        self.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    }
    
    func warningStyle() {
        bootstrapStyle()
        self.backgroundColor = UIColor.colorWithHexString("0xff5847")
        self.layer.borderColor = UIColor.colorWithHexString("0xff5847").CGColor
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0xef4837")), forState: .Highlighted)
    }
    
    func dangerStyle() {
        bootstrapStyle()
        self.backgroundColor = UIColor.colorWithHexString("0xd9534f")
        self.layer.borderColor = UIColor.colorWithHexString("0xd43d3a").CGColor
        self.setBackgroundImage(buttonImageFromColor(UIColor.colorWithHexString("0xd23033")), forState: .Highlighted)
    }
    
    private func buttonImageFromColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private class var selArray: [Selector] {
        return [#selector(bootstrapStyle), #selector(defaultStyle), #selector(primaryStyle), #selector(successStyle),
                #selector(infoStyle), #selector(warningStyle), #selector(dangerStyle)]
    }
    
    class func buttonWithStyle(style: StrapButtonStyle, title: String, rect: CGRect, target: AnyObject, selector: Selector) -> UIButton {
        let btn = UIButton(frame: rect)
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        if btn.respondsToSelector(selArray[style.rawValue]) {
            btn.performSelector(selArray[style.rawValue])
        }
        return btn
    }
}
