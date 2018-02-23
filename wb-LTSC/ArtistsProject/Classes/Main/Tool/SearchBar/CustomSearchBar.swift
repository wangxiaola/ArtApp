//
//  CustomSearchBar.swift
//  meishubao
//
//  Created by LWR on 2016/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class CustomSearchBar: UIView {
    
    let bgImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dk_backgroundColorPicker = cell_backgroundColorPicker
        addSubview(cancelBtn)
        addSubview(searchBar)
        
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self)
            make.height.equalTo(32)
            make.width.equalTo(self.width - 63)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(searchBar.snp.right).offset(10)
            make.height.equalTo(searchBar)
            make.width.equalTo(30)
            make.centerY.equalTo(searchBar)
        }
    }

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        // 设置输入框
        let searchField = searchBar.value(forKey: "searchField") as? UITextField
        searchField?.font = UIFont.systemFont(ofSize: 14.0)
        let isNight = UserDefaults.standard.bool(forKey: APP_NIGHT_MODE)
        if isNight {
           searchField?.keyboardAppearance = UIKeyboardAppearance.dark
        }else{
            searchField?.keyboardAppearance = UIKeyboardAppearance.default
        }
        searchField?.dk_textColorPicker = DKColorSwiftWithRGB(0x1D1D26, 0x989898)
        
        searchField?.backgroundColor = UIColor.clear
        
        let attribute: [String : UIColor] = [NSForegroundColorAttributeName: RGBColor(148, g: 148, b: 148)]
        let attributeS = NSAttributedString(string: "搜索关键字", attributes: attribute)
        searchField?.attributedPlaceholder = attributeS

        let searchImg = UIImageView()
        searchImg.frame.size = CGSize(width: 13.5, height: 13.5)
        searchImg.contentMode = .center
        searchImg.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "category_search"), nightImage: #imageLiteral(resourceName: "category_search_dark"))
        // 设置放大镜图片
        searchField?.leftView = searchImg
        searchField?.leftViewMode = .always
        
        self.bgImageView.dk_imagePicker = DKImage.picker(withNormalImage: #imageLiteral(resourceName: "search_bar_bg"), nightImage: #imageLiteral(resourceName: "search_bar_bg_dark"))
        
        searchBar.backgroundImage = self.bgImageView.image
        
        return searchBar
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton()
        cancelBtn.setTitle("搜索", for: .normal)
        cancelBtn.setTitle("搜索", for: .selected)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.setTitleColor(UIColor.black, for: .selected)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.dk_setTitleColorPicker(DKColorSwiftWithRGB(0x000000, 0x989898), for: .normal)
        cancelBtn.dk_setTitleColorPicker(DKColorSwiftWithRGB(0x000000, 0x989898), for: .selected)
        
        return cancelBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


