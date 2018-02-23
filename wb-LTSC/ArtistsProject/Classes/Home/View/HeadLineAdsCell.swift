//
//  HeadLineAdsCell.swift
//  meishubao
//
//  Created by benbun－mac on 17/1/20.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit
//import SDWebImage
let adCellID = "adCellID"
let adImageWidth: CGFloat = ScreenW - leftPadding*2
let adImageHeight: CGFloat = ScreenW * 150 / 375.0
class HeadLineAdsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        dk_backgroundColorPicker = cell_backgroundColorPicker
        
        // 初始化视图
        layout()
    }
    
    func layout(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(adImageView)
        contentView.addSubview(adTipLabel)
        contentView.addSubview(adNameLabel)
    }
    
    var articleModel: ArticleModel? {
        didSet{
            let postType = NSString(string:(articleModel?.post_type)!)
            if postType.integerValue != HeadLineTypeAds {
                return
            }
            
            if articleModel?.ad_content == nil || articleModel?.ad_content == "" {
                titleLabel.frame = CGRect.zero
                adImageView.frame = CGRect(x:leftPadding,y:topPadding,width:adImageWidth,height:adImageHeight)
            }else{
                let titleSize = NSString.size(withText: articleModel?.ad_content, font: UIFont.systemFont(ofSize: 16), maxSize: CGSize(width:adImageWidth,height:99999))
                titleLabel.text = articleModel?.ad_content
                titleLabel.frame = CGRect(x:leftPadding,y:topPadding,width:adImageWidth,height:titleSize.height)
                
                adImageView.frame = CGRect(x:leftPadding,y:titleLabel.y+titleLabel.height+topPadding,width:adImageWidth,height:adImageHeight)
            }
            
            adImageView.sd_setImage(with: URL(string:articleModel?.ad_image ?? ""), placeholderImage: #imageLiteral(resourceName: "article_cell"))
            
            adTipLabel.frame = CGRect(x:leftPadding,y:adImageView.y+adImageView.height+topPadding,width:25,height:15)
            
//            let adName = NSString(string:(articleModel?.ad_name)!)
//            let adNameWidth = adName.size(with: UIFont.systemFont(ofSize: 11)).width
            adNameLabel.text = articleModel?.ad_name ?? ""
            adNameLabel.frame = CGRect(x:adTipLabel.x+adTipLabel.width+topPadding,y:adTipLabel.y,width:adImageView.width - (25 + topPadding),height:20)
            adNameLabel.centerY = adTipLabel.centerY
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
