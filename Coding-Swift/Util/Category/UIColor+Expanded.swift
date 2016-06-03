//
//  UIColor+Expanded.swift
//  Coding-Swift
//
//  Created by sean on 16/4/25.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

extension UIColor {
    // MARK: - Property
    var colorSpaceModel: CGColorSpaceModel {
        return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor))
    }
    
    var canProvideRGBComponents: Bool {
        switch self.colorSpaceModel {
        case .RGB , .Monochrome:
            return true
        default:
            return false
        }
    }
    
    var red: CGFloat {
        assert(self.canProvideRGBComponents, "Must be an RGB color to use -red")
        let c = CGColorGetComponents(self.CGColor)
        return c[0]
    }
    
    var green: CGFloat {
        assert(self.canProvideRGBComponents, "Must be an RGB color to use -green")
        let c = CGColorGetComponents(self.CGColor)
        if self.colorSpaceModel == .Monochrome { return c[0]}
        return c[1]
    }
    
    var blue: CGFloat {
        assert(self.canProvideRGBComponents, "Must be an RGB color to use -blue")
        let c = CGColorGetComponents(self.CGColor)
        if self.colorSpaceModel == .Monochrome { return c[0]}
        return c[2]
    }
    
    var white: CGFloat {
        assert(self.colorSpaceModel == .Monochrome, "Must be a Monochrome color to use -white")
        let c = CGColorGetComponents(self.CGColor);
        return c[0];
    }
    
    var alpha: CGFloat {
        return CGColorGetAlpha(self.CGColor)
    }
    
    var rgbHex: UInt32 {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use rgbHex")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return 0}
        
        r = min(max(self.red, 0.0), 1.0)
        g = min(max(self.green, 0.0), 1.0)
        b = min(max(self.blue, 0.0), 1.0)
        
        return ((UInt32(round(r * 255)) << 16)
            | (UInt32(round(g * 255).native) << 8)
            | (UInt32(round(b * 255).native)))
    }
    
    // MARK: - Function
    func colorSpaceString() -> String {
        switch self.colorSpaceModel {
        case .Unknown:
            return "kCGColorSpaceModelUnknown"
        case .Monochrome:
            return "kCGColorSpaceModelMonochrome"
        case .RGB:
            return "kCGColorSpaceModelRGB"
        case .CMYK:
            return "kCGColorSpaceModelCMYK"
        case .Lab:
            return "kCGColorSpaceModelLab"
        case .DeviceN:
            return "kCGColorSpaceModelDeviceN"
        case .Indexed:
            return "kCGColorSpaceModelIndexed"
        case .Pattern:
            return "kCGColorSpaceModelPattern"
        }
    }
    
    func arrayFromRGBAComponents() -> Array<NSNumber>? {
        assert(self.canProvideRGBComponents, "Must be an RGB color to use -arrayFromRGBAComponents")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return [NSNumber(double: r.native), NSNumber(double: g.native), NSNumber(double: b.native), NSNumber(double: a.native)]
    }
    
    func red(inout red: CGFloat, inout green: CGFloat, inout blue: CGFloat, inout alpha: CGFloat) -> Bool {
        let components = CGColorGetComponents(self.CGColor)
        
        var r: CGFloat?, g: CGFloat?, b: CGFloat?, a: CGFloat?
        
        switch self.colorSpaceModel {
        case .Monochrome:
            r = components[0]
            g = r
            b = r
            a = components[1]
        case .RGB:
            r = components[0]
            g = components[1]
            b = components[2]
            a = components[3]
        default:
            return false
        }
        
        if !(red.isNaN)       { red = r! }
        if !(green.isNaN)     { green = g! }
        if !(blue.isNaN)      { blue = b! }
        if !(alpha.isNaN)     { alpha = a! }
        
        return true
    }
    
    // MARK: - Arithmetic operations
    func colorByLuminanceMapping() -> UIColor? {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use arithmatic operations")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return UIColor(white: (r*0.2126 + g*0.7152 + b*0.0722), alpha: a)
    }
    
    func colorByMultiplyingByRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor? {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use arithmatic operations")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return UIColor(red: max(0.0, min(1.0, r * red)),
                       green: max(0.0, min(1.0, g * green)),
                       blue: max(0.0, min(1.0, b * blue)),
                       alpha: max(0.0, min(1.0, a * alpha)))
    }
    
    func colorByAddingRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor? {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use arithmatic operations")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return UIColor(red: max(0.0, min(1.0, r + red)),
                       green: max(0.0, min(1.0, g + green)),
                       blue: max(0.0, min(1.0, b + blue)),
                       alpha: max(0.0, min(1.0, a + alpha)))
    }
    
    func colorByLighteningToRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor? {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use arithmatic operations")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return UIColor(red: max(r, red),
                       green: max(g, green),
                       blue: max(b, blue),
                       alpha: max(a, alpha))
    }
    
    func colorByDarkeningToRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor? {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use arithmatic operations")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return UIColor(red: min(r, red),
                       green: min(g, green),
                       blue: min(b, blue),
                       alpha: min(a, alpha))
    }
    
    func colorByMultiplyingBy(time: CGFloat) -> UIColor? {
        return colorByMultiplyingByRed(time, green: time, blue: time, alpha: 1.0)
    }
    func colorByAdding(time: CGFloat) -> UIColor? {
        return colorByAddingRed(time, green: time, blue: time, alpha: 0.0)
    }
    func colorByLighteningTo(time: CGFloat) -> UIColor? {
        return colorByLighteningToRed(time, green: time, blue: time, alpha: 0.0)
    }
    func colorByDarkeningTo(time: CGFloat) -> UIColor? {
        return colorByDarkeningToRed(time, green: time, blue: time, alpha: 1.0)
    }
    
    func colorByMultiplyingByColor(color: UIColor) -> UIColor? {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use arithmatic operations")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return colorByMultiplyingByRed(r, green: g, blue: b, alpha: 1.0)
    }
    
    func colorByAddingColor(color: UIColor) -> UIColor? {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use arithmatic operations")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return colorByAddingRed(r, green: g, blue: b, alpha: 0.0)
    }
    
    func colorByLighteningToColor(color: UIColor) -> UIColor? {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use arithmatic operations")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return colorByLighteningToRed(r, green: g, blue: b, alpha: 0.0)
    }
    
    func colorByDarkeningToColor(color: UIColor) -> UIColor? {
        assert(self.canProvideRGBComponents, "Must be a RGB color to use arithmatic operations")
        
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        if !self.red(&r, green: &g, blue: &b, alpha: &a) { return nil}
        
        return colorByDarkeningToRed(r, green: g, blue: b, alpha: 1.0)
    }
    
    // MARK: - String utilities
    func stringFromColor() -> String {
        assert(self.canProvideRGBComponents, "Must be an RGB color to use -stringFromColor")
        
        switch self.colorSpaceModel {
        case .RGB:
            return String(format: "{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha)
        case .Monochrome:
            return String(format: "{%0.3f, %0.3f}", self.white, self.alpha)
        default:
            return ""
        }
    }
    
    func hexStringFromColor() -> String {
        return String(format: "%0.6X", self.rgbHex)
    }
    
    func isDark() -> Bool {
        let gray = self.red * 0.299 + self.green * 0.587 + self.blue * 0.114;//纯白为1，纯黑为0
        return gray < (186.0/255.0)
    }
    
    class func colorWithString(stringToConvert: String) -> UIColor? {
        let scanner = NSScanner.init(string: stringToConvert)
        if !(scanner.scanString("{", intoString: nil)) { return nil}
        
        let kMaxComponents = 4
        
        var c = Array.init(count: kMaxComponents, repeatedValue: 0.0 as Float)
        
        var i: Int = 0
        if !(scanner.scanFloat(&c[i])) { return nil}
        i += 1
        while true {
            if scanner.scanString("}", intoString: nil) { break}
            if i >= kMaxComponents { return nil}
            if scanner.scanString(",", intoString: nil) {
                if !(scanner.scanFloat(&c[i])) { return nil}
                i += 1
            } else {
                return nil
            }
        }
        if !scanner.atEnd { return nil}
        var color: UIColor?
        switch i {
        case 2:
            color = UIColor(white: CGFloat(c[0]), alpha: CGFloat(c[1]))
        case 4:
            color = UIColor(red: CGFloat(c[0]), green: CGFloat(c[1]), blue: CGFloat(c[2]), alpha: CGFloat(c[3]))
        default:
            color = nil
        }
        return color
    }
    
    // MARK: - Class methods
    class func randomColor() -> UIColor {
        return UIColor(red: (CGFloat(arc4random())%256)/256.0,
                       green: (CGFloat(arc4random())%256)/256.0,
                       blue: (CGFloat(arc4random())%256)/256.0,
                       alpha: 1.0)
    }
    
    class func colorWithRGBHex(hex: UInt32) -> UIColor {
        let r = (hex >> 16) & 0xFF
        let g = (hex >> 8)  & 0xFF
        let b = (hex)       & 0xFF
        
        return UIColor(red: CGFloat(r) / 255.0,
                       green: CGFloat(g) / 255.0,
                       blue: CGFloat(b) / 255.0,
                       alpha: 1.0)
    }
    
    class func colorWithHexString(stringToConvert: String) -> UIColor {
        let scanner = NSScanner(string: stringToConvert)
        var hexNum: UInt32 = 0
        if !(scanner.scanHexInt(&(hexNum))) { return UIColor.clearColor()}
        return UIColor.colorWithRGBHex(hexNum)
    }
}
