//
//  UITapImageView.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/12.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class UITapImageView: UIImageView {
    private var tapBlock: (AnyObject -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init () {
        self.init(frame: CGRectZero)
    }
    
    func addTapBlock(tapAction: AnyObject -> Void) {
        tapBlock = tapAction
        if gestureRecognizers == nil {
            userInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
            addGestureRecognizer(tapGesture)
        }
    }
    
    func tap() {
        if let tapBlock = tapBlock {
            tapBlock(self)
        }
    }
}
