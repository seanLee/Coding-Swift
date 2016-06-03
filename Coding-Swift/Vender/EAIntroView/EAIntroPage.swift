//
//  EAIntroPage.swift
//  Coding-Swift
//
//  Created by sean on 16/5/6.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

typealias voidBlock = () -> Void

class EAIntroPage: NSObject {
    var bgImage         : UIImage?
    var titleIconView   : UIView?
    var subviews        : [AnyObject]?
    var customeView     : UIView?
    var pageView        : UIView?
    
    var showTitleView = true
    var bgColor = UIColor.clearColor()
    
    var alpha               : CGFloat = 1.0
    var titleIconPositionY  : CGFloat = 50.0
    
    var title               : String  = ""
    var titleFont           : UIFont  = UIFont(name: "HelveticaNeue-Bold", size: 16.0)!
    var titleColor          : UIColor = UIColor.whiteColor()
    var titlePositionY      : CGFloat = 160.0
    
    var desc                : String  = ""
    var descFont            : UIFont  = UIFont(name: "HelveticaNeue-Light", size: 13.0)!
    var descColor           : UIColor = UIColor.whiteColor()
    var descPositionY       : CGFloat = 140.0
    
    var onPageDidLoad       : voidBlock?
    var onPageDidAppear     : voidBlock?
    var onPageDidDisappear  : voidBlock?
    
    override init() {
        showTitleView = true
        super.init()
    }
    
    class func page() -> EAIntroPage {
        return EAIntroPage()
    }
    
    class func pageWithCustomViewFromNibNamed(nibName: String) -> EAIntroPage {
        return self.pageWithCustomViewFromNibNamed(nibName, bundle: NSBundle.mainBundle())
    }
    
    class func pageWithCustomView(customView: UIView) -> EAIntroPage {
        let newPage = EAIntroPage()
        newPage.customeView = customView
        newPage.customeView?.translatesAutoresizingMaskIntoConstraints = false
        newPage.bgColor = customView.backgroundColor!
        return newPage
    }
    
    class func pageWithCustomViewFromNibNamed(nibName: String, bundle: NSBundle) -> EAIntroPage {
        let newPage = EAIntroPage()
        newPage.customeView = bundle.loadNibNamed(nibName, owner: newPage, options: nil).first as? UIView
        newPage.customeView?.translatesAutoresizingMaskIntoConstraints = false
        newPage.bgColor = newPage.customeView!.backgroundColor!
        return newPage
    }
}
