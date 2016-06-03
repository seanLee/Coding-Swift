//
//  UIImage+Common.swift
//  Coding-Swift
//
//  Created by sean on 16/4/25.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import Photos

extension UIImage {
    class func imageWithColor(aColor: UIColor) -> UIImage {
        return imageWithColor(aColor, aFrame: CGRectMake(0, 0, 1, 1))
    }
    
    class func imageWithColor(aColor: UIColor, aFrame: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(aFrame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, aColor.CGColor)
        CGContextFillRect(context, aFrame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: - Rescale the image
    func scaledToSize(targetSize: CGSize) -> UIImage {
        var scaleImageSize: CGSize?
        let sourceImage = self
        var newImage: UIImage?
        let imageSize = sourceImage.size
        var scaleFactor = 0.0 as CGFloat
        
        if !CGSizeEqualToSize(imageSize, targetSize) {
            let widthFactor = targetSize.width / imageSize.width
            let heightFactor = targetSize.height / imageSize.height
            if widthFactor < heightFactor {
                scaleFactor = heightFactor
            } else {
                scaleFactor = widthFactor
            }
        }
        
        scaleFactor = min(scaleFactor, 1.0)
        let targetWidth = imageSize.width * scaleFactor
        let targetHeight = imageSize.height * scaleFactor
        
        scaleImageSize = CGSizeMake(floor(targetWidth), floor(targetHeight))
        
        UIGraphicsBeginImageContext(scaleImageSize!)
        sourceImage.drawInRect(CGRectMake(0, 0, ceil(targetWidth), ceil(targetHeight)))
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if newImage == nil {
            newImage = sourceImage
        }
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func scaleToSzie(targetSize: CGSize, highQuality: Bool) -> UIImage {
        var scaledSize: CGSize?
        if highQuality {
            scaledSize = CGSizeMake(targetSize.width * 2, targetSize.height * 2)
        }
        return scaledToSize(scaledSize!)
    }
    
    func scaledToMaxSize(size: CGSize) -> UIImage {
        let width = size.width
        let height = size.height
        
        let oldWidth = self.size.width
        let oldHeight = self.size.height
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight
        
        if scaleFactor > 1.0 {
            return self
        }
        
        let newHeight = oldHeight * scaleFactor
        let newWidth = oldWidth * scaleFactor
        let newSize = CGSizeMake(newWidth, newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
