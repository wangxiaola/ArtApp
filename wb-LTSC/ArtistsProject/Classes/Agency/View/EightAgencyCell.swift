//
//  EightAgencyCell.swift
//  meishubao
//
//  Created by LWR on 2016/11/23.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit
//import SDWebImage

let eightAgencyCellID = "eightAgencyCellID"

class EightAgencyCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.clear
        
        // 添加子控件
        contentView.layer.addSublayer(shape)
        contentView.addSubview(agencyPic)
        contentView.addSubview(agencyName)
    
        let leftMargin = 10
        let nameLabW = (ScreenW / 3.0) - 55
        
        agencyPic.snp.makeConstraints { (make) in
            make.width.equalTo(42)
            make.height.equalTo(42)
            make.left.equalTo(leftMargin)
            make.top.equalTo(15)
        }
        
        shape.frame = CGRect(x: 8, y: 13, width: 46, height: 46)
        
        agencyName.snp.makeConstraints { (make) in
            make.left.equalTo(agencyPic.snp.right).offset(5)
            make.top.equalTo(16)
            make.width.equalTo(nameLabW)
            make.height.equalTo(36)
        }
        
        // 进行切割
        agencyPic.layer.cornerRadius = 21
        agencyPic.layer.masksToBounds = true
    }
    
    var model: AgencyHeaderModel? {
        didSet {
            agencyName.text = model?.name
            
            guard model?.org_id != "更多机构" else {
                agencyPic.image = UIImage(named: (model?.image)!)
                return
            }
            agencyPic.sd_setImage(with: NSURL(string: (model?.image)!) as URL! , placeholderImage: #imageLiteral(resourceName: "people_collection_cell"))
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var agencyPic: UIImageView = {
        let agencyPic = UIImageView()
        agencyPic.contentMode = .scaleAspectFill
        agencyPic.clipsToBounds = true
        
        return agencyPic
    }()
    
    lazy var agencyName: UILabel = {
        let agencyName = UILabel()
        agencyName.font = UIFont.systemFont(ofSize: 14.0)
        agencyName.dk_textColorPicker = DKColorSwiftWithRGB(0x030303, 0x989898)
        agencyName.numberOfLines = 0
        
        return agencyName
    }()
    
    lazy var shape: CAShapeLayer = {
        let shape = CAShapeLayer()
        let mask = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 46, height: 46))
        shape.path = mask.cgPath
        shape.strokeColor = RGBColor(162, g: 162, b: 162).cgColor
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
}
