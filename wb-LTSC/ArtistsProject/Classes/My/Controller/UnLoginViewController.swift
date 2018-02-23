//
//  UnLoginViewController.swift
//  meishubao
//
//  Created by LWR on 2016/11/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class UnLoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. 初始化
        setup()
    }

//MARK: - 1. 初始化
    func setup() {
        // 添加滚动视图
        view.addSubview(scorll)
    }
    
    // 滚动视图
    private lazy var scorll: UIScrollView = {
        let scroll = UIScrollView(frame: self.view.bounds)
        
        scroll.backgroundColor = UIColor.red
        scroll.showsVerticalScrollIndicator = false
        
        return scroll
    }()
    
    // 头像
}
