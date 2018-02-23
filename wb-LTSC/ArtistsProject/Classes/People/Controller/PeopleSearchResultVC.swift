//
//  PeopleSearchResultVC.swift
//  meishubao
//
//  Created by LWR on 2016/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class PeopleSearchResultVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var offset: String?
    var tableviewScroll: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1, 初始化
        self.setup()
    }
    
    //MARK: - 初始化
    private func setup() {
        // 注册单元格
        tableView.register(PeopleSearchResutCell.self, forCellReuseIdentifier: peopleSearchResultCellID)
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        tableView.dk_separatorColorPicker = separatorColorPicker
        
        // 添加刷新控件
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(PeopleSearchResultVC.searchMoreData))
        tableView.tableFooterView = UIView()
    }
    
    lazy var dataSource: [PeopleModel] = {
        let dataSource = [PeopleModel]()
        
        return dataSource
    }()
    
    var searchText: String? {
        didSet {
            let model = PeopleSearchModel()
            model.searchText = searchText!
            
            // 保存搜索历史
            dbHelper.insert(toDB: model)
            
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
extension PeopleSearchResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: peopleSearchResultCellID, for: indexPath) as! PeopleSearchResutCell
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PeopleSearchResutCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PrintLog(message: indexPath.row)
         let model = dataSource[indexPath.row]
        let personDetailVC = MSBPersonDetailController()
        personDetailVC.artistId = model.artist_id
        self.navigationController?.pushViewController(personDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableviewScroll?()
    }
}

extension PeopleSearchResultVC {
    func searchNewData() {
        self.webLoadView(self.view)
        
        LLRequestServer.shareInstance().requestPeopleSearch(withKeyword: searchText, offset: "0", pagesize: 10, success: { (response, data) in
            self.endLoading()
            
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                return
            }
            
            if data is String {
                
                self.hudTip("暂无搜索结果")
                return
            }
            
            let jsonData = data as! NSDictionary
            let arr = PeopleModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
            if (arr?.count)! > 0 {
                self.dataSource.removeAll()
            }
            for model in arr! {
                self.dataSource.append(model as! PeopleModel)
            }
            
            self.offset = jsonData["offset"] as? String
            
            self.tableView.reloadData()
            }, failure: { (response) in
                self.endLoading()
                self.hudTip(response?.msg)
                self.tableView.mj_footer.resetNoMoreData()
            }) { (error) in
                self.endLoading()
                self.hudTip("搜索失败")
                self.tableView.mj_footer.resetNoMoreData()
            }
        }
    
    func searchMoreData() {
        LLRequestServer.shareInstance().requestPeopleSearch(withKeyword: searchText, offset: offset, pagesize: 10, success: { (response, data) in
            guard let data = data else { // 如果data为nil
                PrintLog(message: "data 为 nil")
                return
            }
            let jsonData = data as! NSDictionary
            let arr = PeopleModel.mj_objectArray(withKeyValuesArray: jsonData["items"])
            if (arr?.count)! > 0 {
                for model in arr! {
                    self.dataSource.append(model as! PeopleModel)
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
