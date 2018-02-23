//
//  HotestShowCell.swift
//  meishubao
//
//  Created by 胡亚刚 on 2017/4/18.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit

class HotestShowCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dk_backgroundColorPicker = cell_backgroundColorPicker
        uiconfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView.init(frame: CGRect(x: 0,y: 0,width: self.width,height: HotShowCellImageViewHeight))
        iconImageView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xf1f1f1,0xf1f1f1)
        return iconImageView
    }()
    
    lazy var titleLable: UILabel = {
        let titleLable = UILabel.init(frame: CGRect(x: 0,y: self.iconImageView.frame.maxY + 5,width: self.iconImageView.width,height: 30))
        titleLable.textAlignment = .left
        titleLable.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        titleLable.font = UIFont.systemFont(ofSize: 12)
        titleLable.numberOfLines = 2
        return titleLable
    }()
    
    lazy var startDateLable: UILabel = {
        let startDateLable = UILabel.init(frame: CGRect(x: 0,y: self.titleLable.frame.maxY + 10,width: self.titleLable.width,height: 15))
        startDateLable.textAlignment = .left
        startDateLable.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        //dateLable.backgroundColor = UIColor.red
        startDateLable.font = UIFont.systemFont(ofSize: 11)
        return startDateLable
    }()

    lazy var toLable: UILabel = {
        let toLable = UILabel.init(frame: CGRect(x: self.titleLable.width - 15,y: self.startDateLable.y,width: 15,height: 15))
        toLable.textAlignment = .right
        toLable.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        //dateLable.backgroundColor = UIColor.red
        toLable.font = UIFont.systemFont(ofSize: 11)
        return toLable
    }()

    lazy var endDateLable: UILabel = {
        let endDateLable = UILabel.init(frame: CGRect(x: 0,y: self.startDateLable.frame.maxY,width: self.titleLable.width,height: 15))
        endDateLable.textAlignment = .left
        endDateLable.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        //dateLable.backgroundColor = UIColor.red
        endDateLable.font = UIFont.systemFont(ofSize: 11)
        return endDateLable
    }()

    lazy var addressLable: UILabel = {
        let addressLable = UILabel.init(frame: CGRect(x: 0,y: self.endDateLable.frame.maxY,width: self.titleLable.width,height: 27))
        addressLable.textAlignment = .left
        addressLable.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        //addressLable.backgroundColor = UIColor.green
        addressLable.font = UIFont.systemFont(ofSize: 11)
        addressLable.numberOfLines = 2
        return addressLable
    }()
    
    var showModel: ArticleModel? {
        didSet{
            iconImageView.sd_setImage(with: URL(string: showModel?.post_image ?? ""), placeholderImage: #imageLiteral(resourceName: "people_search_cell"))
            titleLable.text = showModel?.post_title

            if !(Double((showModel?.start_time)!) == 0) && !(Double((showModel?.end_time)!) == 0) {
                if  !(showModel?.start_time.characters.count == 0) && !(showModel?.end_time.characters.count == 0) {

                    startDateLable.text = TimeStamp.timeStampToTime(timeStamp: (showModel?.start_time)!, dateFormat: "yyyy.MM.dd")
                    endDateLable.text = TimeStamp.timeStampToTime(timeStamp: (showModel?.end_time)!, dateFormat: "yyyy.MM.dd")
                    toLable.text = "至"
                }
            }else {
                startDateLable.text = ""
                toLable.text = ""
                endDateLable.text = ""
            }
            
            let addressStr: String = (showModel?.city ?? "") + "\n" + (showModel?.medium ?? "")
            addressLable.text = addressStr
        }
    }
    
    func uiconfig() {
        addSubview(iconImageView)
        addSubview(titleLable)
        
        let line: CALayer = CALayer()
        line.frame = CGRect(x: 0,y: titleLable.frame.maxY + 5,width: self.width,height: 0.5)
        line.dk_backgroundColorPicker = separatorColorPicker
        layer.addSublayer(line)
        
        addSubview(startDateLable)
        addSubview(toLable)
        addSubview(endDateLable)
        addSubview(addressLable)
    }
}
