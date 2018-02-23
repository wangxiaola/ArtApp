//
//  HeadLineGeneralCell.swift
//  meishubao
//
//  Created by LWR on 2016/11/17.
//  Copyright © 2016年 benbun. All rights reserved.
//  
//  首页,国内头条等几个相同样式的控制器的cell
//  图片, 标题, 日期, 评论数, 发布状态

import UIKit
//import SnapKit
//import SDWebImage

let generalCellID = "HeadLineGeneralCell"

class HeadLineGeneralCell: UITableViewCell {

    let titleLabW = CGFloat(ScreenW - ScreenW * 112 / 375.0 - 34)
    
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
    
    var articleModel: ArticleModel? {
        didSet {
            articlePic.sd_setImage(with: NSURL(string: articleModel?.post_image ?? "") as URL! , placeholderImage: #imageLiteral(resourceName: "article_cell"))
            
            articleTitle.text = articleModel?.post_title
            let size = NSString.size(withText: articleTitle.text, font: UIFont.systemFont(ofSize: 16), maxSize: CGSize(width: titleLabW, height: 0))
            var titleLabH = size.height + 1
            if isIPhone5 {
                if titleLabH > 39 {
                    titleLabH = 39
                }
            }else if isIPhone4 {
                if titleLabH > 39 {
                    titleLabH = 39
                }
            }else {
                if titleLabH > 57 {
                    titleLabH = 58
                }
            }
            
            articleTitle.snp.remakeConstraints { (make) in
                make.top.equalTo(self).offset(12.5)
                make.left.equalTo(articlePic.snp.right).offset(6.5)
                make.width.equalTo(titleLabW)
                make.height.equalTo(titleLabH)
            }
            
            articleTime.text = TimeStamp.timeStampToTime(timeStamp: (articleModel?.post_date)!, dateFormat: "yyyy年MM月dd日")
            
            articleComment.text = articleModel?.comment_num
            
            guard TimeStamp.judgeLatestWith(timeStamp: (articleModel?.post_date)!) else {
                articleStatus.isHidden = true
                articleComment.snp.remakeConstraints({ (make) in
                    make.bottom.equalTo(articleTime.snp.bottom)
                    make.right.equalTo(self).offset(-14)
                })
                
                return
            }
        }
    }

    func setup() {
        // 添加视图
        contentView.addSubview(articlePic)
        contentView.addSubview(articleTitle)
        contentView.addSubview(articleTime)
        contentView.addSubview(articleComment)
        contentView.addSubview(articleStatus)
        
        // 添加约束
        articlePic.snp.makeConstraints { (make) in
            make.height.equalTo(ScreenW * 70.5 / 375.0)
            make.width.equalTo(ScreenW * 112 / 375.0)
            make.top.equalTo(self).offset(12.5)
            make.left.equalTo(self).offset(13.5)
        }
        
        articleTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(12.5)
            make.left.equalTo(articlePic.snp.right).offset(6.5)
            make.width.equalTo(titleLabW)
            make.height.equalTo(ScreenW * 54.5 / 375.0)
        }
        
        articleTime.snp.makeConstraints { (make) in
            make.left.equalTo(articlePic.snp.right).offset(7.5)
            make.bottom.equalTo(-11.5)
            make.width.equalTo(100.0)
        }
        
        articleStatus.snp.makeConstraints { (make) in
            make.bottom.equalTo(articleTime.snp.bottom)
            make.right.equalTo(self).offset(-14)
        }
        
        articleComment.snp.makeConstraints { (make) in
            make.bottom.equalTo(articleTime.snp.bottom)
            make.right.equalTo(articleStatus.snp.left).offset(-10.5)
        }
    }
    
    // 图片
    lazy var articlePic: UIImageView = {
        let articlePic = UIImageView()
        articlePic.contentMode = .scaleAspectFill
        articlePic.backgroundColor = UIColor.lightGray
        articlePic.clipsToBounds = true
        
        return articlePic
    }()
    
    // 标题
    lazy var articleTitle: UILabel = {
        let articleTitle = UILabel()
        articleTitle.numberOfLines = 0
        articleTitle.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        articleTitle.font = UIFont.boldSystemFont(ofSize: 16)
        
        return articleTitle
    }()
    
    // 时间
    lazy var articleTime: UILabel = {
        let articleTime = UILabel()
        articleTime.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        articleTime.font = UIFont.systemFont(ofSize: 11.0)
        
        return articleTime
    }()
    
    // 评论
    lazy var articleComment: UILabel = {
        let articleComment = UILabel()
        articleComment.font = UIFont.systemFont(ofSize: 11.0)
         articleComment.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        return articleComment
    }()
    
    // 发布状态
    lazy var articleStatus: UILabel = {
        let articleStatus = UILabel()
        articleStatus.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        articleStatus.font = UIFont.systemFont(ofSize: 11.0)
        articleStatus.text = "最新发布"
        
        return articleStatus
    }()
    
    class func rowHeight() -> CGFloat {
        return ScreenW * 96.5 / 375.0
    }
}
