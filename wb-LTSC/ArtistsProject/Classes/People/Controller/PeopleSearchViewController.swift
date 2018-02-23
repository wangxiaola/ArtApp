//
//  PeopleSearchViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class PeopleSearchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1, 初始化
        self.setup()
    }
    
    //MARK: - 初始化
    private func setup() {
        // 设置标题图片
        let logoView = UIImageView(image: #imageLiteral(resourceName: "meishubao_logo"))
        navigationItem.titleView = logoView
        
        automaticallyAdjustsScrollViewInsets = false
        
        // 添加子视图控制器
        addChildViewController(searchHistoryVC)
        view.insertSubview(searchHistoryVC.view, at: 1)
        
        addChildViewController(searchResultVC)
        view.insertSubview(searchResultVC.view, at: 0)
        
        // 添加搜索框
        view.addSubview(customSearchBar)
    }
    
    lazy var customSearchBar: CustomSearchBar = {
        let customSearchBar = CustomSearchBar.init(frame: CGRect(x: 0, y: APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: 44))
        customSearchBar.searchBar.placeholder = "搜索艺术家名称"
        customSearchBar.searchBar.delegate = self
        customSearchBar.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xdcdcdc, 0x222222)
        customSearchBar.cancelBtn.addTarget(self, action: #selector(PeopleSearchViewController.searchClick), for: .touchUpInside)
        
        return customSearchBar
    }()
    
    lazy var searchHistoryVC: SearchHistoryViewController = {
        let searchHistoryVC = SearchHistoryViewController()
        
        let vcTop = APP_NAVIGATIONBAR_HEIGHT + CGFloat(44)
        searchHistoryVC.view.frame = CGRect(x: 0, y: vcTop, width: ScreenW, height: ScreenH - vcTop)
        
        searchHistoryVC.tableviewScroll = {(searchText: String) in
            guard !self.customSearchBar.searchBar.isFirstResponder else {
                self.customSearchBar.searchBar.resignFirstResponder()
                return
            }
            
            guard searchText != "" else {
                return
            }
            self.searchResultVC.searchText = searchText
            self.searchHistoryVC.view.removeFromSuperview()
            self.view.bringSubview(toFront: self.searchResultVC.view)
        }
        
        return searchHistoryVC
    }()
    
    lazy var searchResultVC: PeopleSearchResultVC = {
        let searchResultVC = PeopleSearchResultVC()
        let vcTop = APP_NAVIGATIONBAR_HEIGHT + CGFloat(44)
        searchResultVC.view.frame = CGRect(x: 0, y: vcTop, width: ScreenW, height: ScreenH - vcTop)
        searchResultVC.tableviewScroll = {() in
            guard !self.customSearchBar.searchBar.isFirstResponder else {
                self.customSearchBar.searchBar.resignFirstResponder()
                return
            }
        }
        
        return searchResultVC
    }()
    
    deinit {
        
        if (customSearchBar.searchBar.delegate != nil) {
            
            customSearchBar.searchBar.delegate = nil
        }
        
        if searchHistoryVC.view != nil {
            
            searchHistoryVC.view.removeFromSuperview()
            searchHistoryVC.removeFromParentViewController()
        }
        
        if searchResultVC.view != nil {
            
            searchResultVC.view.removeFromSuperview()
            searchResultVC.removeFromParentViewController()
        }
    }
}

//MARK: - UISearchBarDelegate
extension PeopleSearchViewController: UISearchBarDelegate {
    //MARK: - 搜索点击
    func searchClick() {
        guard !(customSearchBar.searchBar.text?.isEmpty)! else {
            customSearchBar.searchBar.becomeFirstResponder()
            return
        }
        
        searchHistoryVC.loadSearchHistory()
        
        customSearchBar.searchBar.resignFirstResponder()
        searchResultVC.searchText = customSearchBar.searchBar.text
//        if let historyView = searchHistoryVC.view {
//            historyView.removeFromSuperview()
        view.bringSubview(toFront: searchResultVC.view)
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchClick()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text?.isEmpty)! {
            
            searchHistoryVC.loadSearchHistory()
            view.bringSubview(toFront: searchHistoryVC.view)
        }
    }
}
