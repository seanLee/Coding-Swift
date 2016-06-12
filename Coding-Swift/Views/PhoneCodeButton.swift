//
//  PhoneCodeButton.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/12.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class PhoneCodeButton: UIButton {
    
    private var durationToValidity: NSTimeInterval = 0
    private var timer: NSTimer?
    
    lazy var lineView: UIView = {
        let customerView = UIView(frame: CGRectMake(-10.0, 5, 0.5, CGRectGetHeight(self.frame) - 2*5.0))
        customerView.backgroundColor = UIColor.colorWithString("0xD8D8D8")
        return customerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont.systemFontOfSize(14.0)
        enabled = true
        
        addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setter
    override var enabled: Bool {
        get {
            return super.enabled
        }
        set {
            let foreColor = UIColor.colorWithHexString(enabled ? "0x3BBD79":"0xCCCCCC")
            setTitleColor(foreColor, forState: .Normal)
            if enabled {
                setTitle("发送验证码", forState: .Normal)
            } else {
                setTitle("正在发送", forState: .Normal)
            }
        }
    }
    
    func startUpTimer() {
        durationToValidity = 60
        
        if enabled {
            enabled = false
        }
        setTitle(String(format: "%.0f 秒", durationToValidity), forState: .Normal)
//        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: <#T##Selector#>, userInfo: nil, repeats: true)
    }
    
    func invalidateTimer() {
        if !enabled {
            enabled = true
        }
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Selector
    func redrawTimer(timer: NSTimer) {
        durationToValidity = durationToValidity - 1
        if durationToValidity > 0 {
            titleLabel?.text = String(format: "%.0f 秒", durationToValidity)
            setTitle(String(format: "%.0f 秒", durationToValidity), forState: .Normal)
        } else {
            invalidateTimer()
        }
    }
}
