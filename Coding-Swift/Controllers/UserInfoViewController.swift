//
//  UserInfoViewController.swift
//  Coding-Swift
//
//  Created by Sean on 16/7/26.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class UserInfoViewController: BaseViewController {

    var followChanged: (User -> Void)?
    var isRoot = false
    var curUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
