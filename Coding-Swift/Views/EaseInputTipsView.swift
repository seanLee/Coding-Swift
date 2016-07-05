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
    
    var selectedTipBlock: (String -> Void)?
    
    private var _type: EaseInputTipsViewType = .EaseInputTipsViewTypeLogin
    var type :EaseInputTipsViewType {
        return _type
    }
    var active = false {
        didSet {
            self.hidden = dataList.count <= 0 || !active
        }
    }
    var valueStr = String() {
        didSet {
            if valueStr.length <= 0 {
                dataList.removeAll()
            } else if let location = valueStr.rangeOfString("@") {
                if location.count > 0 {
                    if let emailList = emailList {
                        dataList = emailList
                    }
                }
            } else {
                dataList = _type == .EaseInputTipsViewTypeLogin ? (loginList != nil ? loginList! : [String]()) : [String]()
            }
            refresh()
        }
    }
    
    private var emailList: [String]? {
        if valueStr.length == 0 {
            return nil
        }
        if valueStr.rangeOfString("@") == nil {
            return nil
        }
        if let location = valueStr.rangeOfString("@") {
            if location.count == 0 {
                return nil
            }
            let nameStr = valueStr.substringToIndex(location.startIndex)
            let tipStr  = valueStr.substringFromIndex(location.endIndex)
            var list = [String]()
            for emaill in emailAllList {
                if tipStr.length == 0 || emaill.rangeOfString(tipStr) != nil {
                    list.append("\(nameStr)@\(emaill)")
                }
            }
            return list
        }
        return nil
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
    private var dataList = [String]()
    
    // MARK: - Views
    private lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        tableView.registerClass(TipCell.classForCoder(), forCellReuseIdentifier: TipCell.cellIdentifier)
        self.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - Initialize
    init(type: EaseInputTipsViewType) {
        let padingWidth = (type == .EaseInputTipsViewTypeLogin) ? kLoginPaddingLeftWidth : 0.0
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
        self.hidden = dataList.count <= 0 || !active
    }
    
}

extension EaseInputTipsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCellWithIdentifier(TipCell.cellIdentifier, forIndexPath: indexPath) as! TipCell
        cell.setTipText(dataList[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.addLineforPlainCell(cell, indexPath: indexPath, leftSpace: kLoginPaddingLeftWidth, hasSectionLine: false)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let block = selectedTipBlock where dataList.count > indexPath.row {
            block(dataList[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35.0
    }
}

private class TipCell: UITableViewCell {
    static let cellIdentifier = "TipCell"
    
    private lazy var textLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14.0)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textLbl)
        textLbl.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(kLoginPaddingLeftWidth)
            make.right.equalTo(contentView).offset(-kLoginPaddingLeftWidth)
            make.top.bottom.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Func
    func setTipText(tip: String) {
        textLbl.text = tip
    }
}
