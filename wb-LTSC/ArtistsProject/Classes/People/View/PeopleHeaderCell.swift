//
//  PeopleHeaderCell.swift
//  meishubao
//
//  Created by LWR on 2016/11/18.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit
//import SDWebImage

let peopleHeaderCellID = "peopleHeaderCellID"

class PeopleHeaderCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x222222)
        
        // 创建子控件
        contentView.layer.addSublayer(shape)
        contentView.addSubview(peoplePic)
        
        var marginLeft: CGFloat = 13.5
        if isIPhone5 {
            marginLeft = 5.5
        }
        
        shape.frame = CGRect(x: marginLeft, y: 13, width: 50, height: 50)
        
        peoplePic.snp.makeConstraints { (make) in
            make.width.equalTo(46)
            make.height.equalTo(46)
            make.left.equalTo(self).offset(marginLeft + 2)
            make.top.equalTo(self).offset(15)
        }
        
        // 进行切割
        peoplePic.layer.cornerRadius = 23
        peoplePic.layer.masksToBounds = true
        
        contentView.addSubview(peopleTitle)
        
        peopleTitle.snp.makeConstraints { (make) in
            make.left.equalTo(peoplePic.snp.right).offset(4)
            make.centerY.equalTo(peoplePic.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(-3)
            make.height.equalTo(36)
        }
    }
    
    var model:PeopleModel? {
        didSet {
            peoplePic.sd_setImage(with: NSURL(string: (model?.photo)!) as URL! , placeholderImage: #imageLiteral(resourceName: "people_collection_cell"))
            peopleTitle.text = model?.name
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var peoplePic: UIImageView = {
        let peoplePic = UIImageView()
        
        peoplePic.contentMode = .scaleAspectFill
        peoplePic.clipsToBounds = true
        
        return peoplePic
    }()
    
    lazy var shape: CAShapeLayer = {
        let shape = CAShapeLayer()
        let mask = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50))
        shape.path = mask.cgPath
        shape.strokeColor = RGBColor(162, g: 162, b: 162).cgColor
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
    
    lazy var peopleTitle: UILabel = {
        let peopleTitle = UILabel()
        peopleTitle.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        peopleTitle.font = UIFont.boldSystemFont(ofSize: 14.0)
        peopleTitle.numberOfLines = 0;
        
        return peopleTitle
    }()
}
