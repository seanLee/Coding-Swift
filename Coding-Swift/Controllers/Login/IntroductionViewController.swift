//
//  IntroductionViewController.swift
//  Coding-Swift
//
//  Created by Sean on 16/5/24.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import RazzleDazzle
import NYXImagesKit

class IntroductionViewController: AnimatedPagingScrollViewController {
    private var iconsDict: [String : (String, UIImageView?)] = ["0_image" : ("intro_icon_6", nil),
                                                                "1_image" : ("intro_icon_0", nil),
                                                                "2_image" : ("intro_icon_1", nil),
                                                                "3_image" : ("intro_icon_2", nil),
                                                                "4_image" : ("intro_icon_3", nil),
                                                                "5_image" : ("intro_icon_4", nil),
                                                                "6_image" : ("intro_icon_5", nil)]
    
    private var tipsDict: [String : (String, UIImageView?)] = [ "1_image" : ("intro_tip_0", nil),
                                                                "2_image" : ("intro_tip_1", nil),
                                                                "3_image" : ("intro_tip_2", nil),
                                                                "4_image" : ("intro_tip_3", nil),
                                                                "5_image" : ("intro_tip_4", nil),
                                                                "6_image" : ("intro_tip_5", nil)]
    private var registerBtn: UIButton!
    private var loginBtn   : UIButton!
    private var pageControl: SMPageControl!
    
    override func numberOfPages() -> Int {
        return 7;
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorWithHexString("0xf1f1f1");
        
        configureViews()
        configureAnimations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    // MARK: - Orientations
    override func shouldAutorotate() -> Bool {
        return UIInterfaceOrientationIsLandscape(kScreenOrientation)
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
        animateCurrentFrame()
        
        let nearestPage = floor(pageOffset + 0.5)
        pageControl.currentPage = Int(nearestPage)
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
        
        var scaleFactor    : CGFloat = 1.0
        let desginHeight   : CGFloat = 667.0
        
        if !(kDevice_Is_iPhone6 || kDevice_Is_iPhone6Plus) {
            scaleFactor = kScreen_Height / desginHeight
        }
        
        for index in 0..<numberOfPages() {
            let indexInt = Int(index)
            let imageKey = imageKeyForIndex(indexInt)
            let viewKey  = viewKeyForIndex(indexInt)
            let iconImageName = iconsDict[imageKey]?.0
            let tipImageName  = tipsDict[imageKey]?.0
            
            if let iconImageName = iconImageName {
                let iconImage = UIImage(named: iconImageName)
                if var iconImage = iconImage {
                    iconImage = scaleFactor == 1.0 ? iconImage : iconImage.scaleByFactor(Float(scaleFactor))
                    let iconView = UIImageView(image: iconImage)
                    contentView.addSubview(iconView)
                    iconsDict[viewKey] = (iconImageName, iconView)
                }
            }
            
            if let tipImageName = tipImageName {
                let tipImage = UIImage(named: tipImageName)
                if var tipImage = tipImage {
                    tipImage = scaleFactor == 1.0 ? tipImage : tipImage.scaleByFactor(Float(scaleFactor))
                    let tipView = UIImageView(image: tipImage)
                    contentView.addSubview(tipView)
                    tipsDict[viewKey] = (tipImageName, tipView)
                }
            }
        }
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
        
        if !(kDevice_Is_iPhone6 || kDevice_Is_iPhone6Plus) {
            let desginWidth: CGFloat = 375.0
            let scaleFactor = kScreen_Width / desginWidth
            pageIndicatorImage = pageIndicatorImage?.scaleByFactor(Float(scaleFactor))
            currentPageIndicatorImage = currentPageIndicatorImage?.scaleByFactor(Float(scaleFactor))
        }
        
        pageControl = {
            let control = SMPageControl()
            control.numberOfPages = numberOfPages()
            control.currentPage = 0
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
    
    // MARK: - Animation
    private func configureAnimations() {
        configureTipAndTitleViewAnimations()
    }
    
    private func configureTipAndTitleViewAnimations() {
        for index in 0..<numberOfPages() {
            let indexInt = CGFloat(index)
            let viewKey = viewKeyForIndex(Int(indexInt))
            let iconView = iconsDict[viewKey]?.1
            let tipView = tipsDict[viewKey]?.1
            if let iconView = iconView {
                if indexInt == 0 {
                    keepView(iconView, onPages: [indexInt+1, indexInt], atTimes: [indexInt-1, indexInt])
                    
                    iconView.snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(kScreen_Height / 7.0)
                    })
                } else {
                    keepView(iconView, onPage: CGFloat(indexInt))
                    
                    iconView.snp_makeConstraints(closure: { (make) in
                        make.centerY.equalTo(-kScreen_Height / 6.0)
                    })
                }
                let iconAlphaAnimation = AlphaAnimation(view: iconView)
                iconAlphaAnimation.addKeyframe(CGFloat(indexInt) - 0.5, value: 0.0)
                iconAlphaAnimation.addKeyframe(CGFloat(indexInt), value: 1.0)
                iconAlphaAnimation.addKeyframe(CGFloat(indexInt) + 0.5, value: 0.0)
                animator.addAnimation(iconAlphaAnimation)
            }
            
            if let tipView = tipView {
                keepView(tipView, onPages: [indexInt+1, indexInt, indexInt-1], atTimes: [indexInt-1, indexInt, indexInt+1])
                
                let iconAlphaAnimation = AlphaAnimation(view: tipView)
                iconAlphaAnimation.addKeyframe(CGFloat(indexInt) - 0.5, value: 0.0)
                iconAlphaAnimation.addKeyframe(CGFloat(indexInt), value: 1.0)
                iconAlphaAnimation.addKeyframe(CGFloat(indexInt) + 0.5, value: 0.0)
                animator.addAnimation(iconAlphaAnimation)
                
                tipView.snp_makeConstraints(closure: { (make) in
                    make.top.equalTo(iconView!.snp_bottom).offset(kScaleFrom_iPhone5_Desgin(45.0))
                })
            }
        }
    }
    
    // MARK: - Action
    func registerBtnClicked(sender: UIButton) {
        
    }
    
    func loginBtnClicked(sender: UIButton) {
        let vc = LoginViewController()
        vc.showDismissButton = true
        
        let nav = BaseNavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
    }
}
