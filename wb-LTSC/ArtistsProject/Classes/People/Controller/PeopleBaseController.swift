//
//  PeopleBaseController.swift
//  meishubao
//
//  Created by LWR on 2016/11/18.
//  Copyright © 2016年 benbun. All rights reserved.
//


import UIKit
//import SnapKit
//import MJExtension

class PeopleBaseController: UITableViewController {

    var offset       : String?
    var artist_level : String = ""
    var artist_uid   : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化视图
        setup()
        
        // 网络请求
        tableView.mj_header.beginRefreshing()
    }
    
    func setup() {
        tableView.tableHeaderView = headerView
        headerView.addSubview(peopleScrollView)
        headerView.addSubview(pageControll)
        headerView.addSubview(homeSearchBar)
        tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0)
        
        // 添加刷新控件
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HeadlineBaseController.refreshData))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(HeadlineBaseController.appendData))
        tableView.tableFooterView = UIView()
        tableView.dk_backgroundColorPicker = tableView_backgroundColorPicker
        tableView.dk_separatorColorPicker  = separatorColorPicker
        
        // 注册单元格
        tableView.register(HeadLineGeneralCell.self, forCellReuseIdentifier: generalCellID)
        tableView.register(HeadLineImageCell.self, forCellReuseIdentifier: imageCellID)
        tableView.register(HeadLineAdsCell.self, forCellReuseIdentifier: adCellID)
    }
    
    fileprivate lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 0))
        headerView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xE8E8E8, 0x1c1c1c)
        headerView.backgroundColor = UIColor.clear
        return headerView
    }()
    
    fileprivate lazy var peopleScrollView: UIScrollView = {
        let peopleScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 0))
        peopleScrollView.backgroundColor = UIColor.clear
        peopleScrollView.isPagingEnabled = true
        peopleScrollView.showsHorizontalScrollIndicator = false
        peopleScrollView.delegate = self
        return peopleScrollView
    }()
    
    fileprivate lazy var pageControll: UIPageControl = {
        let pageControll = UIPageControl()
        pageControll.backgroundColor = UIColor.clear
        pageControll.pageIndicatorTintColor = UIColor.lightGray
        pageControll.dk_currentPageIndicatorTintColorPicker = DKColorSwiftWithRGB(0xB51B20, 0x6f141a)
        return pageControll
    }()
    
    // 搜索框
     fileprivate lazy var homeSearchBar: HomeSearchBar = {
        let homeSearchBar = HomeSearchBar(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 44))
        homeSearchBar.backgroundColor = UIColor.clear
        homeSearchBar.searchBar.delegate = self
        homeSearchBar.isHidden = true
        
        return homeSearchBar
    }()
    
    // 数据源
    fileprivate lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
    
    fileprivate lazy var peopleCellArr: [PeopleModel] = {
        let peopleCellArr = [PeopleModel]()
        return peopleCellArr
    }()
    
    fileprivate lazy var peoplePageDataArr: [PeopleModel] = {
        let peoplePageDataArr = [PeopleModel]()
        return peoplePageDataArr
    }()
}

