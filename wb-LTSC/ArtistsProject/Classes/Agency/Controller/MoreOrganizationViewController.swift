//
//  MoreOrganizationViewController.swift
//  meishubao
//
//  Created by LWR on 2016/12/9.
//  Copyright © 2016年 benbun. All rights reserved.
//  

import UIKit
//import MBProgressHUD

class MoreOrganizationViewController: UITableViewController {

    var offset      : String?
    var searchoffset: String?
    var agency_id   : String  = ""
    let choseViewH  : CGFloat = ScreenW * 0.75
    var isSearch    : Bool    = false
    var searchDic   : [String : Any]?
    var type = OrganizationType.domestic
    var nation      : Int     = 1 // 国内/国外
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化视图
        setup()
        
        // 2, 网络请求
        tableView.mj_header.beginRefreshing()
    }
    
    func setup() {
        
        self.title = "更多机构"
        tableView.tableHeaderView = customSearchBar
        
        // 添加刷新控件
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HeadlineBaseController.refreshData))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(HeadlineBaseController.appendData))
        tableView.tableFooterView = UIView()
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        tableView.separatorStyle = .none
        
        // 注册单元格
        tableView.register(InternalOrganizationCell.self, forCellReuseIdentifier: InternalOrganizatioCellID)
        
        // 筛选
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "筛选", style: UIBarButtonItemStyle.done, target: self, action: #selector(MoreOrganizationViewController.toChooseClick))
        
        switch type {
        case .domestic:
            nation = 1
        case .overseas:
            nation = 2
        }
    }
    
    // 搜索框
    lazy var customSearchBar: CustomSearchBar = {
        
        let customSearchBar = CustomSearchBar.init(frame: CGRect(x: 0, y: APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: 40))
        customSearchBar.dk_backgroundColorPicker = headerView_backgroundColorPicker
        customSearchBar.searchBar.delegate = self
        customSearchBar.cancelBtn.addTarget(self, action: #selector(MoreOrganizationViewController.searchClick), for: .touchUpInside)
        return customSearchBar
    }()
    
    // 数据源
    lazy var dataSource: [[AgencyHeaderModel]] = {
        
        let dataSource = [[AgencyHeaderModel]]()
        return dataSource
    }()
    
    lazy var searchArr: [[AgencyHeaderModel]] = {
        
        let searchArr = [[AgencyHeaderModel]]()
        return searchArr
    }()
    
    lazy var shadowBtn: UIButton = {
        
        let shadowBtn = UIButton()
        shadowBtn.backgroundColor = RGBAColor(0, g: 0, b: 0, a: 0.3)
        shadowBtn.frame = UIScreen.main.bounds
        shadowBtn.tag = 1000
        shadowBtn.addTarget(self, action: #selector(MoreOrganizationViewController.removeView), for: UIControlEvents.touchUpInside)
        return shadowBtn
    }()
    
    lazy var chooseVC: ChooseViewController = {
        
        let chooseVC = ChooseViewController()
        chooseVC.delegate = self
    
        switch self.type {
        case .domestic:
            chooseVC.areaTagArr = ["全国", "北京", "天津", "河北", "内蒙古", "山西", "上海", "安徽", "江苏", "浙江", "山东", "河南", "福建", "江西", "广东", "广西", "吉林", "辽宁", "黑龙江", "重庆", "四川", "云南", "贵州", "西藏", "陕西", "甘肃", "宁夏", "青海", "新疆", "香港", "澳门", "台湾"]
            chooseVC.kindTagArr = ["画院", "博物馆", "美术馆", "艺术院校", "画廊", "美协"]
        case .overseas:
            chooseVC.areaTagArr = ["俄罗斯", "法国", "梵蒂冈", "加拿大", "美国", "意大利", "英国"]
            chooseVC.kindTagArr = ["画院", "博物馆", "美术馆", "艺术院校", "画廊", "美协"]
        }
        
        if dk_manager().themeVersion == "NORMAL" {
        
            chooseVC.view.backgroundColor = RGBAColor(255, g: 255, b: 255, a: 0.9)
        }else {
            chooseVC.view.backgroundColor = RGBAColor(61, g: 60, b: 60, a: 0.9)
        }
    
        chooseVC.searchBlock = {(dic) in
            
            self.removeView()
            // 开始搜索
            guard let dic = dic else {
            
                return
            }
            self.searchDic = dic as? [String : Any]
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            LLRequestServer.shareInstance().requestAgencyFilter(withUpdate_time:(dic["update_time"] as! Int), manager_time: (dic["manager_time"] as! Int), art_cate: dic["art_cate"] as! String!, zone: dic["zone"] as! String!, nation: self.nation, offset: 0, pagesize: 10, success: { (response, data) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                guard let data = data else { // 如果data为nil
                    
                    self.showTip(text: "无搜索结果")
                    PrintLog(message: "data 为 nil")
                    self.tableView.mj_footer.resetNoMoreData()
                    self.tableView.mj_header.endRefreshing()
                    return
                }
                
                if data is String {

                    self.showTip(text: "无搜索结果")
                    self.tableView.mj_footer.resetNoMoreData()
                    self.tableView.mj_header.endRefreshing()
                    return
                }
                
                self.isSearch = true

                let jsonData = data as! NSDictionary
                let arr: NSMutableArray = AgencyHeaderModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
                if (arr.count) > 0 {
                    self.searchArr.removeAll()
                    for i in 0..<arr.count {
                        let subArr: [AgencyHeaderModel] = arr[i] as! [AgencyHeaderModel]
                        self.searchArr.append(subArr)
                    }
                }
                self.searchoffset = jsonData["offset"] as? String
                
                self.tableView.reloadData()
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
            }, failure: { (response) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_header.endRefreshing()
                self.showTip(text: response?.msg)
            }) { (error) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_header.endRefreshing()
                self.showTip(text: "无搜索结果")
                PrintLog(message: error)
            }
        }
        return chooseVC
    }()
}

extension MoreOrganizationViewController: ChooseViewControllerDelegate{
    func toChooseClick() {
        
        if customSearchBar.searchBar.isFirstResponder {
        
            customSearchBar.searchBar.resignFirstResponder()
        }

        chooseVC.view.frame = CGRect(x: ScreenW, y: 0, width: choseViewH, height: ScreenH)
        shadowBtn.alpha = 1.0
        // 改变状态栏
        if dk_manager.themeVersion == "NORMAL" {
            
            UIApplication.shared.statusBarStyle = .default
        }
        
        let fontToBackWindows = UIApplication.shared.windows.reversed()
        for window in fontToBackWindows {
            guard window.windowLevel != UIWindowLevelNormal else {
                window.addSubview(shadowBtn)
                shadowBtn.addSubview(chooseVC.view)
                UIView.animate(withDuration: 0.25, animations: {
                    self.chooseVC.view.transform = CGAffineTransform(translationX: -self.choseViewH, y: 0)
                })
                return
            }
        }
    }
    
    //MARK: - ChooseViewControllerDelegate
    func dismiss() {
        
        self.removeView()
    }
    
    func removeView() {
        
        // 改变状态栏
        if dk_manager.themeVersion == "NORMAL" {
            
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.chooseVC.view.transform = .identity
        }) { finished in
            UIView.animate(withDuration: 0.25, animations: {
                self.shadowBtn.alpha = 0.0
                }, completion: { (finished: Bool) in
                    self.shadowBtn.removeFromSuperview()
                    self.chooseVC.reset()
            })
        }
    }
}

