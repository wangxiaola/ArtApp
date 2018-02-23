//
//  PeopleSearchResutCell.swift
//  meishubao
//
//  Created by LWR on 2016/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit
//import SDWebImage

let peopleSearchResultCellID = "PeopleSearchResutCell"

class PeopleSearchResutCell: UITableViewCell {
    let subLabW = CGFloat(ScreenW - 109)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        dk_backgroundColorPicker = cell_backgroundColorPicker
        
        // 初始化视图
        setup()
        
        separatorInset = UIEdgeInsetsMake(0, 14.5, 0, 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化
    func setup() {
        contentView.addSubview(headIconBg)
        headIconBg.addSubview(headIcon)
        contentView.addSubview(nameLab)
        contentView.addSubview(subLab)
        
        // 添加约束
        headIcon.snp.makeConstraints { (make) in
            make.left.equalTo(3.5)
            make.right.equalTo(-3.5)
            make.top.equalTo(3.5)
            make.bottom.equalTo(-3.5)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(headIcon.snp.right).offset(9.5)
            make.top.equalTo(18.5)
            make.right.equalTo(-14)
            make.height.equalTo(14)
        }
        
        subLab.snp.makeConstraints { (make) in
            make.width.equalTo(subLabW)
            make.top.equalTo(nameLab.snp.bottom).offset(3)
            make.left.equalTo(nameLab.snp.left)
            make.height.equalTo(58.0)
        }
    }

    var model: PeopleModel? {
        didSet {
            headIcon.sd_setImage(with: NSURL(string: (model?.photo)!) as URL! , placeholderImage: #imageLiteral(resourceName: "people_search_cell"))
            nameLab.text = model?.name
            
            if (model?.positionStr.isEmpty)! {
                subLab.text = model?.intro
            }else{
                subLab.text = model?.positionStr.appending("\n\((model?.intro)!)")
            }
            
            let size = NSString.size(withText: subLab.text, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: subLabW, height: 0))
            var subLabH = size.height + 1
            if subLabH > 58.0 {
                subLabH = 58.0
            }
            subLab.snp.remakeConstraints { (make) in
                make.width.equalTo(subLabW)
                make.top.equalTo(nameLab.snp.bottom).offset(3)
                make.left.equalTo(nameLab.snp.left)
                make.height.equalTo(subLabH)
            }
        }
    }

    lazy var headIconBg: UIImageView = {
        let rect = CGRect(x: 14, y: 14, width: 63, height: 80)
        let headIconBg = UIImageView(frame: rect)
        
        let mask = UIBezierPath.init(roundedRect: rect, cornerRadius: 2)
        let shape = CAShapeLayer()
        shape.path = mask.cgPath
        shape.strokeColor = RGBColor(201, g: 202, b: 202).cgColor
        shape.frame = CGRect(x: -14, y: -14, width: 63, height: 80)
        shape.fillColor = UIColor.clear.cgColor
        headIconBg.layer.addSublayer(shape)
        
        return headIconBg
    }()
    
    lazy var headIcon: UIImageView = {
        let headIcon = UIImageView()
        headIcon.contentMode = .scaleAspectFill
        headIcon.clipsToBounds = true
        
        return headIcon
    }()

    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.dk_textColorPicker = DKColorSwiftWithRGB(0x909090, 0x989898)
        nameLab.font = UIFont.systemFont(ofSize: 14)
        return nameLab
    }()
    
    lazy var subLab: UILabel = {
        let subLab = UILabel()
        subLab.font = UIFont.systemFont(ofSize: 12)
        subLab.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        subLab.numberOfLines = 0
        return subLab
    }()
    
    func splitText(name: String, brief: String?) -> NSMutableAttributedString {
        guard let brief = brief else {
            return NSMutableAttributedString(string: name)
        }
        
        guard brief != "" else {
            return NSMutableAttributedString(string: name)
        }
        
        let newBried = "(" + brief + ")"
        let attributText = name + newBried
        var range = NSRange()
        let location = name.characters.count
        range.length = newBried.characters.count
        range.location = location
        
        let dic = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName : RGBColor(89, g: 87, b: 87)
        ]
        let nameAttributedS = NSMutableAttributedString(string: attributText)
        nameAttributedS.addAttributes(dic, range: range)
        return nameAttributedS
    }
    
    //MARK: - 行高
    class func rowHeight() -> CGFloat {
        return 110.0
    }
}
