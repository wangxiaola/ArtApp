//
//  MoreReadHistoryVC.swift
//  meishubao
//
//  Created by LWR on 2016/12/20.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class MoreReadHistoryVC: BaseViewController {

    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1, 初始化
        self.setup()
        
        // 2, 加载数据
        loadNewData()
    }
    
    //MARK: - 初始化
    private func setup() {
        view.addSubview(tableView)
        
        title = "阅读历史"
    }
    
    // 懒加载
    lazy var dataSource: [ArticleModel] = {
        let dataSource = [ArticleModel]()
        return dataSource
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH), style: .plain)
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        tableView.dk_separatorColorPicker = separatorColorPicker
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 添加加载更多控件
        tableView.mj_footer = MJDIYBackFooter(refreshingTarget:self, refreshingAction:#selector(MoreReadHistoryVC.loadMoreData))
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MoreReadHistoryVC: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "MoreReadHistoryVC"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.dk_backgroundColorPicker = cell_backgroundColorPicker
        cell?.selectionStyle = .none
        
        let model = dataSource[indexPath.row]
        cell?.textLabel?.text = model.post_title
        cell?.textLabel?.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell!
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PrintLog(message: indexPath.row)
    }
}

//MARK- 加载数据
extension MoreReadHistoryVC {
    func loadNewData() {
        dbHelper.search(ArticleModel.self, where: nil, orderBy: nil, offset: 0, count: 15) { (resultArr) in
            guard let resultArr = resultArr else {
                return
            }
            
            guard resultArr.count > 0 else {
                return
            }
            
            self.dataSource.removeAll()

            for model in resultArr.reversed() {
                self.dataSource.append(model as! ArticleModel)
            }
            
            self.offset += resultArr.count
            
            self.tableView.reloadData()
        }
    }
    
    func loadMoreData() {
        dbHelper.search(ArticleModel.self, where: nil, orderBy: nil, offset: offset, count: 10) { (resultArr) in
            
            guard let resultArr = resultArr else {
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            guard resultArr.count > 0 else {
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            self.offset += resultArr.count
            
            for model in resultArr.reversed() {
                self.dataSource.append(model as! ArticleModel)
            }
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
        }
    }
}
