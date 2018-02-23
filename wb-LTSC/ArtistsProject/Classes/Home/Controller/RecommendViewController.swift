//
//  RecommendViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//  
//  首页推荐列表页

import UIKit

class RecommendViewController: UITableViewController {

    var offset: String?
    var term_id: String = "0"
    
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
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
         tableView.mj_header = header
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(HeadlineBaseController.appendData))
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        // 注册单元格
        tableView.register(RecommendCell.self, forCellReuseIdentifier: recommendCellID)
        tableView.register(HeadLineImageCell.self, forCellReuseIdentifier: imageCellID)
        tableView.register(HeadLineAdsCell.self, forCellReuseIdentifier: adCellID)
        tableView.register(MSBYZHCell.self, forCellReuseIdentifier: MSBYZHCell.identifier())
    }
    
    // 懒加载
    lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
}

//MARK: - MJRefresh 网络请求
extension RecommendViewController {
    func refreshData() {
        LLRequestServer.shareInstance().requestHomeArticle(withType: term_id, offset: "0", pagesize: 10, success: { (response, data) in
            
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

//MARK: - UITableViewDelegate, UITableViewDataSource
extension RecommendViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleModel = self.dataSource[indexPath.section]
        let postType = NSString(string:articleModel.post_type)

        if postType.integerValue == HeadLineTypeAds{
            let cell = tableView.dequeueReusableCell(withIdentifier: adCellID, for: indexPath) as? HeadLineAdsCell
            cell?.articleModel = articleModel
            return cell!
        }else if postType.integerValue == HeadLineTypeVideo{
            let cell = tableView.dequeueReusableCell(withIdentifier: MSBYZHCell.identifier(), for: indexPath) as? MSBYZHCell
            cell?.isRecommend = true
            cell?.model = articleModel
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: recommendCellID, for: indexPath) as? RecommendCell
            cell?.articleModel = articleModel
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleModel = self.dataSource[indexPath.section]
        let postType = NSString(string:articleModel.post_type)
        if postType.integerValue == HeadLineTypeAds {
            let typeModel = AdUrlTool.type(withAdUrl: articleModel.ad_url)
            guard let adOpenModel = typeModel else {
                return
            }
            if typeModel?.openType == AdOpenType.artist {
                let personDetailVC = MSBPersonDetailController()
                personDetailVC.artistId = adOpenModel.contentId
                self.navigationController?.pushViewController(personDetailVC, animated: true)
            }else if typeModel?.openType == AdOpenType.article {
                let  articleDetailVC = MSBArticleDetailController();
                articleDetailVC.tid = adOpenModel.contentId
                self.navigationController?.pushViewController(articleDetailVC, animated: true)
            }else {
                let adDetail = MSBWebBaseController()
                adDetail.webUrl = articleModel.ad_url
                adDetail.isWeb = true
                self.navigationController?.pushViewController(adDetail, animated: true)
            }
        }else if postType.integerValue == HeadLineTypeVideo {
            let vc = MSBYZHDetailController();
            vc.wantsNavigationBarVisible = false;
            vc.videoUrl = articleModel.video;
            vc.videoId = articleModel.post_id;
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = MSBArticleDetailController()
            vc.tid = articleModel.post_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        let articleModel = self.dataSource[indexPath.section]
        let postType = NSString(string:articleModel.post_type)
        if postType.integerValue == HeadLineTypeGenneral {
            return RecommendCell.rowHeight()
        }else if postType.integerValue == HeadLineTypeVideo {
            return MSBYZHCell.rowHeight()
        }else{
            return articleModel.rowHeight!
        }
    }
}

