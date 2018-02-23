//
//  AgencyViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/15.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class AgencyViewController: YPTabBarController {
    
    fileprivate var tabBarH: CGFloat = 40

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1, 初始化
        setup()
        
        // 2, 创建子控制器
        addTabBarViewControllers()
    }
    
    //MARK: - 初始化
    func setup() {
        //MAR: - 定制带顶部tabBar视图
        // 设置底部视图的高度
        self.setTabBarFrame(CGRect(x: 0, y: APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: tabBarH), contentViewFrame:CGRect(x: 0, y: tabBarH + APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: ScreenH - (APP_NAVIGATIONBAR_HEIGHT + APP_TABBAR_HEIGHT + tabBarH)))
        
        // tabBar背景色
        self.tabBar.dk_backgroundColorPicker = topBar_backgroundColorPicker
        
        // 文字颜色
//        self.tabBar.itemTitleColor = APP_TABBARITEM_NORMAL_COLOR
        self.tabBar.itemTitleSelectedColor = APP_TABBARITEM_SELET_COLOR
        self.tabBar.itemTitleFont = UIFont.systemFont(ofSize: 14)
        self.tabBar.itemTitleSelectedFont = UIFont.systemFont(ofSize: 16)
        
        // TabItem的选中背景是否随contentView滑动而移动
        self.tabBar.isItemSelectedBgScrollFollowContent = false
        
        // 拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
        self.tabBar.isItemFontChangeFollowContentScroll = true
        
        // 设置内容视图支持滑动切换，以及点击item切换时是否有动画
        self.setContentScrollEnabledAndTapSwitch(animated: true)

        //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreBtn)
    }
    /*
    fileprivate lazy var moreBtn: UIButton = {
     
        let moreBtn = UIButton(type: .custom)
        moreBtn.setTitle("更多", for: .normal)
        moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        moreBtn.setTitleColor(UIColor.white, for: .normal)
        moreBtn.sizeToFit()
        moreBtn.addTarget(self, action: #selector(AgencyViewController.moreClick), for: .touchUpInside)
        
        return moreBtn
    }()*/
}

extension AgencyViewController {
    //MARK: -  添加tabBar控制器
    func addTabBarViewControllers() {
        // 国家画院
        let countryVC = CountryPaintViewController()
        countryVC.yp_tabItemTitle = "中国国家画院"
        countryVC.term_id = "100"
        
        // 国内机构
        let internalVC = HeadlineBaseController()
        internalVC.yp_tabItemTitle = "艺术机构观察"
        internalVC.term_id = "102"
        //internalVC.agency_id = "1"
        //internalVC.type = .domestic
        
        // 国外机构
        let foreignVC = HeadlineBaseController()
        foreignVC.yp_tabItemTitle = "艺术机构动态"
        foreignVC.term_id = "103"
        //foreignVC.agency_id = "2"
        //foreignVC.type = .overseas

        self.viewControllers = [countryVC, internalVC, foreignVC]
    }
}

extension AgencyViewController {
    
    /// 更多点击事件
    func moreClick(btn: UIButton) {
        
        let moreOrganizationVC = MoreOrganizationViewController()
        if btn.tag == 1 {
            
            moreOrganizationVC.type = .domestic
            moreOrganizationVC.agency_id = "1"
        }else if btn.tag == 2 {
        
            moreOrganizationVC.type = .overseas
            moreOrganizationVC.agency_id = "2"
        }
        
        navigationController?.pushViewController(moreOrganizationVC, animated: true)
    }
    
    override func didSelectViewController(at index: UInt) {
        
        PrintLog(message: "current controller index = \(index)")
        /*
        switch index {
        case 0:
            moreBtn.isHidden = true
            
        case 1:
            moreBtn.isHidden = false
            moreBtn.tag = 1
            
        default:
            moreBtn.isHidden = false
            moreBtn.tag = 2
        }*/
    }
}
