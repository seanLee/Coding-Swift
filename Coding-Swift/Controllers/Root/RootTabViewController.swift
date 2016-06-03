//
//  RootTabViewController.swift
//  Coding-Swift
//
//  Created by sean on 16/4/29.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import Alamofire
import RDVTabBarController

class RootTabViewController: RDVTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        
        let params = ["accountname":"15601760377","doctorid":"12435","token":"43975217a7644ca4b0720d746ee2c655"]
        let testRounter = Router(requestMethod: RequestMethod.Get("ord/getsubjectlist", params))
        NetAPIClient.sharedInstance().requestData(testRounter) { (result, error) in
            guard error == nil else {
                return
            }
        }
        
    }
    
    private func setupViewControllers() {
        let project_root = BaseViewController()
        project_root.view.backgroundColor = UIColor.randomColor()
        let project_nav = BaseNavigationController(rootViewController: project_root)
        
        let task_root = BaseViewController()
        task_root.view.backgroundColor = UIColor.randomColor()
        let task_nav = BaseNavigationController(rootViewController: task_root)
        
        let tweet_root = BaseViewController()
        tweet_root.view.backgroundColor = UIColor.randomColor()
        let tweet_nav = BaseNavigationController(rootViewController: tweet_root)
        
        let message_root = BaseViewController()
        message_root.view.backgroundColor = UIColor.randomColor()
        let message_nav = BaseNavigationController(rootViewController: message_root)
        
        let me_root = BaseViewController()
        me_root.view.backgroundColor = UIColor.randomColor()
        let me_nav = BaseNavigationController(rootViewController: me_root)
        
        self.viewControllers = [project_nav, task_nav, tweet_nav, message_nav, me_nav]
        
        customizeTabBarForController()
        
        self.delegate = self;
    }
    
    private func customizeTabBarForController() {
        let backgroundImage = UIImage(named: "tabbar_background")
        let tabBarItemImages = ["project", "task", "tweet", "privatemessage", "me"]
        let tabBarItemTitles = ["项目", "任务", "冒泡", "消息", "我"]
        
        for (index, item) in (tabBar.items as! [RDVTabBarItem]).enumerate() {
            item.titlePositionAdjustment = UIOffsetMake(0, 3)
            let selectedImage = UIImage.init(named: "\(tabBarItemImages[index])_selected")
            let unselectedimage = UIImage.init(named: "\(tabBarItemImages[index])_normal")
            item.setBackgroundSelectedImage(backgroundImage, withUnselectedImage: backgroundImage)
            item.setFinishedSelectedImage(selectedImage, withFinishedUnselectedImage: unselectedimage)
            item.title = tabBarItemTitles[index]
        }
    }
}

extension RootTabViewController: RDVTabBarControllerDelegate {
    
}
