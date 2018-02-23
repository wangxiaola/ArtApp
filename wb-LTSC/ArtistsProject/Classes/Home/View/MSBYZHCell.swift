//
//  MSBYZHCell.swift
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class MSBYZHCell: UITableViewCell {

    var isRecommend:Bool = false

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.dk_backgroundColorPicker = cell_backgroundColorPicker
        selectionStyle = .none
        _commitInit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _commitInit(){
        contentView.addSubview(iconImageView)
        iconImageView.addSubview(topView)
        topView.addSubview(titleLabel)
        
        iconImageView.addSubview(bottomView)
        bottomView.addSubview(latestLab)
        bottomView.addSubview(timeLabel)
        
        iconImageView.addSubview(playImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            make.width.equalTo(contentView)
            make.height.equalTo(contentView)
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
        }
        
        topView.snp.makeConstraints { (make) in
            make.width.equalTo(iconImageView)
            make.height.equalTo(30)
            make.left.equalTo(iconImageView)
            make.top.equalTo(iconImageView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topView).offset(25)
            make.right.equalTo(topView).offset(-25)
            make.centerY.equalTo(topView)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.width.equalTo(iconImageView)
            make.height.equalTo(18)
            make.left.equalTo(iconImageView)
            make.bottom.equalTo(iconImageView)
        }

        latestLab.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(bottomView).offset(1)
            make.bottom.equalTo(bottomView).offset(-1)
            make.width.equalTo(55)
        }

        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView).offset(15)
            make.right.equalTo(bottomView).offset(-15)
            make.centerY.equalTo(bottomView)
        }
        
        playImageView.snp.makeConstraints { (make) in
            make.center.equalTo(iconImageView)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
    }
    
    var model: ArticleModel? {
        didSet {
            iconImageView.sd_setImage(with: NSURL(string: model?.post_image ?? "") as URL! , placeholderImage: UIImage.init(named: "recommend_cell_bg"))
            titleLabel.text = model?.post_title
            if let duration = model?.duration, let video_view = model?.video_view {
                timeLabel.text = duration + " / " + video_view + "播放"
            }


            guard isRecommend && TimeStamp.judgeLatestWith(timeStamp: (model?.post_date)!) else {
                latestLab.isHidden = true

                timeLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(bottomView).offset(15)
                    make.right.equalTo(bottomView).offset(-15)
                    make.centerY.equalTo(bottomView)
                })

                return
            }

            latestLab.isHidden = false

            timeLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(latestLab.snp.right).offset(2)
                make.right.equalTo(bottomView).offset(-15)
                make.centerY.equalTo(bottomView)
            })
        }
    }

    var infoStoreModel:MSBInfoStoreVideoItem?{//(infoStoreModel?.url)!
        didSet{
            guard let thumb = infoStoreModel?.thumb else {
                return
            }
            iconImageView.sd_setImage(with: NSURL(string: thumb) as URL! , placeholderImage: UIImage.init(named: "recommend_cell_bg"))
            titleLabel.text = infoStoreModel?.video_name

            if let duration = infoStoreModel?.duration, let video_view = infoStoreModel?.video_view {
                timeLabel.text = duration + " / " + video_view + "播放"
            }


            guard isRecommend else {
                latestLab.isHidden = true

                timeLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(bottomView).offset(15)
                    make.right.equalTo(bottomView).offset(-15)
                    make.centerY.equalTo(bottomView)
                })
                
                return
            }
            latestLab.isHidden = false

            timeLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(latestLab.snp.right).offset(2)
                make.right.equalTo(bottomView).offset(-15)
                make.centerY.equalTo(bottomView)
            })
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true;
        return iconImageView
    }()
    
    lazy var topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = RGBAColor(0, g: 0, b: 0, a: 0.7)
        return topView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.dk_textColorPicker = DKColorSwiftWithRGB(0xffffff, 0x989898)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = RGBAColor(0, g: 0, b: 0, a: 0.2)
        return bottomView
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

    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.dk_textColorPicker = DKColorSwiftWithRGB(0xffffff, 0x989898)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        return timeLabel
    }()
    
    lazy var playImageView: UIImageView = {
        let playImageView = UIImageView()
        playImageView.contentMode = .center;
        playImageView.image = UIImage.init(named: "home_yzhplay_icon")
        return playImageView
    }()
    
    class func rowHeight() -> CGFloat {
        
        return ScreenW * 160 / 375.0
    }
}
