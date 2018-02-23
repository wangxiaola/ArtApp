//
//  EightAgencyViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/23.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import MJExtension

class EightAgencyViewController: UITableViewController {

    var offset: String?
    var term_id: String = ""
    var agency_id: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 初始化视图
        setup()
        
        // 2, 网络请求
        tableView.mj_header.beginRefreshing()
    }

    func setup() {
        headerView.addSubview(eightAgencyHeaderView)
        headerView.addSubview(homeSearchBar)

        tableView.tableHeaderView = headerView
        tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0)
        
        // 添加刷新控件
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HeadlineBaseController.refreshData))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(HeadlineBaseController.appendData))
        tableView.tableFooterView = UIView()
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        
        // 注册单元格
        tableView.register(HeadLineGeneralCell.self, forCellReuseIdentifier: generalCellID)
    }
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 163))
        headerView.dk_backgroundColorPicker = headerView_backgroundColorPicker
        
        return headerView
    }()
    
    // 人物头视图
    lazy var eightAgencyHeaderView: EightAhencyHeaderView = {
        let eightAgencyHeaderView = EightAhencyHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 122))
        eightAgencyHeaderView.collection.delegate = self
        
        return eightAgencyHeaderView
    }()

    // 搜索框
    private lazy var homeSearchBar: HomeSearchBar = {
        let homeSearchBar = HomeSearchBar.init(frame: CGRect(x: 0, y: 125, width: ScreenW, height: 38.0))
        homeSearchBar.backgroundColor = UIColor.clear
        homeSearchBar.searchBar.delegate = self
        
        return homeSearchBar
    }()
    
    // 数据源
    lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
    
    lazy var eightCellArr: [AgencyHeaderModel] = {
        let eightCellArr = [AgencyHeaderModel]()
        return eightCellArr
    }()
}

//MARK: - MJRefresh 网络请求
extension EightAgencyViewController {
    func refreshData() {
        LLRequestServer.shareInstance().requestEightAgencyHeader(withType: agency_id, success: { (response, data) in
            
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                return
            }
            
            let arr: NSMutableArray = AgencyHeaderModel.mj_objectArray(withKeyValuesArray: data)
            if arr.count > 0 {
                self.eightCellArr.removeAll()
                for model in arr {
                    self.eightCellArr.append(model as! AgencyHeaderModel)
                }
            }
            self.eightAgencyHeaderView.eightArr = self.eightCellArr
            
            }, failure: { (response) in
                
            }) { (error) in
        }
    
        LLRequestServer.shareInstance().requestHomeArticle(withType: term_id, offset: "0", pagesize: 10, success: { (response, data) in
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
            let arr = ArticleModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
            if (arr?.count)! > 0 {
                self.dataSource.removeAll()
            }
            for model in arr! {
                self.dataSource.append(model as! ArticleModel)
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
    
    func appendData() {
        LLRequestServer.shareInstance().requestHomeArticle(withType: term_id, offset: self.offset, pagesize: 10, success: { (response, data) in
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
            let arr = ArticleModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
            if (arr?.count)! > 0 {
                for model in arr! {
                    self.dataSource.append(model as! ArticleModel)
                }
            }
            self.offset = jsonData["offset"] as? String
            
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
            }, failure: { (response) in
                self.tableView.mj_footer.endRefreshing()
        }) { (error) in
            self.tableView.mj_footer.endRefreshing()
        }
    }
}

//MARK: - UITableViewDataSource
extension EightAgencyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: generalCellID, for: indexPath) as? HeadLineGeneralCell
        cell?.articleModel = self.dataSource[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeadLineGeneralCell.rowHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleModel = self.dataSource[indexPath.row]
        let vc = MSBArticleDetailController()
        vc.tid = articleModel.post_id;
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension EightAgencyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EightAgencyCell
        cell.agencyName.textColor = APP_TABBARITEM_SELET_COLOR
        PrintLog(message: "点击了第几个机构---\(indexPath.row)")
        let agencyModel = eightCellArr[indexPath.row];
        let vc = MSBAgencyDetailController();
        vc.orgId = agencyModel.org_id;
       self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension EightAgencyViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let homeSearchVC = HomeSearchViewController()
        navigationController?.pushViewController(homeSearchVC, animated: true)
        return false
    }
}