//MARK: - MJRefresh 网络请求
extension PeopleBaseController {
    func refreshData() {
        // 头视图八个人物
        
        let group = DispatchGroup()
        group.enter()
        
        LLRequestServer.shareInstance().requestPeopleArticle(withArtist_level: artist_uid,   is_all: 0, success: { (respone, data) in
            
                guard let data = data else { // 如果data为nil
                    PrintLog(message: "data 为 nil")
                    return
                }
            
                guard  let arr = PeopleModel.mj_objectArray(withKeyValuesArray: data) else { // 如果arr为nil
                    return
                }
            
                if (arr.count) > 0 {
                    self.peopleCellArr.removeAll()
                    
                    for model in arr {
                        self.peopleCellArr.append(model as! PeopleModel)
                    }
                }
            
                group.leave()
            }, failure: { (response) in
                
                group.leave()
            }) { (error) in
                
                group.leave()
            }
        
        group.enter()
        LLRequestServer.shareInstance().requestHomeArticle(withType: artist_level, offset: "0", pagesize: 10, success: { (response, data) in
            
            guard let data = data else { // 如果data为nil
                
                PrintLog(message: "data 为 nil")
                self.tableView.mj_footer.resetNoMoreData()
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
            
            group.leave()
            }, failure: { (response) in
                
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                self.tableView.mj_header.endRefreshing()
                group.leave()
        }) { (error) in
            
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
            self.tableView.mj_header.endRefreshing()
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { 
            
            self.reCalculateH()
            
            if self.peopleCellArr.count > 0 {
                 self.addPeopleHearderView()
            }
            
            if self.dataSource.count > 0 {
            
                self.tableView.reloadData()
            }
            
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func appendData() {
        LLRequestServer.shareInstance().requestHomeArticle(withType: artist_level, offset: self.offset, pagesize: 10, success: { (response, data) in
            
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
    
    func reCalculateH() {
        homeSearchBar.isHidden = false
        var peopleViewH: CGFloat = 0.0
        if self.peopleCellArr.count == 0 {
            peopleViewH = 0.0
            self.peopleScrollView.isHidden = true
            self.pageControll.isHidden = true
        }else if self.peopleCellArr.count < 4 {
            peopleViewH = 74.0
            self.peopleScrollView.isHidden = false
            self.pageControll.isHidden = false
        }else {
            peopleViewH = 148.0
            self.peopleScrollView.isHidden = false
            self.pageControll.isHidden = false
        }
        
        let pageCtrH: CGFloat = 28.0
        let searchH : CGFloat = 44.0
        self.peopleScrollView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: peopleViewH)
        self.pageControll.frame = CGRect(x:0, y:peopleViewH, width: ScreenW, height: pageCtrH)
        self.homeSearchBar.frame = CGRect(x: 0, y: peopleViewH + pageCtrH, width: ScreenW, height: searchH)
        self.headerView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: peopleViewH + pageCtrH + searchH)
        
        tableView.tableHeaderView = headerView
    }
    
    func addPeopleHearderView() {
        var pageNum: NSInteger = 0;

        pageNum = self.peopleCellArr.count/6
        if self.peopleCellArr.count%6 != 0 {
            pageNum = pageNum + 1
        }
        
        let pages: CGFloat = CGFloat(pageNum)
        self.peopleScrollView.contentSize = CGSize(width: ScreenW * pages, height:0)
        self.pageControll.numberOfPages = pageNum
        self.pageControll.currentPage = 0
        
        for i in 0..<pageNum {
            let currentPage: CGFloat = CGFloat(i)
            let peopleHeaderView: PeopleHeaderView = PeopleHeaderView()
            peopleHeaderView.frame = CGRect(x: ScreenW * currentPage, y: 0, width: ScreenW, height: self.peopleScrollView.height)
            peopleHeaderView.collection.delegate = self
            self.peopleScrollView.addSubview(peopleHeaderView)
            
            peopleHeaderView.peopleArr = getPeopleDataArray(page: i) as? [PeopleModel]
        }
        self.peoplePageDataArr = getPeopleDataArray(page: 0) as! [PeopleModel]
    }
    
    func getPeopleDataArray(page: NSInteger) -> NSArray {
        
        let dataArray: NSMutableArray = NSMutableArray()
        let num = page * 6
        for i in num..<num + 6 {
            
            if i + 1 > self.peopleCellArr.count {
                break
            }
            let data = self.peopleCellArr[i]
            dataArray.add(data)
        }
        return dataArray.copy() as! NSArray
    }
}

//MARK: - UITableViewDataSource
extension PeopleBaseController {
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
        
        guard !MSBAccount.getToken().isEmpty else { // 判断是否已登录
            return
        }
        
        // 保存阅读历史
        dbHelper.insert(toDB: articleModel)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let articleModel = self.dataSource[indexPath.row];
        return articleModel.rowHeight!
    }
    
}

extension PeopleBaseController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = peoplePageDataArr[indexPath.row]
        let personDetailVC = MSBPersonDetailController()
        personDetailVC.artistId = model.artist_id
        self.navigationController?.pushViewController(personDetailVC, animated: true)
        PrintLog(message: "点击了第几个人物---\(indexPath.row)")
    }
}

//MARK: - UITextFieldDelegate
extension PeopleBaseController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vsearchVC = PeopleSearchViewController()
        navigationController?.pushViewController(vsearchVC, animated: true)
        return false
    }
}

//MARK: - UITextFieldDelegate
extension PeopleBaseController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.peopleScrollView {
            let page: CGFloat = scrollView.mj_offsetX / ScreenW
            let currentPage: NSInteger = NSInteger(page)
            self.pageControll.currentPage = currentPage
            self.peoplePageDataArr = getPeopleDataArray(page: currentPage) as! [PeopleModel]
        }
    }
}
