//
//  LoginViewController.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/12.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import NYXImagesKit
import TPKeyboardAvoiding

class LoginViewController: BaseViewController {

    // MARK: - Property
    var showDismissButton: Bool!
    var captchaNeeded: Bool = false
    
    private lazy var myLogin = Login()
    
    // MARK: - Views
    private var myTableView: TPKeyboardAvoidingTableView!
    private var bottomView: UIView!
    private var iconUserView: UIImageView!
    private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLogin.email = Login.preUserEmail()
        

        // Do any additional setup after loading the view.
        myTableView = {
            let tableview = TPKeyboardAvoidingTableView()
            tableview.separatorStyle = .None;
            tableview.backgroundView = bgBlurredView;
            tableview.delegate = self
            tableview.dataSource = self
            view.addSubview(tableview)
            return tableview
        }()
        
        myTableView.snp_makeConstraints { (make) in
            make.edges.equalTo(view);
        }
        
        myTableView.tableHeaderView = customHeaderView()
        myTableView.tableFooterView = customFooterView()
        configBottomView()
    }
    // MARK: - Table Header And Footer
    private func customHeaderView() -> UIView {
        var iconUserViewWidth: CGFloat
        if kDevice_Is_iPhone6Plus {
            iconUserViewWidth = 100.0
        } else if kDevice_Is_iPhone6 {
            iconUserViewWidth = 90.0
        } else {
            iconUserViewWidth = 75.0
        }
        
        let headerView = UIView(frame: CGRectMake(0, 0, kScreen_Width, kScreen_Height / 3.0))

        iconUserView = UIImageView(frame: CGRectMake(0, 0, iconUserViewWidth, iconUserViewWidth))
        iconUserView.contentMode = .ScaleAspectFit
        iconUserView.layer.masksToBounds = true
        iconUserView.layer.cornerRadius = iconUserViewWidth/2.0
        iconUserView.layer.borderWidth = 2.0
        iconUserView.layer.borderColor = UIColor.whiteColor().CGColor
        iconUserView.image = UIImage(named: "icon_user_monkey")
        headerView.addSubview(iconUserView)
        (
            iconUserView.snp_makeConstraints(closure: { (make) in
                make.width.height.equalTo(iconUserViewWidth)
                make.centerX.equalTo(headerView)
                make.centerY.equalTo(headerView).offset(30.0)
            })
        )
        
        return headerView
    }
    
    private func customFooterView() -> UIView {
        let footerView = UIView(frame: CGRectMake(0, 0, kScreen_Width, 150.0))
        
        loginButton = UIButton.buttonWithStyle(.StrapSuccessStyle, title: "登录", rect: CGRectMake(kLoginPaddingLeftWidth, 20, kScreen_Width-kLoginPaddingLeftWidth*2, 45), target: self, selector: #selector(sendLogin))
        footerView.addSubview(loginButton)
        
        return footerView
    }
    
    private var bgBlurredView: UIImageView {
        let bgView = UIImageView(frame: kScreen_Bounds)
        bgView.contentMode = .ScaleAspectFill
        var bgImage = StartImagesManager.shareManager.curImage.image
        //config the image
        let bgImageSize = bgImage.size, bgViewSize = bgView.frame.size
        if bgImageSize.width > bgView.width && bgImageSize.height > bgViewSize.height {
            bgImage = bgImage.scaleToSize(bgViewSize, usingMode: NYXResizeModeAspectFill)
        }
        bgImage = bgImage.applyLightEffectAtFrame(CGRectMake(0, 0, bgImage.size.width, bgImage.size.height))
        bgView.image = bgImage
        //black overlay
        let blackColor = UIColor.blackColor()
        bgView.addGradientLayerWithColors([blackColor.colorWithAlphaComponent(0.3).CGColor, blackColor.colorWithAlphaComponent(0.3).CGColor], locations: nil, startPoint: CGPointMake(0.5, 0.0), endPoint: CGPointMake(0.5, 1.0))
        return bgView
    }
    
    private func configBottomView() {
        bottomView = UIView()
        bottomView.backgroundColor = UIColor.clearColor()
        view.addSubview(bottomView)
        (
            bottomView.snp_makeConstraints(closure: { (make) in
                make.bottom.equalTo(view);
                make.left.right.equalTo(view);
                make.height.equalTo(55.0)
            })
        )
        //button
        let registerBtn: UIButton = {
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFontOfSize(14.0)
            button.setTitle("去注册", forState: .Normal)
            button.setTitleColor(UIColor(white: 1.0, alpha: 0.5), forState: .Normal)
            button.setTitleColor(UIColor(white: 0.5, alpha: 0.5), forState: .Highlighted)
            button.addTarget(self, action: #selector(goRegisterVC(_:)), forControlEvents: .TouchUpInside)
            return button
        }()
        bottomView.addSubview(registerBtn)
        (
            registerBtn.snp_makeConstraints(closure: { (make) in
                make.size.equalTo(CGSizeMake(100.0, 30.0))
                make.centerX.equalTo(bottomView)
                make.top.equalTo(bottomView)
            })
        )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Action
    @objc private func goRegisterVC(sender: AnyObject) {
        print("注册");
    }
    
    @objc private func sendLogin() {
        print("登录")
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell();
        cell.backgroundView = nil;
        cell.backgroundColor = UIColor.clearColor();
        return cell;
    }
}
