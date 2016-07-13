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
import RxCocoa
import RxSwift

class LoginViewController: BaseViewController {
    
    // MARK: - Property
    var showDismissButton   : Bool = false
    private var captchaNeeded       : Variable<Bool> = Variable(false)
    private var is2FAUI             : Variable<Bool> = Variable(false)
    
    private var otpCode: Variable<String> = Variable("")
    
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.hidesWhenStopped = true
        return indicator
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
            myLogin.email.value = emaill
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
        refreshCaptchaNeeded()
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
        Observable.combineLatest(myLogin.email.asObservable(), myLogin.password.asObservable(), myLogin.j_captcha.asObservable(), captchaNeeded.asObservable(), is2FAUI.asObservable(), otpCode.asObservable()) { (emailValue, passwordValue, j_captchaValue, captchaNeededValue, is2FAUIValue, otpCodeValue) -> Bool in
            if is2FAUIValue {
                return otpCodeValue.length > 0
            } else {
                if captchaNeededValue && j_captchaValue.length == 0 {
                    return false
                } else {
                    return (emailValue.length > 0 && passwordValue.length > 0)
                }
            }
            }
            .map {$0.boolValue}
            .bindTo(loginButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
        view.transform = CGAffineTransformIdentity
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
        let textStr = myLogin.email.value
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
                    strongSelf.myLogin.email.value = value
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
        let tipMsg = is2FAUI.value.boolValue ? loginTipFor2FA() : myLogin.goToLoginTipWithCaptcha(captchaNeeded.value)
        if let tip = tipMsg {
            kTipAlert(tip)
            return
        }
        self.view.endEditing(true)
        
        let captchaViewSize = loginButton.bounds.size
        activityIndicator.center = CGPoint(x: captchaViewSize.width / 2, y: captchaViewSize.height / 2)
        loginButton.addSubview(activityIndicator)
        //start animation
        activityIndicator.startAnimating()
        //enable the button
        loginButton.enabled = false
        
        if is2FAUI.value.boolValue {
            
        } else {
            let aPath = myLogin.toPath
            let params = myLogin.toParams
            NetAPIManager.sharedInstance.request_Login(aPath, params: params, block: { [weak self] (result, error) in
                if let strongSelf = self {
                    strongSelf.loginButton.enabled = true
                    strongSelf.activityIndicator.stopAnimating()
                    if result != nil {
                        Login.setPreUserEmail(strongSelf.myLogin.email.value)
                        (UIApplication.sharedApplication().delegate as! AppDelegate).setupTabViewController()
                        strongSelf.doSomethingAfterLogin()
                        return
                    }
                    let global_key = error?.userInfo["msg"]?["two_factor_auth_code_not_empty"] as? String
                    let activate_key = error?.userInfo["msg"]?["user_need_activate"] as? String
                    if global_key?.length > 0 {
                        strongSelf.changeUITo2FAWithGK(global_key!)
                    } else if activate_key != nil {
                        return
                    } else {
                        NSObject.showError(error!)
                        strongSelf.refreshCaptchaNeeded()
                    }
                }
                })
        }
    }
    
    // MARK: - Method
    private func loginTipFor2FA() -> String? {
        var tipStr: String?
        if otpCode.value.length == 0  {
            tipStr = "动态验证码不能为空"
        } else {
            if !otpCode.value.isPureInt() || otpCode.value.length != 6 {
                tipStr = "动态验证码必须是一个6位数字"
            }
        }
        return tipStr
    }
    
    private func doSomethingAfterLogin() {
        let curUser = Login.curLoginUser
        if let user = curUser {
            if user.email?.length > 0 && !Bool(user.email_validation!) {
                let alertView = UIAlertView(title: "激活邮箱", message: "该邮箱尚未激活，请尽快去邮箱查收邮件并激活账号。如果在收件箱中没有看到，请留意一下垃圾邮件箱子（T_T）", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "重新激发邮件")
                alertView.show()
            }
        }
    }
    
    private func changeUITo2FAWithGK(key: String) {
        
    }
    
    private func refreshCaptchaNeeded() {
        NetAPIManager.sharedInstance.request_CaptchaNeeded("api/captcha/login") { [weak self] (result, error) in
            if let strongSelf = self {
                if let result = result {
                    let value = result as? Int
                    if let value = value {
                        strongSelf.captchaNeeded.value = Bool(value)
                    }
                    strongSelf.myTableView.reloadData()
                }
            }
        }
    }
    
    @objc private func cannotLoginBtnClicked() {
        print("找回密码")
    }
    
    @objc private func dismissButtonClicked(sender: AnyObject) {
        if is2FAUI.value.boolValue {
            is2FAUI.value = false
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return is2FAUI.value.boolValue ? 2 : (captchaNeeded.value.boolValue ? 3 : 2)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if is2FAUI.value.boolValue && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Login2FATipCell.kCellIdentifier_Login2FATipCell, forIndexPath: indexPath) as! Login2FATipCell
            cell.tipLabel.text = "  您的账户开启了两步验证，请输入动态验证码登录  "
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(indexPath.row > 1 ? Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Captcha : Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Text, forIndexPath: indexPath) as! Input_OnlyText_Cell
        cell.isForLoginVC = true
        
        if is2FAUI.value.boolValue {
            
        } else {
            if indexPath.row == 0 {
                cell.textField.keyboardType = .EmailAddress
                cell.setPlacerholder(" 手机号码/电子邮箱/个性后缀", value: myLogin.email.value)
                cell.textValueChangedBlock = { [weak self] value in
                    if let strongSelf = self {
                        strongSelf.inputTipsView.valueStr = value
                        strongSelf.inputTipsView.active = true
                        strongSelf.myLogin.email.value = value
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
                cell.setPlacerholder(" 密码", value: myLogin.password.value)
                cell.textField.secureTextEntry = true
                cell.textValueChangedBlock = { [weak self] value in
                    if let strongSelf = self {
                        strongSelf.myLogin.password.value = value
                    }
                }
            } else {
                cell.setPlacerholder(" 验证码", value: myLogin.j_captcha.value)
                cell.textValueChangedBlock = { [weak self] value in
                    if let strongSelf = self {
                        strongSelf.myLogin.j_captcha.value = value
                    }
                }
            }
        }
        return cell
    }
}

extension LoginViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.sendActivateEmail();
        }
    }
    
    private func sendActivateEmail() {
        NetAPIManager.sharedInstance.request_SendActivateEmail(Login.curLoginUser!.email!) { (result, error) in
            if result != nil  {
                NSObject.showHudTipStr("邮件已发送")
            }
        }
    }
}
