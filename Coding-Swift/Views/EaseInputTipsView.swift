//
//  EaseInputTipsView.swift
//  Coding-Swift
//
//  Created by Sean on 16/7/1.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

enum EaseInputTipsViewType: Int {
    case EaseInputTipsViewTypeLogin = 0
    case EaseInputTipsViewTypeRegister
}

class EaseInputTipsView: UIView {
    
    private var _type: EaseInputTipsViewType = .EaseInputTipsViewTypeLogin
    var type :EaseInputTipsViewType {
        return _type
    }
    var active = false {
        didSet {
            if let list = dataList {
                self.hidden = list.count <= 0 || !active
            } else {
                self.hidden = true
            }
        }
    }
    var valueStr = String() {
        didSet(newValue) {
            if newValue.length <= 0 {
                if var list = dataList {
                    list.removeAll()
                }
            } else if let location = newValue.rangeOfString("@")?.count {
                if location == 0 {
                    dataList = _type == .EaseInputTipsViewTypeLogin ? loginList : nil
                }
            }
        }
    }
    
    private var emailAllList: [String] {
        let emaillStr = "qq.com, 163.com, gmail.com, 126.com, sina.com, sohu.com, hotmail.com, tom.com, sina.cn, foxmail.com, yeah.net, vip.qq.com, 139.com, live.cn, outlook.com, aliyun.com, yahoo.com, live.com, icloud.com, msn.com, 21cn.com, 189.cn, me.com, vip.sina.com, msn.cn, sina.com.cn"
        return emaillStr.componentsSeparatedByString(", ")
    }
    private var loginList: [String]? {
        if valueStr.length == 0 {
            return nil
        }
        var list = [String]()
        for loginStr in loginAllList {
            if let location = loginStr.rangeOfString(valueStr)?.count {
                if location > 0 {
                    list.append(loginStr)
                }
            }
        }
        return list
    }
    private var loginAllList: [String] {
        return Login.readLoginDataList().allKeys as! [String]
    }
    private var dataList: [String]?
    
    // MARK: - Views
    private lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
//        tableView.dataSource = self
//        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        self.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - Initialize
    init(type: EaseInputTipsViewType) {
        let padingWidth = Bool(type.rawValue) ? kLoginPaddingLeftWidth : 0.0
        super.init(frame: CGRectMake(padingWidth, 0, kScreen_Width-2*kLoginPaddingLeftWidth, 120.0))
        
        myTableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        _type = type
        active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func tipsViewWithType(type: EaseInputTipsViewType) -> EaseInputTipsView {
        return EaseInputTipsView(type: type)
    }
    
    // MARK: - Func
    func refresh() {
        myTableView.reloadData()
        if let list = dataList {
            self.hidden = list.count <= 0 || !active
        } else {
            self.hidden = true
        }
    }
    
}

//extension EaseInputTipsView: UITableViewDelegate, UITableViewDataSource {
//    
//}
