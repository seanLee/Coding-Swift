//
//  UIImage+ImageEffects.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/15.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import Accelerate

extension UIImage {
    
    func applyLightEffect() -> UIImage? {
        let tintColor = UIColor(white: 1.0, alpha: 0.3)
        return applyBlurWithRadius(30.0, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func applyExtraLightEffect() -> UIImage? {
        let tintColor = UIColor(white: 0.97, alpha: 0.82)
        return applyBlurWithRadius(20.0, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func applyDarkEffect() -> UIImage? {
        let tintColor = UIColor(white: 0.11, alpha: 0.73)
        return applyBlurWithRadius(20.0, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func applyTintEffectWithColor(tintColor: UIColor) -> UIImage? {
        let EffectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = Int(CGColorGetComponents(tintColor.CGColor).memory)
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: EffectColorAlpha)
            }
        } else {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
            if tintColor.getRed(&r, green: &g, blue: &b, alpha: nil) {
                effectColor = UIColor(red: r, green: g, blue: b, alpha: EffectColorAlpha)
            }
        }
        return applyBlurWithRadius(10.0, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    
    func applyBlurWithRadius(blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage?) -> UIImage? {
        guard size.width >= 1 && size.height >= 1 else {
            print(String(format: "error: invalid size: (%.2f x %.2f).Both dimensions must be >= 1:%@", size.width, size.height, self))
            return nil
        }
        
        guard CGImage != nil else {
            print("error: image must be backed by a CGImage: \(self)")
            return nil
        }
        
        if let maskImage = maskImage,
            let _ = maskImage.CGImage {
            print("*** error: maskImage must be backed by a CGImage: %@", maskImage);
            return nil;
        }
        
        let imageRect = CGRect(origin: CGPointZero, size: self.size)
        var effectImage = self
        
        let hasBlur = Float(blurRadius) > FLT_EPSILON
        let hasStaturationChange = Float(fabs(saturationDeltaFactor - 1.0)) > FLT_EPSILON
        if hasBlur || hasStaturationChange {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
            let effectInContext = UIGraphicsGetCurrentContext()
            CGContextScaleCTM(effectInContext, 1.0, -1.0)
            CGContextTranslateCTM(effectInContext, 0, -size.height)
            CGContextDrawImage(effectInContext, imageRect, CGImage)
            
            var effectInBuffer = vImage_Buffer()
            effectInBuffer.data     = CGBitmapContextGetData(effectInContext)
            effectInBuffer.width    = UInt(CGBitmapContextGetWidth(effectInContext))
            effectInBuffer.height   = UInt(CGBitmapContextGetHeight(effectInContext))
            effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext)
            
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
            let effectOutContext = UIGraphicsGetCurrentContext()
            var effectOutBuffer = vImage_Buffer()
            effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext)
            effectOutBuffer.width    = UInt(CGBitmapContextGetWidth(effectOutContext))
            effectOutBuffer.height   = UInt(CGBitmapContextGetHeight(effectOutContext))
            effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext)
            
            if hasBlur {
                let inputRadius = blurRadius * UIScreen.mainScreen().scale
                var radius = floor(inputRadius * 3.0 * sqrt(2 * CGFloat(M_PI)) / 4.0 + 0.5)
                if radius % 2 != 1 {
                    radius = radius + 1
                }
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), nil, UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), nil, UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), nil, UInt32(kvImageEdgeExtend))
            }
            var effectImageBuffersAreSwapped = false
            if hasStaturationChange {
                let s = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                  0,                    0,                      1,
                    ]
                let divisor: Int32 = 256
                let matrixSize = (strideofValue(floatingPointSaturationMatrix) * floatingPointSaturationMatrix.count) / strideofValue(floatingPointSaturationMatrix[0])
                var saturationMatrix = [Int16].init(count: matrixSize, repeatedValue: 0)
                for index in 0..<matrixSize {
                    saturationMatrix[index] = Int16(round(floatingPointSaturationMatrix[index] * CGFloat(divisor)))
                }
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, &saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, &saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                }
            }
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
        }
        
        // set up output context
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        let outputContext = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(outputContext, 1.0, -1.0)
        CGContextTranslateCTM(outputContext, 0, -size.height)
        
        //draw base image
        CGContextDrawImage(outputContext, imageRect, CGImage)
        
        //draw effect image
        if hasBlur {
            CGContextSaveGState(outputContext)
            if let maskImage = maskImage {
                CGContextClipToMask(outputContext, imageRect, maskImage.CGImage)
            }
            CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)
            CGContextRestoreGState(outputContext)
        }
        
        //add in color tint
        if let tintColor = tintColor {
            CGContextSaveGState(outputContext)
            CGContextSetFillColorWithColor(outputContext, tintColor.CGColor)
            CGContextFillRect(outputContext, imageRect)
            CGContextRestoreGState(outputContext)
        }
        
        //output image is ready
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}
