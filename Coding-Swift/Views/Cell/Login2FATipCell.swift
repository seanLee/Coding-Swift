//
//  Login2FATipCell.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/28.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class Login2FATipCell: UITableViewCell {

    static let kCellIdentifier_Login2FATipCell = "Login2FATipCell"
    
    var tipLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tipLabel = {
            let label = UILabel()
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 2.0
            label.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            label.font = UIFont.systemFontOfSize(16.0)
            label.minimumScaleFactor = 0.5
            label.adjustsFontSizeToFitWidth = true
            label.textColor = UIColor.whiteColor()
            contentView.addSubview(label)
            return label
        }()
        
        (
            tipLabel.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(10.0, kLoginPaddingLeftWidth, 0, kLoginPaddingLeftWidth))
            })
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
