//
//  String+Common.swift
//  Coding-Swift
//
//  Created by sean on 16/4/26.
//  Copyright © 2016年 sean. All rights reserved.
//

import Foundation
import RegexKitLite

extension String {
    // MARK: - Security
    func md5Str() -> String {
        let data = self.cStringUsingEncoding(NSUTF8StringEncoding)!
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        var result = [UInt8](count: digestLen, repeatedValue: 0)
        CC_MD5(data, strLen, &result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        return String(format: hash as String)
    }
    
    func sha1Str() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        var result = [UInt8](count: digestLen, repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        return hash as String
    }
    
    // MARK: - Length
    func trimWhitespace() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    var length: Int {
        return self.trimWhitespace().characters.count
    }
    
    // MARK: - Size
    func getSizeWithFont(font: UIFont, constrainedToSize: CGSize) -> CGSize {
        var resultSize = CGSizeZero
        if self.length == 0 {
            return resultSize
        }
        resultSize = (self as NSString).boundingRectWithSize(constrainedToSize, options: [.UsesFontLeading, .UsesLineFragmentOrigin], attributes: [NSFontAttributeName:font], context: nil).size
        resultSize = CGSizeMake(min(constrainedToSize.width, ceil(resultSize.width)),
                                min(constrainedToSize.height, ceil(resultSize.height)))
        return resultSize
    }
    
    func getWidthWithFont(font: UIFont, constrainedToSize: CGSize) -> CGFloat {
        return self.getSizeWithFont(font, constrainedToSize: constrainedToSize).width
    }
    
    func getHeightWithFont(font: UIFont, constrainedToSize: CGSize) -> CGFloat {
        return self.getSizeWithFont(font, constrainedToSize: constrainedToSize).height
    }
    
    // MARK: - Formatter
    func isPureFloat() -> Bool {
        let scanner = NSScanner.init(string: self)
        var scanFloat: Float = 0.0
        return scanner.scanFloat(&scanFloat) && scanner.atEnd
    }
    
    // MARK: - Pinyin
    func transformToPinyin() -> String {
        var tempString = (self as NSString).mutableCopy()
        CFStringTransform(tempString as! CFMutableString, nil, kCFStringTransformToLatin, false)
        tempString = tempString.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
        tempString = tempString.stringByReplacingOccurrencesOfString(" ", withString: "")
        return tempString.uppercaseString
    }
    
    // MARK: - NSURL
    func urlImageWithCodePathResizeToView(view: UIView) -> NSURL {
        return urlImageWithCodePathResize(UIScreen.mainScreen().scale * CGRectGetWidth(view.frame))
    }
    
    func urlImageWithCodePathResize(width: CGFloat) -> NSURL {
        return urlImageWithCodePathResize(width, needCrop: false)
    }
    
    func urlImageWithCodePathResize(width: CGFloat, needCrop: Bool) -> NSURL {
        var urlStr: String = self
        var canCrop = false
        if self.hasSuffix("http") {
            urlStr = self
//            print(urlStr.rangeOfString(<#T##aString: String##String#>))
//            if urlStr.rangeOfString("qbox.me")?.count {
//                <#code#>
//            }
        } else {
            
        }
        return NSURL(string: urlStr)!
    }
}
