//
//  IntroductionViewController.swift
//  Coding-Swift
//
//  Created by Sean on 16/5/24.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import JazzHands
import NYXImagesKit

class IntroductionViewController: IFTTTAnimatedPagingScrollViewController {
    private var iconsDict: [String : String] {
        return ["0_image" : "intro_icon_6",
                "1_image" : "intro_icon_0",
                "2_image" : "intro_icon_1",
                "3_image" : "intro_icon_2",
                "4_image" : "intro_icon_3",
                "5_image" : "intro_icon_4",
                "6_image" : "intro_icon_5"]
    }
    
    private var tipsDict: [String : String] {
        return [ "1_image" : "intro_tip_0",
                 "2_image" : "intro_tip_1",
                 "3_image" : "intro_tip_2",
                 "4_image" : "intro_tip_3",
                 "5_image" : "intro_tip_4",
                 "6_image" : "intro_tip_5"]
    }
    
    private var registerBtn: UIButton!
    private var loginBtn   : UIButton!
    private var pageControl: SMPageControl!
    init() {
        super.init(nibName: nil, bundle: nil)
        numberOfPages = 7
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorWithHexString("0xf1f1f1");
        
        configureViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    // MARK: - Orientations
    override func shouldAutorotate() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    private func forceChangeToOrientation(interfaceOrientation: UIInterfaceOrientation) {
        UIDevice.currentDevice().setValue(NSNumber(integer: interfaceOrientation.rawValue), forKey: "orientation")
    }
    
    // MARK: - super
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    // MARK: - function
    private func imageKeyForIndex(index: Int) -> String {
        return "\(index)_image"
    }
    
    private func viewKeyForIndex(index: Int) -> String {
        return "\(index)_view"
    }
    
    // MARK: - views
    private func configureViews() {
        configureButtonsAndPageControl()
    }
    
    private func configureButtonsAndPageControl() {
        let darkColor = UIColor.colorWithHexString("0x28303b")
        let buttonWidth = kScreen_Width * 0.4
        let buttonHeight = kScaleFrom_iPhone5_Desgin(38.0)
        let paddingToCenter = kScaleFrom_iPhone5_Desgin(10.0)
        let paddingToBottom = kScaleFrom_iPhone5_Desgin(20.0)
        
        registerBtn = {
            let button = UIButton(type: .Custom)
            button.addTarget(self, action: #selector(registerBtnClicked(_:)), forControlEvents: .TouchUpInside)
            button.backgroundColor = darkColor
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(20.0)
            button.setTitle("注册", forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = buttonHeight / 2.0
            return button
        }()
        
        loginBtn = {
            let button = UIButton(type: .Custom)
            button.addTarget(self, action: #selector(loginBtnClicked(_:)), forControlEvents: .TouchUpInside)
            button.backgroundColor = UIColor.clearColor()
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(20.0)
            button.setTitle("登录", forState: .Normal)
            button.setTitleColor(darkColor, forState: .Normal)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = buttonHeight / 2.0
            button.layer.borderWidth = 1.0
            button.layer.borderColor = darkColor.CGColor
            return button
        }()
        
        view.addSubview(registerBtn)
        view.addSubview(loginBtn)
        
        registerBtn.snp_makeConstraints(closure: { (make) in
            make.size.equalTo(CGSizeMake(buttonWidth, buttonHeight))
            make.right.equalTo(self.view.snp_centerX).offset(-paddingToCenter)
            make.bottom.equalTo(self.view).offset(-paddingToBottom)
        })
        
        loginBtn.snp_makeConstraints(closure: { (make) in
            make.size.equalTo(CGSizeMake(buttonWidth, buttonHeight))
            make.left.equalTo(self.view.snp_centerX).offset(paddingToCenter)
            make.bottom.equalTo(self.view).offset(-paddingToBottom)
        })
        
        //PageControl
        var pageIndicatorImage = UIImage(named: "intro_dot_unselected")
        var currentPageIndicatorImage = UIImage(named: "intro_dot_selected")
        
        if !(kDevice_Is_iPhone6 && kDevice_Is_iPhone6Plus) {
            let desginWidth: CGFloat = 375.0
            let scaleFactor = kScreen_Width / desginWidth
            pageIndicatorImage = pageIndicatorImage?.scaleByFactor(Float(scaleFactor))
            currentPageIndicatorImage = currentPageIndicatorImage?.scaleByFactor(Float(scaleFactor))
        }
        
        pageControl = {
            let control = SMPageControl()
            control.numberOfPages = Int(self.numberOfPages)
            control.currentPage = 0
            control.backgroundColor = UIColor.redColor()
            control.userInteractionEnabled = false
            control.pageIndicatorImage = pageIndicatorImage
            control.currentPageIndicatorImage = currentPageIndicatorImage
            control.sizeToFit()
            return control
        }()
        
        view.addSubview(pageControl)
        
        pageControl.snp_makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(kScreen_Width, kScaleFrom_iPhone5_Desgin(20.0)))
            make.centerX.equalTo(view)
            make.bottom.equalTo(registerBtn.snp_top).offset(-kScaleFrom_iPhone5_Desgin(20.0))
        }
    }
    
    // MARK: - Action
    func registerBtnClicked(sender: UIButton) {
        
    }
    
    func loginBtnClicked(sender: UIButton) {
        
    }
}
