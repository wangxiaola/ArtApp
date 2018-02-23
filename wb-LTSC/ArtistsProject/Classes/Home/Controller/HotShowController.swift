//
//  HotShowController.swift
//  meishubao
//
//  Created by 胡亚刚 on 2017/4/18.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit
private let reuseIdentifier = "HotShowCell"
private let adIdentifier = "HotShowAdCell"
class HotShowController: BaseController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HotShowLayoutDataSource {

    var collHeaderView: HotShowHeaderView?
    var offset: String?
    let itemWidth: CGFloat = (ScreenW - 4 * 15) / 3
    var animationTime: TimeInterval = 0.25
    var indexCount: Int = 0//记录次数
    
    // 懒加载
    lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
    
    lazy var scrollImgArr: [SDCycleModel] = {
        let scrollImgArr = [SDCycleModel]()
        return scrollImgArr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        view.addSubview(collectionView)
        
        //setUp()
        collectionView.mj_header.beginRefreshing()
    }

    lazy var collectionView: UICollectionView = {
        
        let layout = HotShowLayout()
        layout.dataSource = self
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView.init(frame: CGRect(x: 0,y: 0,width: ScreenW,height: ScreenH - APP_NAVIGATIONBAR_HEIGHT - APP_TABBAR_HEIGHT - 40), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        collectionView.register(HotestShowCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(HotShowAdCell.self, forCellWithReuseIdentifier: adIdentifier)
        collectionView.register(HotShowHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "hotHeader")
        
        // 添加刷新控件
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HotShowController.refreshData))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        collectionView.mj_header = header
        collectionView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(HotShowController.appendData))
        
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "hotHeader", for: indexPath) as! HotShowHeaderView
            collHeaderView = headerView
            collHeaderView?.vc = self
            
            headerView.frameChanged = {[weak self] () in
                collectionView.setContentOffset(CGPoint(x:0,y:headerView.height - 44), animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (self?.animationTime)!, execute: {
                    let nav = BaseNavigationController.init(rootViewController: HotShowSearchController())
                    
                    self?.present(nav, animated: false, completion: nil)
                })
            }
      
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        let model = dataSource[indexPath.row]
        if NSInteger(model.post_type) == HeadLineTypeAds {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adIdentifier, for: indexPath) as! HotShowAdCell
            cell.showModel = model
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HotestShowCell
            cell.showModel = model
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataSource[indexPath.row]
        if NSInteger(model.post_type) == HeadLineTypeAds {
            let typeModel = AdUrlTool.type(withAdUrl: model.ad_url)
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
                adDetail.webUrl = model.ad_url
                adDetail.isWeb = true
                self.navigationController?.pushViewController(adDetail, animated: true)
            }
        }else {
            let vc = MSBArticleDetailController()
            vc.tid = model.post_id
            vc.article = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionViewContentSize(layout: HotShowLayout) -> CGSize {
        var hotShowCellCount: Int = 0
        var adCellCount: Int = 0
        var adNoTitleCellCount: Int = 0//广告没标题的cell个数
        
        
        for (_,model) in dataSource.enumerated() {
            
            if NSInteger(model.post_type) == HeadLineTypeAds {
                adCellCount += 1
                if model.ad_content == "" {
                    adNoTitleCellCount += 1
                }
            }else {
                hotShowCellCount += 1
            }
        }
        
        let headerHeight = HotShowHeaderHeight
        
        let hotShowCellHeightT: CGFloat = CGFloat(ceilf((Float(Float(hotShowCellCount) / 3)))) * HotShowCellHeight
        let adCellHeightT: CGFloat = CGFloat(adCellCount) * AdCellHeight - (20 + topPadding) * CGFloat(adNoTitleCellCount)
        let paddingHeightT: CGFloat = CGFloat(ceilf((Float(Float(hotShowCellCount) / 3))) + Float(adCellCount)) * layout.minimumLineSpacing
        
        
        let size = CGSize(width: view.bounds.width, height: hotShowCellHeightT + adCellHeightT + paddingHeightT + headerHeight)
        
        return size
    }
    
    func cellLayoutEachFrameForItemAtIndexPath(layout: HotShowLayout, indexPath: IndexPath) -> CGRect {
        var hotShowCellCount: Int = 0
        var adCellCount: Int = 0
        var adNoTitleCellCount: Int = 0
        var cellType: Int?
        
        
        for (index, model) in dataSource.enumerated() {
            let type = NSInteger(model.post_type)
            if indexPath.item == index {
                cellType = type
                break
            }else if type == HeadLineTypeAds {
                adCellCount += 1
                if model.ad_content == "" {
                    adNoTitleCellCount += 1
                }
            }else {
                hotShowCellCount += 1
            }
        }
        
        
        var x: CGFloat = layout.minimumInteritemSpacing
        var y: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        let hotShowCellHeightT: CGFloat = CGFloat((hotShowCellCount / 3)) * HotShowCellHeight
        let adCellHeightT: CGFloat = CGFloat(adCellCount) * AdCellHeight - (20 + topPadding) * CGFloat(adNoTitleCellCount)
        let paddingHeightT: CGFloat = CGFloat((hotShowCellCount / 3) + adCellCount) * layout.minimumLineSpacing
        
        y = HotShowHeaderHeight + layout.minimumLineSpacing
        
        if cellType == HeadLineTypeAds {
            let model = dataSource[indexPath.row]
            x = 0
            width = AdCellWidth
            if model.ad_content == "" {
                height = AdCellHeight - (20 + topPadding)
            }else{
                height = AdCellHeight
            }
            
            y += (hotShowCellHeightT + adCellHeightT + paddingHeightT)
        }else  {
            width = HotShowCellWidth
            height = HotShowCellHeight
            
            if !(isCellOnLeftByTreasure(treasure: hotShowCellCount, oneCount: adCellCount)) {
                x = (width + layout.minimumInteritemSpacing) * CGFloat(indexCount) + layout.minimumInteritemSpacing;
            }
            y += (hotShowCellHeightT + adCellHeightT + paddingHeightT)
            
        }
        return CGRect(x: x,y: y,width: width,height: height)
    }
    
    func isCellOnLeftByTreasure(treasure: Int,oneCount: Int) -> Bool {
        if (treasure + oneCount * 3) % 3 == 0 {
            indexCount = 0
            return true;
        } else {
            indexCount += 1
            return false;
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.mj_offsetY
        if collHeaderView != nil {
            if offsetY < (collHeaderView?.height)! {
                animationTime = TimeInterval(0.25 * (((collHeaderView?.height)! - offsetY) / (collHeaderView?.height)!))
            }else{
                animationTime = 0.25
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - MJRefresh 网络请求
extension HotShowController {
    func refreshData() {
        // 国内头条是13 艺术设计8 艺术财富4 域外艺术9
        LLRequestServer.shareInstance().requestArticleBanner(withTermId: "14", success: { (response, data) in
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
            self.collHeaderView?.cycleScrollView.titlesGroup = titles
            self.collHeaderView?.cycleScrollView.imageURLStringsGroup = imgs
            self.collHeaderView?.images = self.scrollImgArr;
        }, failure: { (response) in
            
        }) { (error) in
        }
        
        LLRequestServer.shareInstance().requestHotestShow(withOffset: "0", pagesize: 30, startTime: nil, endTime: nil, success: { (response, data) in
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                self.collectionView.mj_footer.resetNoMoreData()
                self.collectionView.mj_header.endRefreshing()
                return
            }
            
            if data is String {
                
                self.collectionView.mj_footer.resetNoMoreData()
                self.collectionView.mj_header.endRefreshing()
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
            
            self.collectionView.reloadData()
            self.collectionView.mj_footer.resetNoMoreData()
            self.collectionView.mj_header.endRefreshing()
        }, failure: { (response) in
            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            self.collectionView.mj_header.endRefreshing()
        }) { (error) in
            self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            self.collectionView.mj_header.endRefreshing()
        }
    }
    
    func appendData() {
        
        LLRequestServer.shareInstance().requestHotestShow(withOffset: self.offset, pagesize: 30, startTime: nil, endTime: nil, success: { (response, data) in
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                self.collectionView.mj_footer.resetNoMoreData()
                self.collectionView.mj_header.endRefreshing()
                return
            }
            
            if data is String {
                
                self.collectionView.mj_footer.resetNoMoreData()
                self.collectionView.mj_header.endRefreshing()
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
            
            self.collectionView.reloadData()
            self.collectionView.mj_footer.endRefreshing()
        }, failure: { (response) in
            self.collectionView.mj_footer.endRefreshing()
        }) { (error) in
            self.collectionView.mj_footer.endRefreshing()
        }
    }
}
