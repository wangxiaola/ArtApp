//
//  HomeSearchViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class HomeSearchViewController: BaseViewController {

    var subjectTermID: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
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
        
        // 添加子控制器
        addChildViewController(historyVC)
        view.insertSubview(historyVC.view, at: 1)
        
        addChildViewController(searchResultVC)
        view.insertSubview(searchResultVC.view, at: 0)
        
        // 添加搜索框
        view.addSubview(customSearchBar)
        
    }
    
    lazy var customSearchBar: CustomSearchBar = {
        let customSearchBar = CustomSearchBar.init(frame: CGRect(x: 0, y: APP_NAVIGATIONBAR_HEIGHT, width: ScreenW, height: 44))
        customSearchBar.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xdcdcdc, 0x222222)
        customSearchBar.searchBar.delegate = self
        customSearchBar.cancelBtn.addTarget(self, action: #selector(HomeSearchViewController.searchClick), for: .touchUpInside)
        //customSearchBar.searchBar.
        
        return customSearchBar
    }()
    
    lazy var historyVC: HistoryViewController = {
        let historyVC = HistoryViewController()
        let vcTop = APP_NAVIGATIONBAR_HEIGHT + CGFloat(44)
        historyVC.view.frame = CGRect(x: 0, y: vcTop, width: ScreenW, height: ScreenH - vcTop)
        historyVC.bgTap = {() in
            guard !self.customSearchBar.searchBar.isFirstResponder else {
                self.customSearchBar.searchBar.resignFirstResponder()
                return
            }
        }
        
        return historyVC
    }()
    
    lazy var searchResultVC: SearchResultViewController = {
        let searchResultVC = SearchResultViewController()
        let vcTop = APP_NAVIGATIONBAR_HEIGHT + CGFloat(44)
        searchResultVC.view.frame = CGRect(x: 0, y: vcTop, width: ScreenW, height: ScreenH - vcTop)
        searchResultVC.tableviewScroll = {() in
            guard !self.customSearchBar.searchBar.isFirstResponder else {
                self.customSearchBar.searchBar.resignFirstResponder()
                return
            }
        }
        searchResultVC.subjectTermID = self.subjectTermID
        return searchResultVC
    }()
    
    deinit {
        
        if (customSearchBar.searchBar.delegate != nil) {
            
            customSearchBar.searchBar.delegate = nil
        }
        
        if historyVC.view != nil {
            
            historyVC.view.removeFromSuperview()
            historyVC.removeFromParentViewController()
        }
        
        if searchResultVC.view != nil {
            
            searchResultVC.view.removeFromSuperview()
            searchResultVC.removeFromParentViewController()
        }
    }
}

//MARK: - UISearchBarDelegate
extension HomeSearchViewController: UISearchBarDelegate {
    //MARK: - 搜索点击
    func searchClick() {
        guard !(customSearchBar.searchBar.text?.isEmpty)! else {
            customSearchBar.searchBar.becomeFirstResponder()
            return
        }
        customSearchBar.searchBar.resignFirstResponder()
        searchResultVC.searchText = customSearchBar.searchBar.text
        if let historyView = historyVC.view {
            historyView.removeFromSuperview()
            view.bringSubview(toFront: searchResultVC.view)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchClick()
    }
}


