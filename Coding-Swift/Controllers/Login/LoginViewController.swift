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
import SDWebImage
import ReactiveCocoa

class LoginViewController: BaseViewController {
    
    // MARK: - Property
    var showDismissButton   : Bool = false
    private var captchaNeeded       : Bool = false
    private var is2FAUI             : Bool = false
    
    private var otpCode: String?
    
    private let myLogin = Login()
    
    // MARK: - Views
    private lazy var inputTipsView: EaseInputTipsView = {
        let tipsView = EaseInputTipsView(type: .EaseInputTipsViewTypeLogin)
        tipsView.valueStr = ""
        return tipsView
    }()
    
    private lazy var myTableView: TPKeyboardAvoidingTableView = {
        let tableview = TPKeyboardAvoidingTableView()
        tableview.separatorStyle = .None;
        tableview.backgroundView = self.bgBlurredView;
        tableview.delegate = self
        tableview.dataSource = self
        tableview.registerClass(Login2FATipCell.classForCoder(), forCellReuseIdentifier: Login2FATipCell.kCellIdentifier_Login2FATipCell)
        tableview.registerClass(Input_OnlyText_Cell.classForCoder(), forCellReuseIdentifier: Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Text)
        tableview.registerClass(Input_OnlyText_Cell.classForCoder(), forCellReuseIdentifier: Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Captcha)
        return tableview
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    private var iconUserView: UIImageView!
    
    private lazy var loginButton: UIButton = {
        let button = UIButton.buttonWithStyle(.StrapSuccessStyle, title: "登录", rect: CGRectMake(kLoginPaddingLeftWidth, 20, kScreen_Width-kLoginPaddingLeftWidth*2, 45), target: self, selector: #selector(sendLogin))
        return button
    }()
    
    private lazy var cannotLoginButton: UIButton = {
        let button = UIButton(frame: CGRectMake(0, 0, 100, 30))
        button.setTitle("找回密码", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        button.setTitleColor(UIColor(white: 1.0, alpha: 0.5), forState: .Normal)
        button.setTitleColor(UIColor(white: 0.5, alpha: 0.5), forState: .Highlighted)
        button.addTarget(self, action: #selector(cannotLoginBtnClicked), forControlEvents: .TouchUpInside)
        return button
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(frame: CGRectMake(0, 20, 50, 50))
        button.setImage(UIImage(named: "dismissBtn_Nav"), forState: .Normal)
        button.addTarget(self, action: #selector(dismissButtonClicked(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let emaill = Login.preUserEmail() {
            myLogin.email = emaill
        }
        
        // Do any additional setup after loading the view.
        view.addSubview(myTableView)
        myTableView.snp_makeConstraints { (make) in
            make.edges.equalTo(view);
        }
        
        myTableView.tableHeaderView = customHeaderView()
        myTableView.tableFooterView = customFooterView()
        configBottomView()
        showdismissButton(showDismissButton)
        
        refreshIconUserImage()
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
        
        footerView.addSubview(loginButton)
        DynamicProperty(object: myLogin, keyPath: "email").signal.map {$0}.observeNext { (email) in
            print("email is \(email)")
        }
        
        footerView.addSubview(cannotLoginButton)
        (
            cannotLoginButton.snp_makeConstraints(closure: { (make) in
                make.size.equalTo(CGSizeMake(100.0, 30.0))
                make.centerX.equalTo(footerView)
                make.top.equalTo(loginButton.snp_bottom).offset(20.0)
            })
        )
        
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
    
    private func refreshIconUserImage() {
        let textStr = myLogin.email
        if textStr.length > 0 {
            let curUser = Login.userWithGlobaykeyOrEmail(textStr)
            if let _ = curUser,
                let avatar = curUser?.avatar {
                iconUserView.sd_setImageWithURL(avatar.urlImageWithCodePathResizeToView(iconUserView), placeholderImage: UIImage(named: "icon_user_monkey"))
                return
            }
        }
        iconUserView.image = UIImage(named: "icon_user_monkey")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if inputTipsView.superview == nil {
            
            inputTipsView.selectedTipBlock = { [weak self] value in
                if let strongSelf = self {
                    strongSelf.view.endEditing(true)
                    strongSelf.myLogin.email = value
                    strongSelf.refreshIconUserImage()
                    strongSelf.myTableView.reloadData()
                }
            }
            
            let cell = myTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            if let cell = cell {
                inputTipsView.y = CGRectGetMaxY(cell.frame) - 0.5
            }
            
            myTableView.addSubview(inputTipsView)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    private func showdismissButton(willShow: Bool) {
        dismissButton.hidden = !willShow
        if willShow {
            if dismissButton.superview == nil {
                view.addSubview(dismissButton)
            }
        }
    }
    
    // MARK: - Action
    @objc private func goRegisterVC(sender: AnyObject) {
        print("注册");
    }
    
    @objc private func sendLogin() {
        let tipMsg = is2FAUI ? loginTipFor2FA() : myLogin.goToLoginTipWithCaptcha(captchaNeeded)
        if let tip = tipMsg {
            kTipAlert(tip)
            return
        }
    }
    
    @objc private func cannotLoginBtnClicked() {
        print("找回密码")
    }
    
    @objc private func dismissButtonClicked(sender: AnyObject) {
        if is2FAUI {
            is2FAUI = false
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return is2FAUI ? 2 : (captchaNeeded ? 3 : 2)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if is2FAUI && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Login2FATipCell.kCellIdentifier_Login2FATipCell, forIndexPath: indexPath) as! Login2FATipCell
            cell.tipLabel.text = "  您的账户开启了两步验证，请输入动态验证码登录  "
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(indexPath.row > 1 ? Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Captcha : Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Text, forIndexPath: indexPath) as! Input_OnlyText_Cell
        cell.isForLoginVC = true
        
        if is2FAUI {
            
        } else {
            if indexPath.row == 0 {
                cell.textField.keyboardType = .EmailAddress
                cell.setPlacerholder(" 手机号码/电子邮箱/个性后缀", value: myLogin.email)
                cell.textValueChangedBlock = { [weak self] value in
                    if let strongSelf = self {
                        strongSelf.inputTipsView.valueStr = value
                        strongSelf.inputTipsView.active = true
                        strongSelf.myLogin.email = value
                        strongSelf.refreshIconUserImage()
                    }
                }
                cell.editDidBeginBlock  = { [weak self] value in
                    if let strongSelf = self {
                        strongSelf.inputTipsView.valueStr = value
                        strongSelf.inputTipsView.active = true
                    }
                }
                cell.editDidEndBlock = { [weak self] value in
                    if let strongSelf = self {
                        strongSelf.inputTipsView.active = false
                    }
                }
                
            } else if indexPath.row == 1 {
                cell.setPlacerholder(" 密码", value: myLogin.password)
                cell.textField.secureTextEntry = true
                cell.textValueChangedBlock = { [weak self] value in
                    if let strongSelf = self {
                        strongSelf.myLogin.password = value
                    }
                }
            } else {
                cell.setPlacerholder(" 验证码", value: myLogin.j_captcha)
                cell.textValueChangedBlock = { [weak self] value in
                    if let strongSelf = self {
                        strongSelf.myLogin.j_captcha = value
                        print(self?.myLogin.j_captcha)
                    }
                }
            }
        }
        return cell
    }
    
    // MARK: - Method
    private func loginTipFor2FA() -> String? {
        var tipStr: String?
        if let otpCode = otpCode {
            if !otpCode.isPureInt() || otpCode.length != 6 {
                tipStr = "动态验证码必须是一个6位数字"
            }
        } else {
            tipStr = "动态验证码不能为空"
        }
        return tipStr
    }
}
