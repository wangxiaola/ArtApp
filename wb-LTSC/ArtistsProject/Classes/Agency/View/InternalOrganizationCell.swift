//
//  InternalOrganizationCell.swift
//  meishubao
//
//  Created by LWR on 2016/12/12.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit

let InternalOrganizatioCellID = "InternalOrganizationCell"

class InternalOrganizationCell: UITableViewCell {

    var selectedBlcok:((_ model: AgencyHeaderModel) -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dk_backgroundColorPicker = headerView_backgroundColorPicker
        selectionStyle = .none
        contentView.addSubview(collection)
        
        // 添加约束
        collection.snp.makeConstraints { (make) in
            make.top.equalTo(-3)
            make.left.equalTo(0)
            make.width.equalTo(ScreenW)
            make.height.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var organizationArr: [AgencyHeaderModel]? {
        didSet {
            collection.reloadData()
            
            var num: Int = (organizationArr?.count)! / 3
            guard num != 0 else {
                collection.snp.remakeConstraints { (make) in
                    make.top.equalTo(-3)
                    make.left.equalTo(0)
                    make.width.equalTo(ScreenW)
                    make.height.equalTo(60)
                }
                return
            }
            
            if (organizationArr?.count)! % 3 != 0 {
                num += 1
            }
            
            collection.snp.remakeConstraints { (make) in
                make.top.equalTo(-3)
                make.left.equalTo(0)
                make.width.equalTo(ScreenW)
                make.height.equalTo(60 * num)
            }
        }
    }
    
    // 懒加载
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing  = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: ScreenW / 3.0, height: 60)
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 0), collectionViewLayout: layout)

        collection.register(EightAgencyCell.self, forCellWithReuseIdentifier: eightAgencyCellID)
        collection.backgroundColor = UIColor.clear
        collection.dataSource = self
        collection.delegate = self
        
        return collection
    }()

    //MARK: - 行高
    class func rowHeight() -> CGFloat {
        
        return 195.0
    }
}

extension InternalOrganizationCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let organizationArr = organizationArr  else {
            return 0
        }
        return organizationArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eightAgencyCellID, for: indexPath) as! EightAgencyCell
        cell.model = organizationArr?[indexPath.row]
        return cell
    }
}

extension InternalOrganizationCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (selectedBlcok != nil) {
            
            let model: AgencyHeaderModel = organizationArr![indexPath.row]
            selectedBlcok?(model)
        }
        PrintLog(message: "点击了第几个人物---\(indexPath.row)")
        
        
    }
}
