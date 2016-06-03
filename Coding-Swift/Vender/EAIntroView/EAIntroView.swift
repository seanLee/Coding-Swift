//
//  EAIntroView.swift
//  Coding-Swift
//
//  Created by sean on 16/5/6.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

enum EAIntroViewTags: Int {
    case kTitleLabelTag = 1
    case kDescLabelTag
    case kTitleImageViewTag
}

enum EAViewAlignment: Int {
    case EAViewAlignmentLeft
    case EAViewAlignmentCenter
    case EAViewAlignmentRight
}

@objc  protocol EAIntroDelegate {
    optional func introDidFinish(introView: EAIntroView)
    optional func intro(introView: EAIntroView, pageAppeared: EAIntroPage, index: Int)
    optional func intro(introView: EAIntroView, pageStartScrolling: EAIntroPage, index: Int)
    optional func intro(introView: EAIntroView, pageEndScrolling: EAIntroPage, index: Int)
}

class EAIntroView: UIView {
    
}
