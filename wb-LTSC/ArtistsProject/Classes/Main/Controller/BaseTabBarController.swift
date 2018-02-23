//
//  BaseTabBarController.swift
//  evtmaster
//
//  Created by LWR on 16/9/26.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func loadView() {
        super.loadView()
         // 初始化item的文字大小和颜色
        
        //let
        
        let item = UITabBarItem.appearance()
        var attDic: [String : NSObject] = Dictionary()
        attDic[NSFontAttributeName] = UIFont.systemFont(ofSize: 12)
        attDic[NSForegroundColorAttributeName] = APP_TABBARITEM_SELET_COLOR
        item.setTitleTextAttributes(attDic, for: .selected)
        
        let isNight = UserDefaults.standard.bool(forKey: APP_NIGHT_MODE)
        
        var attNor: [String : NSObject] = Dictionary()
        if isNight {
            attNor[NSForegroundColorAttributeName] = APP_TABBARITEM_NORMAL_COLOR
        }else{
           attNor[NSForegroundColorAttributeName] = UIColor.black
        }
        attNor[NSFontAttributeName] = UIFont.systemFont(ofSize: 12)
        item.setTitleTextAttributes(attNor, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseTabBarController.changeColor(noti:)), name: NSNotification.Name(rawValue:"changeColor"), object: nil)
    }
    
    func changeColor(noti: Notification) {
        
        let night = noti.userInfo?["isNight"]
        let item = UITabBarItem.appearance()
        if night as! Bool {
            var attNor: [String : NSObject] = Dictionary()
            attNor[NSForegroundColorAttributeName] = APP_TABBARITEM_NORMAL_COLOR
            attNor[NSFontAttributeName] = UIFont.systemFont(ofSize: 12)
            item.setTitleTextAttributes(attNor, for: .normal)
        }else{
            var attNor: [String : NSObject] = Dictionary()
            attNor[NSForegroundColorAttributeName] = UIColor.black
            attNor[NSFontAttributeName] = UIFont.systemFont(ofSize: 12)
            item.setTitleTextAttributes(attNor, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    
//    override var shouldAutorotate: Bool {
//        let nav: UINavigationController = self.selectedViewController as! UINavigationController
//        let vc = nav.topViewController
//        
//        if (vc?.isKind(of: MSBYZHDetailController.self))! {
//            return true
//        }
//        
//        return false
//    }
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//       return UIInterfaceOrientationMask.allButUpsideDown
//    }
}

extension BaseTabBarController {
    func setup() {
        tabBar.dk_barTintColorPicker = barTintColorPicker
        
        setupAllChildControllerAndTabItem()
    }
    
    fileprivate func setupAllChildControllerAndTabItem() {
        let homeVC = HomeViewController()
        setupOneChildController(homeVC, norImage: "tabbar_home", selImage: "tabbar_home", title: "首页")
        
        let categoryVC = PeopleViewController()
        setupOneChildController(categoryVC, norImage: "tabbar_people", selImage: "tabbar_people", title: "人物")
        
        let manageVC = AgencyViewController()
        setupOneChildController(manageVC, norImage: "tabbar_agency", selImage: "tabbar_agency", title: "机构")
        
        let myVC = MyViewController()
        setupOneChildController(myVC, norImage: "tabbar_mine", selImage: "tabbar_mine", title: "我的")
    }
}

extension BaseTabBarController {
    func setupOneChildController(_ controll: UIViewController, norImage: String, selImage: String, title: String) {
        let imageNor: UIImage? = UIImage(named: norImage)
        let imageSel: UIImage? = UIImage(named: selImage)
        
        let nav = BaseNavigationController(rootViewController: controll)
        
        // 设置标题图片
        let logoView = UIImageView(image: #imageLiteral(resourceName: "meishubao_logo"))
        controll.navigationItem.titleView = logoView
        controll.tabBarItem.title = title;
        controll.tabBarItem.image = imageNor!.withRenderingMode(.alwaysOriginal)
        controll.tabBarItem.selectedImage = imageSel!.withRenderingMode(.alwaysOriginal)
        addChildViewController(nav)
    }
}

