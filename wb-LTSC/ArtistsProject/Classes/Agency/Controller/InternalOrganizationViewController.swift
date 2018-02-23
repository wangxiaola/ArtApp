//
//  InternalOrganizationViewController.swift
//  meishubao
//
//  Created by LWR on 2016/12/13.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

fileprivate let scrollViewH: CGFloat = ScreenW * 202 / 375.0  // 轮播图高度
fileprivate let searchViewH: CGFloat = 40  // 搜索框高度

enum OrganizationType {
    case domestic // 国内
    case overseas // 国外
}

class InternalOrganizationViewController: UITableViewController {

    var offset    : String?
    var term_id   : String = ""
    //var agency_id : String = ""
    var type = OrganizationType.domestic
     
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // 初始化视图
        setup()
        
        // 2, 网络请求
        tableView.mj_header.beginRefreshing()
    }
    
    func setup() {
        headerView.addSubview(cycleScrollView)
        //headerView.addSubview(eightAgencyHeaderView)
        headerView.addSubview(homeSearchBar)
        
        tableView.tableHeaderView = headerView
        tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0)
        
        // 添加刷新控件
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(appendData))
        tableView.tableFooterView = UIView()
        tableView.dk_backgroundColorPicker = tableView_backgroundColorPicker
        tableView.dk_separatorColorPicker  = separatorColorPicker
        
        // 注册单元格
        tableView.register(HeadLineGeneralCell.self, forCellReuseIdentifier: generalCellID)
        tableView.register(HeadLineImageCell.self, forCellReuseIdentifier: imageCellID)
        tableView.register(HeadLineAdsCell.self, forCellReuseIdentifier: adCellID)
    }
    
    fileprivate lazy var headerView: UIView = {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: scrollViewH + searchViewH + 6))
        headerView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xE8E8E8, 0x1c1c1c)
        return headerView
    }()
    
    fileprivate lazy var cycleScrollView: SDCycleScrollView = {
        
        let cycleScrollView = SDCycleScrollView.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: scrollViewH), delegate: self, placeholderImage: #imageLiteral(resourceName: "sd_scroll_bg"))
        cycleScrollView?.titleLabelBackgroundColor = RGBAColor(0,g:0,b: 0,a: 0.5)
        cycleScrollView?.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView?.bannerImageViewContentMode = .scaleAspectFill
        return cycleScrollView!
    }()

    /*
    // 人物头视图
    fileprivate lazy var eightAgencyHeaderView: EightAhencyHeaderView = {
        
        let eightAgencyHeaderView = EightAhencyHeaderView(frame: CGRect(x: 0, y: scrollViewH, width: ScreenW, height: 0))
        eightAgencyHeaderView.collection.delegate = self
        return eightAgencyHeaderView
    }()*/

    // 搜索框
    fileprivate lazy var homeSearchBar: HomeSearchBar = {
        
        let homeSearchBar = HomeSearchBar.init(frame: CGRect(x: 0, y: scrollViewH + 3 , width: ScreenW, height: searchViewH))
        homeSearchBar.backgroundColor = UIColor.clear
        homeSearchBar.searchBar.delegate = self
        return homeSearchBar
    }()
    
    // 数据源
    lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
    
    lazy var scrollImgArr: [SDCycleModel] = {
        let scrollImgArr = [SDCycleModel]()
        return scrollImgArr
    }()

    /*
    lazy var eightCellArr: [AgencyHeaderModel] = {
        let eightCellArr = [AgencyHeaderModel]()
        return eightCellArr
    }()*/
}

//MARK: - MJRefresh 网络请求
extension InternalOrganizationViewController {
    func refreshData() {
        // 国内艺术机构banner
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

        /*
        LLRequestServer.shareInstance().requestEightAgencyHeader(withType: agency_id, success: { (response, data) in
            
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                return
                
            }
        
            guard  let arr = AgencyHeaderModel.mj_objectArray(withKeyValuesArray: data) else { // 如果arr为nil
                return
            }
            
            if arr.count > 0 {
                self.eightCellArr.removeAll()
                for i in 0..<arr.count {
                    let model = arr[i]
                    self.eightCellArr.append(model as! AgencyHeaderModel)
                }
            }
            self.reCalculateH()
            self.eightAgencyHeaderView.eightArr = self.eightCellArr
            }, failure: { (response) in
                
                PrintLog(message: response?.msg)
        }) { (error) in
            
            PrintLog(message: error)
        }*/

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
/*
    func reCalculateH() {
        
        var peopleViewH: CGFloat = 0.0
        
        if self.eightCellArr.count == 0 {
            
            peopleViewH = 0.0
        }else if self.eightCellArr.count < 4 {
            
            peopleViewH = 60.0
        }else if self.eightCellArr.count < 7{
            
            peopleViewH = 120.0
        }else {
        
            peopleViewH = 180.0
        }
        
        self.eightAgencyHeaderView.frame = CGRect(x: 0, y: scrollViewH, width: ScreenW, height: peopleViewH)
        self.homeSearchBar.frame = CGRect(x: 0, y: scrollViewH + peopleViewH, width: ScreenW, height: 38.0)
        self.headerView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: scrollViewH + peopleViewH + searchViewH)

        tableView.tableHeaderView = headerView
    }
*/
    
    func appendData() {
        LLRequestServer.shareInstance().requestHomeArticle(withType: term_id, offset: self.offset, pagesize: 10, success: { (response, data) in
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
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
extension InternalOrganizationViewController {
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let articleModel = self.dataSource[indexPath.row];
        return articleModel.rowHeight!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleModel = self.dataSource[indexPath.row]
        let postType = NSString(string:articleModel.post_type)
        
        if postType.integerValue == HeadLineTypeAds {
            let adDetail = MSBWebBaseController()
            adDetail.webUrl = articleModel.ad_url
            adDetail.isWeb = true
            self.navigationController?.pushViewController(adDetail, animated: true)
        }else{
            let vc = MSBArticleDetailController()
            vc.tid = articleModel.post_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
/*
extension InternalOrganizationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        PrintLog(message: "点击了第几个机构---\(indexPath.row)")
        let agencyModel    = eightCellArr[indexPath.row];
        let detailVc       = PaintDetailController()
        detailVc.webUrl    = WebTimeStamp.webUrl(withTimeStamp: agencyModel.url)
        detailVc.titleType = WebTitleType(rawValue: UInt(1))!
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}
*/
//MARK: - UITextFieldDelegate
extension InternalOrganizationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let homeSearchVC = HomeSearchViewController()
        navigationController?.pushViewController(homeSearchVC, animated: true)
        return false
    }
}

//MARK: SDCycleScrollViewDelegate
extension InternalOrganizationViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        PrintLog(message: "---点击了\(index)张图片")
        let model = scrollImgArr[index]
        if model.type.integerValue == SDCycleImageTypeUrl {
            if !model.url.isEmpty {
                let webVc = MSBWebBaseController()
                webVc.webUrl = model.url;
                webVc.isWeb = true
            self.navigationController?.pushViewController(webVc, animated: true)
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
