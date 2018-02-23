//
//  CountryPaintViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/23.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import MJExtension

fileprivate let scrollViewH: CGFloat = ScreenW * 202 / 375.0  // 轮播图高度
fileprivate let searchViewH: CGFloat = 40  // 搜索框高度

class CountryPaintViewController: UITableViewController {

    var offset: String?
    var term_id: String = ""
    var agency_id: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // 1, 初始化
        setup()
        
        // 2, 网络请求
        tableView.mj_header.beginRefreshing()
    }
    
    //MARK: - 初始化
    private func setup() {
        
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: scrollViewH + CPHeaderItemViewHeight + searchViewH + 6))
        // 添加滚动视图
        bottomView.addSubview(cycleScrollView)
        bottomView.addSubview(headerItemView)
        bottomView.addSubview(homeSearchBar)
        // 设置头视图
        tableView.tableHeaderView = bottomView
        tableView.dk_backgroundColorPicker = tableView_backgroundColorPicker
        tableView.dk_separatorColorPicker  = separatorColorPicker
        tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0)
        
        // 添加刷新控件
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(appendData))
        tableView.tableFooterView = UIView()
        
        // 注册单元格
        tableView.register(HeadLineGeneralCell.self, forCellReuseIdentifier: generalCellID)
        tableView.register(HeadLineImageCell.self, forCellReuseIdentifier: imageCellID)
        tableView.register(HeadLineAdsCell.self, forCellReuseIdentifier: adCellID)
    }
    
    // 懒加载
    lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
    
    lazy var headerItem: CPHeaderItem = {
        let Item = CPHeaderItem()
        return Item
    }()
    
    lazy var scrollImgArr: [SDCycleModel] = {
        let scrollImgArr = [SDCycleModel]()
        return scrollImgArr
    }()
    
    lazy var cycleScrollView: SDCycleScrollView = {
        
        let cycleScrollView = SDCycleScrollView.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: scrollViewH), delegate: self, placeholderImage: #imageLiteral(resourceName: "sd_scroll_bg"))
        cycleScrollView?.titleLabelBackgroundColor = RGBAColor(0,g:0,b: 0,a: 0.5)
        cycleScrollView?.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView?.bannerImageViewContentMode = .scaleAspectFill
        return cycleScrollView!
    }()
    
    // 搜索框
    private lazy var homeSearchBar: HomeSearchBar = {
        let homeSearchBar = HomeSearchBar.init(frame: CGRect(x: 0, y: scrollViewH + CPHeaderItemViewHeight + 3, width: ScreenW, height: searchViewH))
        homeSearchBar.backgroundColor = UIColor.clear
        homeSearchBar.searchBar.delegate = self
        
        return homeSearchBar
    }()

    lazy var headerItemView:CPHeaderItemView = {
        let itemView = CPHeaderItemView.init(frame: CGRect(x:0,y:scrollViewH,width:ScreenW,height:CPHeaderItemViewHeight))
        itemView.currentVc = self
        return itemView
    }()
}

//MARK: - MJRefresh 网络请求
extension CountryPaintViewController {
    func refreshData() {
        // 国家画院banner
        LLRequestServer.shareInstance().requestArticleBanner(withTermId: term_id, success: { (response, data) in
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                return
            }
            
            
            let arr = SDCycleModel.mj_objectArray(withKeyValuesArray: data)
            
            guard arr != nil else { // 如果arr为nil
                return
            }

            
            if (arr?.count)! > 0 {
                self.scrollImgArr.removeAll()
                for model in arr! {
                    self.scrollImgArr.append(model as! SDCycleModel)
                }
            }
            
            var imgs = [String]()
            var titles = [String]()
            
            for model in self.scrollImgArr {
                imgs.append(model.post_image!)
                titles.append(model.post_title)
            }
            
            self.cycleScrollView.titlesGroup = titles
            self.cycleScrollView.imageURLStringsGroup = imgs
            }, failure: { (response) in
                
        }) { (error) in
        }

        LLRequestServer.shareInstance().requestOrgUrlSuccess({ (responce, data) in
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                return
            }
            let dataArr: NSArray = CPHeaderItem.mj_objectArray(withKeyValuesArray: data)
            self.headerItemView.datas = dataArr as? [CPHeaderItem]
        }, failure: { (responce) in
            
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

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CountryPaintViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleModel = self.dataSource[indexPath.row]
        let postType = NSString(string:articleModel.post_type)
        if postType.integerValue == HeadLineTypeImages{
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCellID, for: indexPath) as? HeadLineImageCell
            cell?.articleModel = articleModel
            return cell!
        }else if postType.integerValue == HeadLineTypeAds{
            let cell = tableView.dequeueReusableCell(withIdentifier: adCellID, for: indexPath) as? HeadLineAdsCell
            cell?.articleModel = articleModel
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: generalCellID, for: indexPath) as? HeadLineGeneralCell
            cell?.articleModel = articleModel
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleModel = self.dataSource[indexPath.row]
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
        }else{
            let vc = MSBArticleDetailController()
            vc.tid = articleModel.post_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let articleModel = self.dataSource[indexPath.row];
        return articleModel.rowHeight!
    }
}

//MARK: - UITextFieldDelegate
extension CountryPaintViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let homeSearchVC = HomeSearchViewController()
        navigationController?.pushViewController(homeSearchVC, animated: true)
        return false
    }
}

//MARK: SDCycleScrollViewDelegate
extension CountryPaintViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        PrintLog(message: "---点击了\(index)张图片")
        let model = scrollImgArr[index]
        if model.type.integerValue == SDCycleImageTypeUrl {
            if !model.url.isEmpty {
                let detailVc = PaintDetailController()
                
                detailVc.webUrl = WebTimeStamp.webUrl(withTimeStamp: model.url)
                //detailVc.isWeb = true
                
                self.navigationController?.pushViewController(detailVc, animated: true)
            }
        }else if model.type.integerValue == SDCycleImageTypeArticle {
            if !model.tid.isEmpty {
                let vc = MSBArticleDetailController()
                vc.tid = model.tid;
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
        }
    }
}
