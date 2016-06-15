//
//  UIImage+BlurredFrame.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/15.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

extension UIImage {
    private func croppedImageAtFrame(frame: CGRect) -> UIImage {
        let customerFrame = CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width * scale, frame.size.height * scale)
        let sourceImageRect = CGImage
        let newImageRef     = CGImageCreateWithImageInRect(sourceImageRect, customerFrame)
        let newImage = UIImage(CGImage: newImageRef!, scale: scale, orientation: imageOrientation)
        return newImage
    }
    
    // MARK: - Marge two images
    private func addImageToImage(image: UIImage, cropRect: CGRect) -> UIImage {
        let custmerSize = CGSizeMake(size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(custmerSize, false, scale)
        
        let pointImg1 = CGPointZero
        self.drawAtPoint(pointImg1)
        
        let pointImg2 = cropRect.origin
        image.drawAtPoint(pointImg2)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    // MARK: - Blurred
    func applyLightEffectAtFrame(frame: CGRect) -> UIImage {
        let bluredImage = croppedImageAtFrame(frame).applyLightEffect()
        return addImageToImage(bluredImage!, cropRect: frame)
    }
    
    func applyExtraLightEffectAtFrame(frame: CGRect) -> UIImage {
        let bluredImage = croppedImageAtFrame(frame).applyExtraLightEffect()
        return addImageToImage(bluredImage!, cropRect: frame)
    }
    
    func applyDarkEffectAtFrame(frame: CGRect) -> UIImage {
        let bluredImage = croppedImageAtFrame(frame).applyDarkEffect()
        return addImageToImage(bluredImage!, cropRect: frame)
    }
    
    func applyTintEffectWithColor(tintColor: UIColor, frame: CGRect) -> UIImage {
        let bluredImage = croppedImageAtFrame(frame).applyTintEffectWithColor(tintColor)
        return addImageToImage(bluredImage!, cropRect: frame)
    }
    
    func applyBlurWithRadius(blurRadius: CGFloat, tintColor:UIColor, saturationDeltaFactor: CGFloat, maskImage: UIImage, frame: CGRect) -> UIImage {
        let bluredImage = croppedImageAtFrame(frame).applyBlurWithRadius(blurRadius, tintColor: tintColor, saturationDeltaFactor: saturationDeltaFactor, maskImage: maskImage)
        return addImageToImage(bluredImage!, cropRect: frame)
    }
}
