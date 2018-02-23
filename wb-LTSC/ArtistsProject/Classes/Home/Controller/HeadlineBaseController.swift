//
//  HeadlineBaseController.swift
//  meishubao
//
//  Created by LWR on 2016/11/17.
//  Copyright © 2016年 benbun. All rights reserved.
//
//  首页头条等基础列表页

import UIKit
//import MJExtension

fileprivate let scrollViewH: CGFloat = ScreenW * 200 / 375.0 // 轮播图高度
fileprivate let homeSearchBarH: CGFloat = 44.0 // 搜索框高度

class HeadlineBaseController: UITableViewController {
    
    var offset: String?
    var term_id: String = "13"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1, 初始化
        self.setup()
        
        // 2, 网络请求
        tableView.mj_header.beginRefreshing()
    }
    
    //MARK: - 初始化
    private func setup() {
        
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: homeSearchBarH + scrollViewH))
        // 添加搜索框
        bottomView.addSubview(homeSearchBar)
        // 添加滚动视图
        bottomView.addSubview(cycleScrollView)
        // 设置头视图
        tableView.tableHeaderView = bottomView
        tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0)
        
        // 添加刷新控件
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HeadlineBaseController.refreshData))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(HeadlineBaseController.appendData))
        tableView.tableFooterView = UIView()
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        tableView.dk_separatorColorPicker = separatorColorPicker
        
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
    
    lazy var scrollImgArr: [SDCycleModel] = {
       let scrollImgArr = [SDCycleModel]()
       return scrollImgArr
    }()
    
    private lazy var homeSearchBar: HomeSearchBar = {
        
        let homeSearchBar = HomeSearchBar.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: homeSearchBarH))
        homeSearchBar.searchBar.delegate = self
        
        return homeSearchBar
    }()
    
    lazy var cycleScrollView: SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView.init(frame: CGRect(x: 0, y: 44, width: ScreenW, height: scrollViewH), delegate: self, placeholderImage: #imageLiteral(resourceName: "sd_scroll_bg"))
        cycleScrollView?.titleLabelBackgroundColor = RGBAColor(0,g:0,b: 0,a: 0.5)
        cycleScrollView?.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView?.bannerImageViewContentMode = .scaleAspectFill
        
        return cycleScrollView!
    }()
}

//MARK: - MJRefresh 网络请求
extension HeadlineBaseController {
    func refreshData() {
        // 国内头条是13 艺术设计8 艺术财富4 域外艺术9
        LLRequestServer.shareInstance().requestArticleBanner(withTermId: term_id, success: { (response, data) in
            PrintLog(message: "\(self.term_id)---")
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
extension HeadlineBaseController {
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
        }else {
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

//MARK: SDCycleScrollViewDelegate
extension HeadlineBaseController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let model = scrollImgArr[index]
        if model.type.integerValue == SDCycleImageTypeUrl {
            if !model.url.isEmpty {
                let webVc = MSBWebBaseController()
                webVc.webUrl = model.url;
                webVc.isWeb = true
            self.navigationController?.pushViewController(webVc, animated: true)
            }
        }else if model.type.integerValue == SDCycleImageTypeArticle{
            if !model.tid.isEmpty {
                let vc = MSBArticleDetailController()
                vc.tid = model.tid;
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
        }
    }
}

//MARK: - UITextFieldDelegate
extension HeadlineBaseController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let homeSearchVC = HomeSearchViewController()
        if NSInteger(term_id) == 104 {
            homeSearchVC.subjectTermID = term_id
        }
        navigationController?.pushViewController(homeSearchVC, animated: true)
        return false
    }
}
