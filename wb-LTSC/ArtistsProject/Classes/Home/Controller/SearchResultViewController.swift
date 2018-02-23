//
//  SearchResultViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController {

    var offset: String?
    var subjectTermID: String?

    var tableviewScroll: (() -> ())?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1, 初始化
        self.setup()
    }
    
    //MARK: - 初始化
    private func setup() {
        // 注册单元格
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: searchResultCellID)
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        tableView.dk_separatorColorPicker = separatorColorPicker
        // 添加头视图
        headerView.addSubview(resultCountLab)
        tableView.tableHeaderView = headerView
        headerView.layer.addSublayer(lineLayer)
        
        // 添加刷新控件
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(SearchResultViewController.searchMoreData))
        tableView.tableFooterView = UIView()
    }
    
    // headerView
    lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 36))
        headerView.dk_backgroundColorPicker = cell_backgroundColorPicker
        
        return headerView
    }()
    
    lazy var lineLayer: CAShapeLayer = {
        let lineLayer = CAShapeLayer()
        lineLayer.frame = CGRect(x: 23, y: 35, width: ScreenW - 44.5, height: 0.5)
        lineLayer.backgroundColor = UIColor.colorWithHex(0x989898).cgColor
        lineLayer.isHidden = true
        
        return lineLayer
    }()
    
    lazy var resultCountLab: UILabel = {
        let resultCountLab = UILabel(frame: CGRect(x: 23, y: 13, width: ScreenW - 44.5, height: 12))
        resultCountLab.font = UIFont.systemFont(ofSize: 12)
        resultCountLab.dk_textColorPicker = DKColorSwiftWithRGB(0xAAAAAA, 0x989898)
        
        return resultCountLab
    }()
    
    // 懒加载
    lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
    
    var searchText: String? {
        didSet {
            // 2, 开始加载
            searchNewData()
        }
    }
    
    deinit {
        
        if tableView.delegate != nil {
            
            tableView.delegate = nil
        }
        
        if tableView.dataSource != nil {
            
            tableView.dataSource = nil
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCellID, for: indexPath) as! SearchResultCell
        cell.articleModel = self.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleModel = self.dataSource[indexPath.row]
        let postType = NSString(string:articleModel.post_type)
        
        if postType.integerValue == HeadLineTypeAds {
            let adDetail = MSBWebBaseController()
            adDetail.webUrl = articleModel.ad_url
            self.navigationController?.pushViewController(adDetail, animated: true)
        }else{
            let vc = MSBArticleDetailController()
            vc.tid = articleModel.post_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchResultCell.rowHeight()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableviewScroll?()
    }
}

extension SearchResultViewController {
    func searchNewData() {
        self.webLoadView(self.view)
        
        LLRequestServer.shareInstance().requestHomeSearchArticle(withKeyword: searchText!, offset: "0", pagesize: 10, termId: subjectTermID, success: { (response, data) in
            self.lineLayer.isHidden = false
            self.endLoading()
            
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                return
            }

            if data is String {
            
                self.resultCountLab.text = "暂无搜索结果"
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
            if let total = jsonData["total"] {
                self.resultCountLab.text = "为您找到相关结果约\(total)个"
            }else {
                self.resultCountLab.text = "暂无搜索结果"
            }
            self.tableView.reloadData()
            }, failure: { (response) in
                self.lineLayer.isHidden = false
                self.endLoading()
                
                self.resultCountLab.text = "暂无搜索结果"
                if response?.code == 10006 {
                    self.tableView.reloadData()
                    self.tableView.mj_footer.resetNoMoreData()
                }
        }) { (error) in
            self.lineLayer.isHidden = false
            self.endLoading()
            
            self.resultCountLab.text = "暂无搜索结果"
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    func searchMoreData() {
        LLRequestServer.shareInstance().requestHomeSearchArticle(withKeyword: searchText!, offset: offset, pagesize: 10, termId: subjectTermID, success: { (response, data) in
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
