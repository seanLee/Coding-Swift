//
//  LoginViewController.swift
//  Coding-Swift
//
//  Created by Sean on 16/6/12.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    var showDismissButton: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button = PhoneCodeButton()
        button.frame = CGRectMake(0, 0, 100.0, 32.0)
        button.center = CGPointMake(kScreen_Width/2.0, kScreen_Height/2.0)
        view.addSubview(button)
        
        print(Input_OnlyText_Cell().textField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
