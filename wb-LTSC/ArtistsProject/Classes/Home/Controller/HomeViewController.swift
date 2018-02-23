//
//  HomeViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/15.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit
//import MJExtension

class HomeViewController: YPTabBarController {

    fileprivate var tabBarH: CGFloat = 40
    fileprivate var bgView = UIView()
    fileprivate let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/category.data")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = .white
        
        // 2. 初始化
        setup()
        
        let arr = NSKeyedUnarchiver.unarchiveObject(withFile: filePath!)
        if !MSBAccount.userLogin() && arr != nil {
            
            self.dataSource.removeAll()
            self.dataSource = arr as! [ArticleCategoryModel]
            
            DispatchQueue.main.async { // 返回主线程刷新界面
                self.addTabBarViewControllers()
            }
        }else {
        
            // 1. 请求文章分类
            performSelector(inBackground: #selector(HomeViewController.requestArticleCategory), with: nil)
        }
    }
    
    lazy var dataSource: [ArticleCategoryModel] = {
        
        let dataSource = [ArticleCategoryModel]()
        return dataSource
    }()
}

extension HomeViewController {
    //MARK: - 请求文章分类
    func requestArticleCategory() {
        
        DispatchQueue.global().async {
            LLRequestServer.shareInstance().requestHomeArticleCategory(success: { (response, data) in
                
                    guard let data = data else {
                        if let arr = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath!) {
                            self.dataSource.removeAll()
                            self.dataSource = arr as! [ArticleCategoryModel]

                            DispatchQueue.main.async { // 返回主线程刷新界面
                                self.addTabBarViewControllers()
                            }
                        }
                        return
                    }
                    let arr = ArticleCategoryModel.mj_objectArray(withKeyValuesArray: data)
                    
                    if (arr?.count)! > 0 {
                        self.dataSource.removeAll()
                        for model in arr! {
                            self.dataSource.append(model as! ArticleCategoryModel)
                        }
                        
                        NSKeyedArchiver.archiveRootObject(self.dataSource, toFile: self.filePath!)
                        PrintLog(message: "\(String(describing: self.filePath)) ------")
                        DispatchQueue.main.async { // 返回主线程刷新界面
                            self.addTabBarViewControllers()
                        }
                    }else {
                        let arr = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath!)
                        guard arr == nil else {
                            self.dataSource.removeAll()
                            self.dataSource = arr as! [ArticleCategoryModel]
                            
                            DispatchQueue.main.async { // 返回主线程刷新界面
                                self.addTabBarViewControllers()
                            }
                            return
                        }
                    }
                }, failure: { (response) in
                    if let arr = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath!) {
                        self.dataSource.removeAll()
                        self.dataSource = arr as! [ArticleCategoryModel]
                        
                        DispatchQueue.main.async { // 返回主线程刷新界面
                            self.addTabBarViewControllers()
                         }
                    }
            }) { (error) in
                    if let arr = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath!) {
                        self.dataSource.removeAll()
                        self.dataSource = arr as! [ArticleCategoryModel]
                        
                        DispatchQueue.main.async { // 返回主线程刷新界面
                            self.addTabBarViewControllers()
                        }
                }
            }
        }
    }
    
    // MARK: - token 无效, 直接从本地拿数据
    func tokenErrorGetDataFromLocal() {
    
        let arr = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath!)
        guard arr == nil else {
            self.dataSource.removeAll()
            self.dataSource = arr as! [ArticleCategoryModel]
            
            DispatchQueue.main.async { // 返回主线程刷新界面
                self.addTabBarViewControllers()
            }
            return
        }
    }
    
    // 初始化, 定制带顶部tabBar视图
    func setup() {
        // 设置底部视图的高度
        self.setTabBarFrame(CGRect(x: 0, y: APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: tabBarH), contentViewFrame:CGRect(x: 0, y: tabBarH + APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: ScreenH - (APP_NAVIGATIONBAR_HEIGHT + APP_TABBAR_HEIGHT + tabBarH)))
        
        // tabBar背景色
        self.tabBar.dk_backgroundColorPicker = topBar_backgroundColorPicker
        self.view.dk_backgroundColorPicker = tableView_backgroundColorPicker
        // 文字颜色
//        self.tabBar.itemTitleColor = APP_TABBARITEM_NORMAL_COLOR
        self.tabBar.itemTitleSelectedColor = APP_TABBARITEM_SELET_COLOR
        self.tabBar.itemTitleFont = UIFont.systemFont(ofSize: 14)
        self.tabBar.itemTitleSelectedFont = UIFont.systemFont(ofSize: 16)
        
        // TabItem的选中背景是否随contentView滑动而移动
        self.tabBar.isItemSelectedBgScrollFollowContent = false
        
        // 拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
        self.tabBar.isItemFontChangeFollowContentScroll = true
        
        // 设置tabBar可以左右滑动，并且item的宽度根据标题的宽度来匹配
        self.tabBar.setScrollEnabledAndItemFitTextWidthWithSpacing(25.0)
        
        // 设置内容视图支持滑动切换，以及点击item切换时是否有动画
        self.setContentScrollEnabledAndTapSwitch(animated: true)
        
        // 添加整理图标按钮
        bgView.frame = CGRect(x: ScreenW - tabBarH, y: APP_NAVIGATIONBAR_HEIGHT, width: tabBarH, height: tabBarH)
        bgView.backgroundColor = UIColor.clear
        view.addSubview(bgView)
        
        let arrange = UIImageView(frame: CGRect(x: 4.5, y: 4.5, width: 31, height: 31))
        arrange.image = #imageLiteral(resourceName: "home_arrange")
        arrange.isUserInteractionEnabled = true
        arrange.contentMode = .center
        bgView.addSubview(arrange)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toSort))
        bgView.addGestureRecognizer(tap)
    }
    
    func toSort() {
        
        let sortVC = SortViewController()
        sortVC.dataArr = dataSource
        sortVC.backSort = { dataArray in
            
            self.dataSource.removeAll()
            self.dataSource = dataArray
            NSKeyedArchiver.archiveRootObject(self.dataSource, toFile: self.filePath!)
            self.addTabBarViewControllers()
        }
        navigationController?.pushViewController(sortVC, animated: true)
    }
    
    // 添加tabBar控制器
    func addTabBarViewControllers() {
        var vcArr: [UIViewController] = []
        
        for model in dataSource {
            switch model.term_id {
            case "0":
                let recommendVC = RecommendViewController()
                recommendVC.yp_tabItemTitle = model.name
                vcArr.append(recommendVC)
            case "16":
                let vc = MSBYZHController();
                vc.yp_tabItemTitle = model.name
                vcArr.append(vc)
            case "14":
                let vc = HotShowController();
                vc.yp_tabItemTitle = model.name
                vcArr.append(vc)
            default:
                let vc = HeadlineBaseController()
                vc.yp_tabItemTitle =  model.name
                vc.term_id = model.term_id
                vcArr.append(vc)
            }
       }
        self.viewControllers = vcArr
    }
}

extension HomeViewController{
    func testDetail() {
        
        let  item1 = UIBarButtonItem(title: "个人详情", style: UIBarButtonItemStyle.done, target: self, action: #selector(HomeViewController.jumpDetail))
        navigationItem.rightBarButtonItems = [item1];
    }
    
    override func tabItemDidSelected() {
        print("----tabItemDidSelected-----\(self.selectedControllerIndex)")
    }

    func jumpDetail(){
        
        let  articleDetailVC = MSBPersonCenterController();
        self.navigationController?.pushViewController(articleDetailVC, animated: true);
    }
}

