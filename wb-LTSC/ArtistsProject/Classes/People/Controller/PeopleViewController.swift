//
//  PeopleViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/15.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class PeopleViewController: YPTabBarController {
    
    fileprivate var tabBarH: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        setup()
        
        addTabBarViewControllers()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreBtn)
    }
    
    fileprivate lazy var moreBtn: UIButton = {
        
        let moreBtn = UIButton(type: .custom)
        moreBtn.setTitle("更多", for: .normal)
        moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        moreBtn.setTitleColor(UIColor.white, for: .normal)
        moreBtn.sizeToFit()
        moreBtn.addTarget(self, action: #selector(PeopleViewController.moreClick), for: .touchUpInside)
        
        return moreBtn
    }()
}
    
extension PeopleViewController {
        // 初始化, 定制带顶部tabBar视图
        func setup() {
            // 设置底部视图的高度
            self.setTabBarFrame(CGRect(x: 0, y: APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: tabBarH), contentViewFrame:CGRect(x: 0, y: tabBarH + APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: ScreenH - (APP_NAVIGATIONBAR_HEIGHT + APP_TABBAR_HEIGHT + tabBarH)))
            
            // tabBar背景色
            self.tabBar.dk_backgroundColorPicker = topBar_backgroundColorPicker
            
            // 文字颜色
//            self.tabBar.itemTitleColor = APP_TABBARITEM_NORMAL_COLOR
            self.tabBar.itemTitleSelectedColor = APP_TABBARITEM_SELET_COLOR
            self.tabBar.itemTitleFont = UIFont.systemFont(ofSize: 14)
            self.tabBar.itemTitleSelectedFont = UIFont.systemFont(ofSize: 16)
            
            // TabItem的选中背景是否随contentView滑动而移动
            self.tabBar.isItemSelectedBgScrollFollowContent = false
            
            // 拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
            self.tabBar.isItemFontChangeFollowContentScroll = true
            
            // 设置tabBar可以左右滑动，并且item的宽度根据标题的宽度来匹配
//            self.tabBar.setScrollEnabledAndItemFitTextWidthWithSpacing(20.0)
            
            // 设置内容视图支持滑动切换，以及点击item切换时是否有动画
            self.setContentScrollEnabledAndTapSwitch(animated: true)
        }
        
        // 添加tabBar控制器
        func addTabBarViewControllers() {

            // 艺术家
            let artistVC = HeadlineBaseController()
            artistVC.yp_tabItemTitle = "专题"
            artistVC.term_id = "104"

            // 大师
            let masterVC = PeopleBaseController()
            masterVC.yp_tabItemTitle = "大师"
            masterVC.artist_uid = "1"
            masterVC.artist_level = "94"
            
            // 大家
            let peopleVC = PeopleBaseController()
            peopleVC.yp_tabItemTitle = "大家"
            peopleVC.artist_uid = "2"
            peopleVC.artist_level = "23"
            
            // 名家
            let famousVC = PeopleBaseController()
            famousVC.yp_tabItemTitle = "名家"
            famousVC.artist_level = "95"
            famousVC.artist_uid = "3"
            
            // 新锐
            let freshVC = PeopleBaseController()
            freshVC.yp_tabItemTitle = "新锐"
            freshVC.artist_level = "96"
            freshVC.artist_uid = "4"
            
            self.viewControllers = [artistVC, masterVC, peopleVC, famousVC, freshVC]
        }
}

extension PeopleViewController {
    
    /// 更多点击事件
    func moreClick(btn: UIButton) {
        
        let moreVC = MorePeopleController()
        switch moreBtn.tag {
        case 10:
            moreVC.artist_uid = "1"
            
        case 11:
            moreVC.artist_uid = "2"
            
        case 12:
            moreVC.artist_uid = "3"
            
        default:
            moreVC.artist_uid = "4"
        }
        navigationController?.pushViewController(moreVC, animated: true)
    }
    
    override func didSelectViewController(at index: UInt) {
        
        PrintLog(message: "current controller index = \(index)")
        switch index {
        case 0:
            moreBtn.isHidden = true
            
        case 1:
            moreBtn.tag = 10
            moreBtn.isHidden = false
        case 2:
            moreBtn.tag = 11
            moreBtn.isHidden = false
        case 3:
            moreBtn.tag = 12
            moreBtn.isHidden = false
        default:
            moreBtn.tag = 13
            moreBtn.isHidden = false
        }
    }
}
