//
//  HomeSearchBar.swift
//  meishubao
//
//  Created by LWR on 2016/11/17.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit

class HomeSearchBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        dk_backgroundColorPicker = DKColorSwiftWithRGB(0xE0E0E0, 0x222222)
//        dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x222222)
        addSubview(bgImageView)
        addSubview(searchBar)
    
        bgImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: self.width - 28, height: 32))
            make.center.equalTo(self)
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: self.width - 28, height: 32))
            make.center.equalTo(self)
        }
    }
    
    lazy var searchBar: CustomSearchField = {
        let searchBar = CustomSearchField()
    
        return searchBar
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "search_bar_bg"), nightImage: #imageLiteral(resourceName: "search_bar_bg_dark"))
        
        return bgImageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomSearchField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        let attribute: [String : UIColor] = [NSForegroundColorAttributeName: RGBColor(148, g: 148, b: 148)]
        let attributeS = NSAttributedString(string: "搜索关键字", attributes: attribute)
        attributedPlaceholder = attributeS
        
        // 设置放大镜图片
        let searchImg = UIImageView()
        searchImg.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "category_search"), nightImage: #imageLiteral(resourceName: "category_search_dark"))
        searchImg.frame.size = CGSize(width: 25, height: 25)
        searchImg.contentMode = .center
        leftView = searchImg
        leftViewMode = .always
        font = UIFont.systemFont(ofSize: 14)
        let color = RGBColor(29, g: 29, b: 38)
        textColor = color
        tintColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

