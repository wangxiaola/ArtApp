//
//  RecommendCell.swift
//  meishubao
//
//  Created by LWR on 2016/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit
//import SDWebImage

let recommendCellID = "recommendCellID"

class RecommendCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dk_backgroundColorPicker = cell_backgroundColorPicker
        // 初始化视图
        setup()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var articleModel: ArticleModel? {
        didSet {
            var url: String = ""

            if (articleModel?.smeta.count)! > 0 {
                url = (articleModel?.smeta.first?.url)!
            }
            bottomIcon.sd_setImage(with: NSURL(string: articleModel?.post_image ?? url) as URL! , placeholderImage: #imageLiteral(resourceName: "recommend_cell_bg"))
            titleLab.text = articleModel?.post_title
            concernLab.text = articleModel?.attention_num
            // 重新改变约束
            let size = NSString.size(withText: concernLab.text, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 0, height: 17.5))
            concernLab.snp.remakeConstraints { (make) in
                make.left.equalTo(concernIcon.snp.right)
                make.top.equalTo(concernIcon)
                make.height.equalTo(concernIcon)
                make.width.equalTo(size.width + 4)
            }
            
            guard TimeStamp.judgeLatestWith(timeStamp: (articleModel?.post_date)!) else {
                latestLab.isHidden = true
                
                concernIcon.snp.remakeConstraints({ (make) in
                    make.left.equalTo(titleLab.snp.left)
                    make.bottom.equalTo(-3)
                    make.height.equalTo(17.5)
                    make.width.equalTo(21)
                })
                
                return
            }
            
            latestLab.isHidden = false
            
            concernIcon.snp.remakeConstraints({ (make) in
                make.left.equalTo(latestLab.snp.right).offset(2)
                make.bottom.equalTo(-3)
                make.height.equalTo(17.5)
                make.width.equalTo(21)
            })
        }
    }
    
    //MARK: - 初始化
    func setup() {
        contentView.addSubview(bottomIcon)
        contentView.addSubview(shadowV)
        shadowV.addSubview(titleLab)
        shadowV.addSubview(latestLab)
        shadowV.addSubview(concernIcon)
        shadowV.addSubview(concernLab)
        
        // 添加约束
        bottomIcon.snp.makeConstraints { (make) in
            make.width.equalTo(contentView)
            make.height.equalTo(contentView)
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
        }
        
        shadowV.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.height.equalTo(80)
        }
        
        latestLab.snp.makeConstraints { (make) in
            make.left.equalTo(13.5)
            make.height.equalTo(15)
            make.width.equalTo(55)
            make.bottom.equalTo(-6)
        }
        
        concernIcon.snp.makeConstraints { (make) in
            make.left.equalTo(latestLab.snp.right).offset(2)
            make.bottom.equalTo(-3)
            make.height.equalTo(latestLab)
            make.width.equalTo(21)
        }
        
        concernLab.snp.makeConstraints { (make) in
            make.left.equalTo(concernIcon.snp.right)
            make.top.equalTo(concernIcon)
            make.height.equalTo(concernIcon)
            make.width.equalTo(80)
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(13.5)
            make.right.equalTo(-13.5)
            make.height.equalTo(41)
            make.bottom.equalTo(concernIcon.snp.top).offset(-3)
        }
    }
    
    // 绘制控件
    // 底图
    lazy var bottomIcon: UIImageView = {
        let bottomIcon = UIImageView()
        bottomIcon.clipsToBounds = true
        bottomIcon.contentMode = .scaleAspectFill
        return bottomIcon
    }()
    
    // 遮罩
    lazy var shadowV: UIImageView = {
//        let shadowV = GraphView(frame: CGRect(x: 0, y: 90, width: ScreenW, height: 60))
//        shadowV.startColor = RGBColor(210, g: 210, b: 210)
//        shadowV.endColor = UIColor.black
//        shadowV.alpha = 0.8
        let shadowV = UIImageView()
//        shadowV.backgroundColor = RGBAColor(0, g: 0, b: 0, a: 0.6)
        shadowV.image = #imageLiteral(resourceName: "home_shadow_bg")
//        shadowV.contentMode = .scaleAspectFit
        shadowV.isUserInteractionEnabled = true
        
        return shadowV
    }()
    
    // 标题
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.dk_textColorPicker = DKColorSwiftWithRGB(0xffffff, 0x989898)
        titleLab.numberOfLines      = 2
        titleLab.font = UIFont.systemFont(ofSize: 17)
        
        return titleLab
    }()
    
    // 最近推荐
    lazy var latestLab: UILabel = {
        let latestLab = UILabel()
        latestLab.dk_textColorPicker = DKColorSwiftWithRGB(0xffffff, 0x989898)
        latestLab.textAlignment = .center
        latestLab.backgroundColor = APP_TABBARITEM_SELET_COLOR
        latestLab.font = UIFont.systemFont(ofSize: 12)
        latestLab.text = "最新推荐"
        
        return latestLab
    }()
    
    // 关注图标
    lazy var concernIcon: UIImageView = {
        let concernIcon = UIImageView()
        concernIcon.image = #imageLiteral(resourceName: "home_concern_icon")
//        concernIcon.backgroundColor = RGBAColor(0, g: 0, b: 0, a: 0.3)
        concernIcon.contentMode = .center
        
        return concernIcon
    }()
    
    // 关注数量
    lazy var concernLab: UILabel = {
        let concernLab = UILabel()
//        concernLab.backgroundColor = RGBAColor(0, g: 0, b: 0, a: 0.3)
        concernLab.dk_textColorPicker = DKColorSwiftWithRGB(0xffffff, 0x989898)
        concernLab.textColor = UIColor.white
        concernLab.font = UIFont.systemFont(ofSize: 12)
        concernLab.textAlignment = .center
        
        return concernLab
    }()
    
    //MARK: - 行高
    class func rowHeight() -> CGFloat {
        
        return ScreenW * 0.7
    }

}
