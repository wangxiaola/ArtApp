//
//  BaseNavigationController.swift
//  evtmaster
//
//  Created by LWR on 16/9/26.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setup()
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func setup() {
        // 设置字体大小,颜色
        var titleAttDic: [String : NSObject] = Dictionary()
        titleAttDic[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 18)
        titleAttDic[NSForegroundColorAttributeName] = UIColor.white
        navigationBar.titleTextAttributes = titleAttDic
        
        // 设置代理
        interactivePopGestureRecognizer?.delegate = self
        
        // 设置导航item样式
        let item  = UIBarButtonItem.appearance()
        
        // 普通状态
        var textAttrs = [String : Any]()
        textAttrs[NSForegroundColorAttributeName] = UIColor.white
        textAttrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 16.0)
        item.setTitleTextAttributes(textAttrs, for: .normal)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }else {
            return true
        }
    }
    
    // 允许同时响应多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "navigation_back"), style: .plain, target: self, action: #selector(back))
        }
        super.pushViewController(viewController, animated: animated)
        if isIPhoneX {
            var tabFrame = self.tabBarController?.tabBar.frame
            tabFrame?.origin.y = ScreenH - (tabFrame?.size.height)!
            self.tabBarController?.tabBar.frame = tabFrame!
        }
    }
    
    
    
    func back() {
        popViewController(animated: true)
    }
}
