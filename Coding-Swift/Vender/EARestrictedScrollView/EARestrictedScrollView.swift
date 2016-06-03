//
//  EARestrictedScrollView.swift
//  Coding-Swift
//
//  Created by sean on 16/5/6.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

public class EARestrictedScrollView: UIScrollView {
    /// Container to hold all subviews of scrollview.
    lazy private var containerView: UIView = self.createContainerView()
    
    /// Helper func, since direct use of `super` call in `lazy` causes compile error.
    func createContainerView() -> UIView {
        let view = UIView()
        super.addSubview(view)
        return view
    }
    
    
    /// Affects `restrictionArea.size` and `containerView.frame.size` when set.
    override public var contentSize: CGSize {
        get {
            return super.contentSize
        }
        set(newContentSize) {
            containerView.frame = CGRect(origin: containerView.frame.origin, size: newContentSize)
            restrictionArea = CGRect(origin: restrictionArea.origin, size: newContentSize)
        }
    }
    
    /// Recalculated `contentOffset` in coordinate space of `containerView`.
    public var alignedOffset: CGPoint {
        get {
            let originalOffset = super.contentOffset
            let newOffset = CGPoint(x: originalOffset.x + restrictionArea.origin.x, y: originalOffset.y + restrictionArea.origin.y)
            
            return newOffset
        }
        set(newContentOffset) {
            let newOffset = CGPoint(x: newContentOffset.x - restrictionArea.origin.x, y: newContentOffset.y - restrictionArea.origin.y)
            
            super.contentOffset = newOffset
        }
    }
    
    /// Defines restriction area in coordinate space of `containerView`. Use CGRectZero to reset restriction.
    public var restrictionArea: CGRect = CGRectZero {
        didSet {
            if restrictionArea == CGRectZero {
                super.contentOffset = CGPoint(x: super.contentOffset.x - containerView.frame.origin.x, y: super.contentOffset.y - containerView.frame.origin.y)
                containerView.frame = CGRect(origin: CGPointZero, size: containerView.frame.size)
                super.contentSize = containerView.frame.size
            } else {
                containerView.frame = CGRect(origin: CGPoint(x: -restrictionArea.origin.x, y: -restrictionArea.origin.y), size: containerView.frame.size)
                super.contentOffset = CGPoint(x: super.contentOffset.x - restrictionArea.origin.x, y: super.contentOffset.y - restrictionArea.origin.y)
                super.contentSize = restrictionArea.size
            }
        }
    }
    
    public var containedSubviews: [UIView] {
        return containerView.subviews
    }
    
    // MARK: - Override
    override public func addSubview(view: UIView) {
        if self.subviews.count < 3 && self.checkIfScrollIndicator(view) {
            super.addSubview(view)
        } else {
            containerView.addSubview(view)
        }
    }
    
    override public func insertSubview(view: UIView, atIndex index: Int) {
        containerView.insertSubview(view, atIndex: index)
    }
    
    override public func insertSubview(view: UIView, aboveSubview siblingSubview: UIView) {
        containerView.insertSubview(view, aboveSubview: siblingSubview)
    }
    
    override public func insertSubview(view: UIView, belowSubview siblingSubview: UIView) {
        containerView.insertSubview(view, belowSubview: siblingSubview)
    }
    
    override public func bringSubviewToFront(view: UIView) {
        if view.superview == self {
            super.bringSubviewToFront(view)
        } else {
            containerView.bringSubviewToFront(view);
        }
    }
    
    override public func sendSubviewToBack(view: UIView) {
        if view.superview == self {
            super.sendSubviewToBack(view)
        } else {
            containerView.sendSubviewToBack(view)
        }
    }
    
    // MARK: - Private Checks
    private func checkIfScrollIndicator(view: UIView) -> Bool {
        return ((self.showsHorizontalScrollIndicator && view.height == 2.5) || (self.showsVerticalScrollIndicator && view.width == 2.5)) && (view is UIImageView)
    }
}
