//
//  UIScrollView+APParallaxHeader.swift
//  Coding-Swift
//
//  Created by Sean on 16/7/27.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

enum APParallaxTrackingState: Int {
    case APParallaxTrackingActive = 0
    case APParallaxTrackingInactive
}

// MARK: - APParallaxView
class APParallaxView: UIView {
    
    var parallaxViewWillChangeFrameBlock: ((APParallaxView, CGRect) -> Void)?
    var parallaxViewDidChangeFrameBlock:  ((APParallaxView, CGRect) -> Void)?
    
    private var currentSubView: UIView?
    private var customView    : UIView?
    
    private var originalTopInset : CGFloat = 0
    private var parallaxHeight   : CGFloat = 0
    private weak var scrollView: UIScrollView?
    
    private lazy var shadowView: APParallaxShadowView = {
        let view = APParallaxShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var _state:APParallaxTrackingState = .APParallaxTrackingActive
    var state:APParallaxTrackingState {
        return _state
    }
    
    private var isObserving = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, shadow: Bool) {
        self.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.addSubview(imageView)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: [], metrics: nil, views: ["imageView":self.imageView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: [], metrics: nil, views: ["imageView":self.imageView]))

        if shadow {
            self.addSubview(shadowView)
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[shadowView(8.0)]|", options: [.AlignAllBottom], metrics: nil, views: ["shadowView":shadowView]))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[shadowView]|", options: [], metrics: nil, views: ["shadowView":shadowView]))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if let _ = superview ,
            let _ = newSuperview {
            let scrollView = self.superview as! UIScrollView
            if scrollView.showsParallax {
                if (isObserving) {
                    //If enter this branch, it is the moment just before "APParallaxView's dealloc",so remove observer here
                    scrollView.removeObserver(self, forKeyPath: "contentOffset")
                    scrollView.removeObserver(self, forKeyPath: "frame")
                    isObserving = false
                }
            }
        }
    }
    
    override func addSubview(view: UIView) {
        super.addSubview(view)
        self.currentSubView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bringSubviewToFront(shadowView)
    }
    
    private func setCustomView(customView: UIView) {
        if let tempView = self.customView {
            tempView.removeFromSuperview()
        }
        
        self.customView = customView
        self.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[customView]|", options: [], metrics: nil, views: ["customView": customView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[customView]|", options: [], metrics: nil, views: ["customView": customView]))
    }
    
    // MARK: - Observing
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let keyPath = keyPath {
            if keyPath == "contentOffset" {
                if let value = change?[NSKeyValueChangeNewKey] {
                    self.scrollViewDidScroll((value as! NSValue).CGPointValue())
                }
            } else if keyPath == "frame" {
                layoutSubviews()
            }
        }
    }
    
    private func scrollViewDidScroll(contentOffset: CGPoint) {
        if contentOffset.y > 0 {
            _state = .APParallaxTrackingInactive
        } else {
            _state = .APParallaxTrackingActive
        }
        
        if _state == .APParallaxTrackingActive {
            let yOffset = contentOffset.y * -1
            if let willChangeFrame = parallaxViewWillChangeFrameBlock {
                willChangeFrame(self, self.frame)
            }
            
            frame = CGRectMake(0, contentOffset.y, CGRectGetWidth(frame), yOffset)
            print(self)
            
            if let didChangeFrameBlock = parallaxViewDidChangeFrameBlock {
                didChangeFrameBlock(self, self.frame)
            }
        }
    }
}

class APParallaxShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.opaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()
        
        //Gradient Declarations
        let gradient3Colors = [UIColor(white: 0.0, alpha: 0.3).CGColor, UIColor.clearColor().CGColor]
        let gradient3 = CGGradientCreateWithColors(colorSpace, gradient3Colors, [0.0, 1.0])
        
        //Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: CGRectGetWidth(rect), height: CGRectGetHeight(rect)))
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawLinearGradient(context, gradient3, CGPointMake(0, CGRectGetHeight(rect)), CGPointMake(0, 0), .DrawsBeforeStartLocation)
        CGContextRestoreGState(context)
    }
}

private var UIScrollViewParallaxView = 0

extension UIScrollView {
    private var showsParallax: Bool {
        set {
            if let parallaxView = parallaxView {
                parallaxView.hidden = !newValue
                if newValue {
                    if !parallaxView.isObserving {
                        addObserver(parallaxView, forKeyPath: "contentOffset", options: .New, context: nil)
                        addObserver(parallaxView, forKeyPath: "frame", options: .New, context: nil)
                        parallaxView.isObserving = true
                    }
                } else {
                    if parallaxView.isObserving {
                        removeObserver(parallaxView, forKeyPath: "contentOffset")
                        removeObserver(parallaxView, forKeyPath: "frame")
                        parallaxView.isObserving = false
                    }
                }
            }
        }
        get {
            if let parallaxView = parallaxView {
                return parallaxView.hidden
            }
            return false
        }
    }
    
    private var parallaxView: APParallaxView? {
        set {
            objc_setAssociatedObject(self, &UIScrollViewParallaxView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &UIScrollViewParallaxView) as? APParallaxView
        }
    }
    
    func addParallaxWithImage(image: UIImage, height: CGFloat) {
        addParallaxWithImage(image, height: height, shadow: true)
    }
    
    func addParallaxWithImage(image: UIImage, height: CGFloat, shadow: Bool) {
        if let parallaxView = parallaxView  {
            if let currentView = parallaxView.currentSubView {
                currentView.removeFromSuperview()
            }
            parallaxView.imageView.image = image
        } else {
            let parallaxView = APParallaxView(frame: CGRectMake(0, 0, self.bounds.size.width*2, height), shadow: shadow)
            parallaxView.clipsToBounds = true
            parallaxView.imageView.image = image
            parallaxView.scrollView = self
            parallaxView.parallaxHeight = height
            parallaxView.originalTopInset = self.contentInset.top
            self.addSubview(parallaxView)
            
            var newInset = self.contentInset
            newInset.top = height
            self.contentInset = newInset
            
            self.parallaxView = parallaxView
            self.showsParallax = true
        }
    }
    
    func addParallaxWithView(view: UIView, height: CGFloat) {
        addParallaxWithView(view, height: height, shadow: true)
    }
    
    func addParallaxWithView(view: UIView, height: CGFloat, shadow: Bool) {
        if let parallaxView = parallaxView  {
            if let currentView = parallaxView.currentSubView {
                currentView.removeFromSuperview()
            }
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            parallaxView.setCustomView(view)
        } else {
            let parallaxView = APParallaxView(frame: CGRectMake(0, 0, self.bounds.size.width, height), shadow: shadow)
            parallaxView.clipsToBounds = true
            parallaxView.scrollView = self
            parallaxView.parallaxHeight = height
            parallaxView.originalTopInset = contentInset.top
            parallaxView.setCustomView(view)
            self.addSubview(parallaxView)
            
            var newInset = self.contentInset
            newInset.top = height
            self.contentInset = newInset
            
            self.parallaxView = parallaxView
            self.showsParallax = true
        }
    }
}
