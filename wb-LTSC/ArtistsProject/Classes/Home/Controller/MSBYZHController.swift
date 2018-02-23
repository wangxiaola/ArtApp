//
//  MSBYZHController.swift
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class MSBYZHController: UITableViewController {
    
    var offset: String?
    var term_id: String = "16"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1, 初始化
        self.setup()
        
        // 2, 网络请求
        tableView.mj_header.beginRefreshing()
    }
    
    //MARK: - 初始化
    private func setup() {
        // 添加刷新控件
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HeadlineBaseController.refreshData))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(HeadlineBaseController.appendData))
        tableView.tableFooterView = UIView()
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        // 注册单元格
        tableView.register(MSBYZHCell.self, forCellReuseIdentifier: MSBYZHCell.identifier())
    }
    
    // 懒加载
    lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
}
//http://qiniu.zgmsbw.com/meishubao/2017070610400082705.png?imageView2/0/q/75|watermark/1/image/aHR0cDovL3Fpbml1LnpnbXNidy5jb20vbWVpc2h1YmFvLzE0OTg1NTgyOTQxNjY2LnBuZw==/dissolve/50/gravity/SouthEast/dx/5/dy/5|imageslim
//MARK: 网络请求
extension MSBYZHController {
    func refreshData() {

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

            guard arr != nil else { // 如果arr为nil
                return
            }

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
        LLRequestServer.shareInstance().requestHomeArticle(withType: term_id, offset: offset, pagesize: 10, success: { (response, data) in
            guard let data = data else { // 如果data为nil
                
                PrintLog(message: "data 为 nil")
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_header.endRefreshing()
                return
            }
            
            if data is String {
                
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
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

extension MSBYZHController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MSBYZHCell.identifier(), for: indexPath) as? MSBYZHCell
        cell?.model = self.dataSource[indexPath.section]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleModel = self.dataSource[indexPath.section]
        let vc = MSBYZHDetailController();
        vc.wantsNavigationBarVisible = false;
        vc.videoUrl = articleModel.video;
        vc.videoId = articleModel.post_id;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section != dataSource.count - 1 else {
            return 0
        }
        return 13.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerV = UIView()
        footerV.backgroundColor = UIColor.clear
        return footerV
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MSBYZHCell.rowHeight()
    }
}

