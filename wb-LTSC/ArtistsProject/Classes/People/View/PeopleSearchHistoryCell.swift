//
//  PeopleSearchHistoryCell.swift
//  meishubao
//
//  Created by LWR on 2016/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

let peopleSearchCellID = "PeopleSearchHistoryCell"

class PeopleSearchHistoryCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        dk_backgroundColorPicker = cell_backgroundColorPicker
        separatorInset = UIEdgeInsetsMake(0, 23, 0, 21.5)
        
        // 初始化视图
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var searchText: String? {
        didSet {
            titleLab.text = searchText
        }
    }
    
    //MARK: - 初始化
    func setup() {
        contentView.addSubview(titleLab)
    }
    
    //MARK: - 懒加载
    lazy var titleLab: UILabel = {
        let titleLab = UILabel(frame: CGRect(x: 30, y: 11, width: ScreenW - 60, height: 16))
        titleLab.font = UIFont.systemFont(ofSize: 12)
        titleLab.dk_textColorPicker = DKColorSwiftWithRGB(0x909090, 0x989898)
        
        return titleLab
    }()
    
    class func rowHeight() -> CGFloat {
        return 37.0
    }
}
