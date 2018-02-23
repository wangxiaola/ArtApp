//
//  HotShowAdCell.swift
//  meishubao
//
//  Created by 胡亚刚 on 2017/4/24.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit

class HotShowAdCell: UICollectionViewCell {
    fileprivate var bottomLineView: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dk_backgroundColorPicker = cell_backgroundColorPicker
        
        let topLine: CALayer = CALayer()
        topLine.frame = CGRect(x: 0,y: 0,width: self.width,height: 0.5)
        topLine.dk_backgroundColorPicker = separatorColorPicker
        layer.addSublayer(topLine)
        
        let bottomLine: CALayer = CALayer()
        bottomLine.frame = CGRect(x: 0,y: self.height - 0.5,width: self.width,height: 0.5)
        bottomLine.dk_backgroundColorPicker = separatorColorPicker
        layer.addSublayer(bottomLine)
        
        bottomLineView = bottomLine
        
        uiconfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiconfig() {
        addSubview(titleLabel)
        addSubview(adImageView)
        addSubview(adTipLabel)
        addSubview(adNameLabel)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var adImageView: UIImageView = {
        let adImageView = UIImageView()
        adImageView.contentMode = .scaleAspectFill
        adImageView.backgroundColor = UIColor.lightGray;
        adImageView.clipsToBounds = true
        return adImageView
    }()
    
    lazy var adTipLabel: UILabel = {
        let adTipLabel = UILabel()
        adTipLabel.font = UIFont.boldSystemFont(ofSize: 10)
        adTipLabel.text = "广告"
        adTipLabel.dk_backgroundColorPicker = DKColorSwiftWithRGB(0x898989, 0x606060)
        adTipLabel.textAlignment = .center
        adTipLabel.dk_textColorPicker = DKColorSwiftWithRGB(0xF0F0F0, 0x989898)
        adTipLabel.layer.cornerRadius = 1.5
        adTipLabel.layer.masksToBounds = true
        return adTipLabel
    }()
    
    lazy var adNameLabel: UILabel = {
        let label = UILabel()
        label.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        label.font = UIFont.boldSystemFont(ofSize: 11)
        return label
    }()
    
    var showModel: ArticleModel? {
        didSet{
            let postType = NSString(string:(showModel?.post_type)!)
            if postType.integerValue != HeadLineTypeAds {
                return
            }
            var padding: CGFloat = 0
            
            if showModel?.ad_content != "" {
                titleLabel.text = showModel?.ad_content
                titleLabel.frame = CGRect(x:leftPadding,y:topPadding,width:adImageWidth,height:20)
                padding = topPadding
            }else{
                titleLabel.frame = CGRect(x:leftPadding,y:topPadding,width:adImageWidth,height:0)
                padding = 0
            }
            
            adImageView.sd_setImage(with: URL(string:showModel?.ad_image ?? ""), placeholderImage: #imageLiteral(resourceName: "article_cell"))
            adImageView.frame = CGRect(x:leftPadding,y:titleLabel.frame.maxY+padding,width:adImageWidth,height:adImageHeight)
            
            adTipLabel.frame = CGRect(x:leftPadding,y:adImageView.y+adImageView.height+topPadding,width:25,height:15)
            
            let adName = NSString(string:(showModel?.ad_name)!)
            let adNameWidth = adName.size(with: UIFont.systemFont(ofSize: 11)).width
            adNameLabel.text = showModel?.ad_name ?? ""
            adNameLabel.frame = CGRect(x:adTipLabel.x+adTipLabel.width+topPadding,y:adTipLabel.y,width:adNameWidth,height:adTipLabel.height)
            adNameLabel.centerY = adTipLabel.centerY
            
            bottomLineView.frame = CGRect(x: 0,y: adNameLabel.frame.maxY + topPadding,width: self.width,height: 0.5)
        }
    }
}
