//
//  SearchHistoryViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class SearchHistoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableviewScroll: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1, 初始化
        self.setup()
        
        // 2, 加载搜索历史
        loadSearchHistory()
    }
    
    //MARK: - 初始化
    private func setup() {
        tableView.register(PeopleSearchHistoryCell.self, forCellReuseIdentifier: peopleSearchCellID)
        tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        tableView.dk_separatorColorPicker = separatorColorPicker
        
        tableView.tableFooterView = UIView()
    }
    
    lazy var dataSource: [PeopleSearchModel] = {
        let dataSource = [PeopleSearchModel]()
        
        return dataSource
    }()
    
    deinit {
        
        if tableView.delegate != nil {
            
            tableView.delegate = nil
        }
        
        if tableView.dataSource != nil {
            
            tableView.dataSource = nil
        }
    }
}

//MARK: - 加载搜索历史
extension SearchHistoryViewController {
    func loadSearchHistory() {
        dbHelper.search(PeopleSearchModel.self, where: nil, orderBy: nil, offset: 0, count: 0) { (resultArr) in
            guard let resultArr = resultArr else {
                return
            }
            
            guard resultArr.count > 0 else {
                return
            }
            
            // 清除老的数据
//            if resultArr.count > 10 {
//                for i in 0...(resultArr.count - 10) {
//                    let model = resultArr[i] as! PeopleSearchModel
//                    dbHelper.delete(with: PeopleSearchModel.self, where: ["searchText" : model.searchText])
//                }
//            }
            
            self.dataSource.removeAll()
            for model in resultArr.reversed() {
                self.dataSource.append(model as! PeopleSearchModel)
            }
            
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count > 10 ? 10 : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: peopleSearchCellID, for: indexPath) as! PeopleSearchHistoryCell
        let model = self.dataSource[indexPath.row]
        cell.searchText = model.searchText
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PeopleSearchHistoryCell.rowHeight()
    }
    
    //MARK: 点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PrintLog(message: indexPath.row)
        let model = self.dataSource[indexPath.row]
        
        tableviewScroll?(model.searchText)
    }
    
    //MARK: 允许编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        dataSource.remove(at: indexPath.row)
        dbHelper.delete(with: PeopleSearchModel.self, where: ["searchText" : model.searchText])
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableviewScroll?("")
    }
}

