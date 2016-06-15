//
//  Input_OnlyText_Cell.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/12.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class Input_OnlyText_Cell: UITableViewCell {
    
    var isForLoginVC: Bool = false
    
    // MARK: - Customer View
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFontOfSize(17.0)
        field.addTarget(self, action: #selector(editDidBegin(_:)), forControlEvents: .EditingDidBegin)
        field.addTarget(self, action: #selector(editValueChanged(_:)), forControlEvents: .EditingChanged)
        field.addTarget(self, action: #selector(editDidEnd(_:)), forControlEvents: .EditingDidEnd)
        return field
    }()
    
    private lazy var captchaView: UITapImageView = {
       let tapView = UITapImageView()
        tapView.layer.masksToBounds = true
        tapView.layer.cornerRadius = 5.0
        tapView.addTapBlock({ (obj) in
            self.refreshCaptchaImage()
        })
        return tapView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .Gray)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var passwordBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "password_unlook"), forState: .Normal)
        button.addTarget(self, action: #selector(passwordBtnClicked(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    private lazy var verify_codeBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(phoneCodeButtonClicked(_:)), forControlEvents: .TouchUpInside)
        return button
    }()
    
    private lazy var countryCodeLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(17.0)
        label.textColor = UIColor.colorWithHexString("0x3bbd79")
        return label
    }()
    
    private lazy var clearBtn: UIButton = {
        let btn = UIButton()
        btn.contentHorizontalAlignment = .Right
        btn.setImage(UIImage(named: "text_clear_btn"), forState: .Normal)
        btn.addTarget(self, action: #selector(clearBtnClicked(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithHexString("0xffffff").colorWithAlphaComponent(0.5)
        return view
    }()
    
    // MARK: -
    static let kCellIdentifier_Input_OnlyText_Cell_Text         = "Input_OnlyText_Cell_Text"
    static let kCellIdentifier_Input_OnlyText_Cell_Captcha      = "Input_OnlyText_Cell_Captcha"
    static let kCellIdentifier_Input_OnlyText_Cell_Password     = "Input_OnlyText_Cell_Password"
    static let kCellIdentifier_Input_OnlyText_Cell_Phone        = "Input_OnlyText_Cell_Phone"
    
    private static let kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix = "Input_OnlyText_Cell_PhoneCode"
    
    class func randomCellIdentifierOfPhoneCodeType() -> String {
        return "\(kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix)_\(random())"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        //Subviews
        contentView.addSubview(textField)
        textField.snp_makeConstraints { (make) in
            make.height.equalTo(20.0)
            make.left.equalTo(contentView).offset(kLoginPaddingLeftWidth)
            make.right.equalTo(contentView).offset(-kLoginPaddingLeftWidth)
            make.centerY.equalTo(contentView)
        }
        
        if reuseIdentifier == Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Captcha {
            contentView.addSubview(captchaView)
            captchaView.snp_makeConstraints(closure: { (make) in
                make.right.equalTo(contentView).offset(-kLoginPaddingLeftWidth)
                make.centerY.equalTo(contentView)
                make.width.equalTo(60.0)
                make.height.equalTo(25.0)
            })
            
            contentView.addSubview(activityIndicator)
            activityIndicator.snp_makeConstraints(closure: { (make) in
                make.center.equalTo(captchaView)
            })
        } else if reuseIdentifier == Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Password {
            textField.secureTextEntry = true
            
            contentView.addSubview(passwordBtn)
            passwordBtn.snp_makeConstraints(closure: { (make) in
                make.width.height.equalTo(44.0)
                make.centerY.equalTo(contentView)
                make.right.equalTo(contentView).offset(-kLoginPaddingLeftWidth)
            })
        } else if reuseIdentifier == Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix {
            contentView.addSubview(verify_codeBtn)
            verify_codeBtn.snp_makeConstraints(closure: { (make) in
                make.width.equalTo(80.0)
                make.height.equalTo(25.0)
                make.centerY.equalTo(contentView)
                make.right.equalTo(contentView).offset(-kLoginPaddingLeftWidth)
            })
        } else if reuseIdentifier == Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Phone {
            contentView.addSubview(countryCodeLbl)
            countryCodeLbl.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(contentView).offset(kPaddingLeftWidth)
                make.centerY.equalTo(contentView)
            })
            
            let lineV: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor.colorWithHexString("0xCCCCCC")
                contentView.addSubview(view)
                view.snp_makeConstraints(closure: { (make) in
                    make.left.equalTo(countryCodeLbl.snp_right).offset(8.0)
                    make.centerY.equalTo(countryCodeLbl)
                    make.width.equalTo(0.5)
                    make.height.equalTo(15.0)
                })
                return view
            }()
            
            let _: UIButton = {
                let button = UIButton()
                button.addTarget(self, action: #selector(countryCodeBtnClicked(_:)), forControlEvents: .TouchUpInside)
                contentView.addSubview(button)
                button.snp_makeConstraints(closure: { (make) in
                    make.top.bottom.left.equalTo(contentView)
                    make.right.equalTo(lineV)
                })
                return button
            }()
            
            textField.snp_remakeConstraints(closure: { (make) in
                make.height.equalTo(20.0)
                make.centerY.equalTo(contentView)
                make.left.equalTo(lineV.snp_right).offset(8.0)
                make.right.equalTo(contentView).offset(-kLoginPaddingLeftWidth)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setPlacerholder(placer:String, value: String) {
        textField.attributedPlaceholder = NSAttributedString(string: placer, attributes: [NSForegroundColorAttributeName : UIColor.colorWithHexString(isForLoginVC ? "0xffffff" : "0x999999").colorWithAlphaComponent(isForLoginVC ? 0.5 : 1.0)])
        textField.text = value
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isForLoginVC {
            contentView.addSubview(clearBtn)
            clearBtn.snp_makeConstraints(closure: { (make) in
                make.width.height.equalTo(30.0)
                make.centerY.equalTo(contentView)
                make.right.equalTo(contentView).offset(-kLoginPaddingLeftWidth)
            })
            
            contentView.addSubview(lineView)
            lineView.snp_makeConstraints(closure: { (make) in
                make.height.equalTo(0.5)
                make.left.equalTo(contentView).offset(kLoginPaddingLeftWidth)
                make.right.equalTo(contentView).offset(-kLoginPaddingLeftWidth)
                make.bottom.equalTo(contentView)
            })
        }
        
        backgroundColor = isForLoginVC ? UIColor.clearColor() : UIColor.whiteColor()
        textField.clearButtonMode = isForLoginVC ? .Never : .WhileEditing
        textField.textColor = isForLoginVC ? UIColor.whiteColor() : UIColor.colorWithHexString("0x222222")
        lineView.hidden = !isForLoginVC
        clearBtn.hidden = true
        
        var rightElement: UIView?
        if reuseIdentifier == Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Text {
            rightElement = nil
        } else if reuseIdentifier == Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Captcha {
            rightElement = captchaView
        } else if reuseIdentifier == Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_Password {
            rightElement = passwordBtn
        } else if reuseIdentifier == Input_OnlyText_Cell.kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix {
            rightElement = verify_codeBtn
        }
        
        var offset: CGFloat = 0
        if let rightElement = rightElement {
            offset = CGRectGetMinY(rightElement.frame) - kScreen_Width - 10.0
        } else {
            offset = -kLoginPaddingLeftWidth
        }
        
        clearBtn.snp_remakeConstraints { (make) in
            make.right.equalTo(contentView).offset(offset)
        }
        
        textField.snp_remakeConstraints { (make) in
            offset = offset - (self.isForLoginVC ? 30.0 : 0)
            make.right.equalTo(contentView).offset(offset)
        }
    }
    
    // MARK: - TextField
    @objc private func editDidBegin(sender: AnyObject) {
        
    }
    
    @objc private func editValueChanged(sender: AnyObject) {
        
    }
    
    @objc private func editDidEnd(sender: AnyObject) {
        
    }
    
    // MARK: - Button
    @objc private func passwordBtnClicked(sender: AnyObject) {
        
    }
    
    @objc private func phoneCodeButtonClicked(sender: AnyObject) {
        
    }
    
    @objc private func countryCodeBtnClicked(sender: AnyObject) {
        
    }
    
    @objc private func clearBtnClicked(sender: AnyObject) {
        
    }
    
    // MARK: - Action
    private func refreshCaptchaImage() {
        
    }
}
