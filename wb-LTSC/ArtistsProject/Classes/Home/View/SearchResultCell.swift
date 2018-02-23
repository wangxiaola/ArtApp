//
//  SearchResultCell.swift
//  meishubao
//
//  Created by LWR on 2016/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit

let searchResultCellID = "SearchResultCell"

class SearchResultCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        dk_backgroundColorPicker = cell_backgroundColorPicker
        // 初始化视图
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化
    func setup() {
        contentView.addSubview(titleLab)
        contentView.addSubview(subTitleLab)
        contentView.addSubview(urlLab)
        
        // 添加约束
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.top.equalTo(11)
            make.right.equalTo(-18.5)
            make.height.equalTo(14)
        }
        
        subTitleLab.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.top.equalTo(titleLab.snp.bottom).offset(6)
            make.right.equalTo(-41)
            make.height.equalTo(14)
        }
        
        urlLab.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.top.equalTo(subTitleLab.snp.bottom).offset(2.5)
            make.right.equalTo(-41)
        }
        
        separatorInset = UIEdgeInsetsMake(0, 23, 0, 21.5)
    }
    
    var articleModel: ArticleModel? {
        didSet {
            titleLab.text = articleModel?.post_title
            subTitleLab.text = articleModel?.post_excerpt
            guard let author = articleModel?.author else {
                return
            }
            
            guard let date = articleModel?.post_date else {
                return
            }
            let t = TimeStamp.timeStampToTime(timeStamp: date, dateFormat: "yyyy-MM")
            
            urlLab.text = "\(author)  \(t)"
        }
    }

    
    //MARK: - 懒加载
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.font = UIFont.systemFont(ofSize: 14)
        titleLab.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        
        return titleLab
    }()
    
    lazy var subTitleLab: UILabel = {
        let subTitleLab = UILabel()
        subTitleLab.font = UIFont.systemFont(ofSize: 12)
        subTitleLab.dk_textColorPicker = DKColorSwiftWithRGB(0x9FA0A0, 0x989898)
        
        return subTitleLab
    }()
    
    lazy var urlLab: UILabel = {
        let urlLab = UILabel()
        urlLab.dk_textColorPicker = DKColorSwiftWithRGB(0x9FA0A0, 0x989898)
        urlLab.font = UIFont.systemFont(ofSize: 12)
        
        return urlLab
    }()
    
    class func rowHeight() -> CGFloat {
        return 66.0
    }
}