//MARK: - MJRefresh 网络请求
extension MoreOrganizationViewController {
    func refreshData() {
        LLRequestServer.shareInstance().requestMoreAgency(with: agency_id, offset: "0", pagesize: 5, success: { (response, data) in
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
                return
            }
            
            if data is String {
            
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
                return
            }
            
            let jsonData = data as! NSDictionary
            let arr: NSMutableArray = AgencyHeaderModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
            if (arr.count) > 0 {
                self.dataSource.removeAll()
                for i in 0..<arr.count {
                    let subArr: [AgencyHeaderModel] = arr[i] as! [AgencyHeaderModel]
                    self.dataSource.append(subArr)
                }
            }
            self.offset = jsonData["offset"] as? String
            
            self.tableView.reloadData()
            self.tableView.mj_footer.resetNoMoreData()
            self.tableView.mj_header.endRefreshing()
            }, failure: { (response) in
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
        }) { (error) in
            self.tableView.mj_footer.resetNoMoreData()
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func appendData() {
        if self.isSearch {
            
            LLRequestServer.shareInstance().requestAgencyFilter(withUpdate_time:(self.searchDic?["update_time"] as! Int), manager_time: (self.searchDic?["manager_time"] as! Int), art_cate: self.searchDic?["art_cate"] as! String!, zone: self.searchDic?["zone"] as! String!, nation: self.nation, offset: Int(self.searchoffset!)!, pagesize: 10, success: { (response, data) in

                guard let data = data else { // 如果data为nil

                    PrintLog(message: "data 为 nil")
                    self.tableView.mj_footer.resetNoMoreData()
                    self.tableView.mj_header.endRefreshing()
                    return
                }
                
                if data is String {
                    
                    self.tableView.mj_footer.resetNoMoreData()
                    self.tableView.mj_header.endRefreshing()
                    return
                }
                
                let jsonData = data as! NSDictionary
                let arr: NSMutableArray = AgencyHeaderModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
                if (arr.count) > 0 {
                    
                    for i in 0..<arr.count {
                        
                        let subArr: [AgencyHeaderModel] = arr[i] as! [AgencyHeaderModel]
                        self.searchArr.append(subArr)
                    }
                }
                self.searchoffset = jsonData["offset"] as? String
                
                self.tableView.reloadData()
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
            }, failure: { (response) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_header.endRefreshing()
            }) { (error) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_header.endRefreshing()

                PrintLog(message: error)
            }
        }else {
        
            LLRequestServer.shareInstance().requestMoreAgency(with: agency_id, offset: offset, pagesize: 5, success: { (response, data) in
                guard let data = data else { // 如果data为nil
                    
                    PrintLog(message: "data 为 nil")
                    self.tableView.mj_footer.resetNoMoreData()
                    self.tableView.mj_header.endRefreshing()
                    return
                }
                
                if data is String {
                
                    self.tableView.mj_footer.resetNoMoreData()
                    self.tableView.mj_header.endRefreshing()
                    return
                }
                
                let jsonData = data as! NSDictionary
                let arr: NSMutableArray = AgencyHeaderModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
                if (arr.count) > 0 {
                    for i in 0..<arr.count {
                        let subArr: [AgencyHeaderModel] = arr[i] as! [AgencyHeaderModel]
                        self.dataSource.append(subArr)
                    }
                }
                self.offset = jsonData["offset"] as? String
                
                self.tableView.reloadData()
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
            }, failure: { (response) in
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_header.endRefreshing()
            }) { (error) in
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_header.endRefreshing()
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension MoreOrganizationViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearch {
            
            return searchArr.count
        }
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InternalOrganizatioCellID, for: indexPath) as? InternalOrganizationCell
        
        if isSearch {
           
            cell?.organizationArr = self.searchArr[indexPath.section]
        }else {
        
            cell?.organizationArr = self.dataSource[indexPath.section]
        }
        
        cell?.selectedBlcok = {(model) -> Void in

            let detailVc = PaintDetailController()
            detailVc.webUrl = WebTimeStamp.webUrl(withTimeStamp: model.url)
            detailVc.titleType = WebTitleType(rawValue: UInt(1))!
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
        
        return cell!
    } 
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section != dataSource.count - 1 else {
            return 0
        }
        return 7
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerV = UIView()
        footerV.backgroundColor = UIColor.clear
        return footerV
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InternalOrganizationCell.rowHeight()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if customSearchBar.searchBar.isFirstResponder {
            
            customSearchBar.searchBar.resignFirstResponder()
        }
    }
}

//MARK: - UISearchBarDelegate
extension MoreOrganizationViewController: UISearchBarDelegate {
    //MARK: - 搜索点击
    func searchClick() {
        guard !(customSearchBar.searchBar.text?.isEmpty)! else {
            
            customSearchBar.searchBar.becomeFirstResponder()
            return
        }
        
        isSearch = true
        customSearchBar.searchBar.resignFirstResponder()
        
        // 开始搜索
        MBProgressHUD.showAdded(to: view, animated: true)
        LLRequestServer.shareInstance().requestAgencySearch(withKeyword: customSearchBar.searchBar.text, offset: "0", type: String(nation), pagesize: 10, success: { (response, data) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            guard let data = data else { // 如果data为nil
                
                PrintLog(message: "data 为 nil")
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
                return
            }
            
            if data is String {
                
                self.showTip(text: "无搜索结果")
                self.tableView.mj_footer.resetNoMoreData()
                self.tableView.mj_header.endRefreshing()
                return
            }
            
            let jsonData = data as! NSDictionary
            let arr: NSMutableArray = AgencyHeaderModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
            if (arr.count) > 0 {
                self.searchArr.removeAll()
                for i in 0..<arr.count {
                    let subArr: [AgencyHeaderModel] = arr[i] as! [AgencyHeaderModel]
                    self.searchArr.append(subArr)
                }
            }
            self.offset = jsonData["offset"] as? String
            
            self.tableView.reloadData()
            self.tableView.mj_footer.resetNoMoreData()
            self.tableView.mj_header.endRefreshing()
        }, failure: { (response) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
            self.tableView.mj_header.endRefreshing()
            self.showTip(text: response?.msg)
        }) { (error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.mj_footer.resetNoMoreData()
            self.tableView.mj_header.endRefreshing()
            
            self.showTip(text: "无搜索结果")
            PrintLog(message: error)
        }
    }
    
    func showTip(text: String?) {
        
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.label.text = text
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchClick()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (customSearchBar.searchBar.text?.isEmpty)! && isSearch {
        
            isSearch = false
            tableView.reloadData()
        }
    }
}

