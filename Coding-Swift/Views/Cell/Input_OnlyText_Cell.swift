//
//  Input_OnlyText_Cell.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/12.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class Input_OnlyText_Cell: UITableViewCell {
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFontOfSize(17.0)
        field.addTarget(self, action: #selector(editDidBegin(_:)), forControlEvents: .EditingDidBegin)
        return field
    }()
    
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - TextField
    private func editDidBegin(sender: AnyObject) {
        
    }
}
