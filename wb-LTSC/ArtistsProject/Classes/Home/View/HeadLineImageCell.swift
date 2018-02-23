//
//  HeadLineImageCell.swift
//  meishubao
//
//  Created by benbun－mac on 17/1/19.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit
//import SDWebImage
//import SnapKit

let leftPadding: CGFloat = 12.0
let topPadding: CGFloat = 8.0
let imageWidth: CGFloat = ScreenW * 112 / 375.0
let imageHeight: CGFloat = ScreenW * 180 / 375.0
let imageCellID = "imageCellID"
class HeadLineImageCell: UITableViewCell, UICollectionViewDataSource {

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
    
    func layout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(imageCollectionView)
        contentView.addGestureRecognizer(imageCollectionView.panGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var articleModel: ArticleModel? {
        didSet {

            let postType = NSString(string:(articleModel?.post_type)!)
            if postType.integerValue != HeadLineTypeImages {
                return
            }
            //let padding = (ScreenW - imageWidth * 3 - leftPadding * 2) / 2
            let titleSize = NSString.size(withText: articleModel?.post_title, font: UIFont.systemFont(ofSize: 16), maxSize: CGSize(width:ScreenW-leftPadding * 2,height:99999))
            titleLabel.text = articleModel?.post_title
            titleLabel.frame = CGRect(x:leftPadding,y:topPadding,width:ScreenW - leftPadding * 2,height:titleSize.height)
            
            var dateY: CGFloat = 0
            if articleModel?.smeta.count != 0 {
                imageCollectionView.frame = CGRect(x: 0,y: titleLabel.height + topPadding * 2,width: contentView.width,height: imageHeight)

                loadImage()
                dateY = topPadding * 3 + titleSize.height + imageHeight
            }else{
                dateY = topPadding * 2 + titleSize.height
            }
            dateLabel.text = TimeStamp.timeStampToTime(timeStamp: (articleModel?.post_date)!, dateFormat: "yyyy年MM月dd日")
            dateLabel.frame = CGRect(x:leftPadding,y:dateY,width:180,height:20)
            
            guard let comment = articleModel?.comment_num else {
                return
            }
            let commentWidth = comment.size(with: UIFont.systemFont(ofSize: 11)).width
            commentLabel.text = comment
            commentLabel.frame = CGRect(x:ScreenW - leftPadding - commentWidth, y:dateLabel.y, width: commentWidth, height: 20)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        label.font = UIFont.systemFont(ofSize: 11.0)
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.dk_textColorPicker = DKColorSwiftWithRGB(0x595757, 0x989898)
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.text = "最新发布"
        return label
    }()

    lazy var imageLayout: HeadLineImageLayout = {
        let layout = HeadLineImageLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 7
        return layout
    }()

    lazy var imageCollectionView: UICollectionView = {

        let imageCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.imageLayout)
        imageCollectionView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x1c1c1c)
        imageCollectionView.dataSource = self
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.isUserInteractionEnabled = false

        imageCollectionView.register(UINib(nibName: "HeadLineCell", bundle: nil), forCellWithReuseIdentifier: "HeadLineCell")
        imageCollectionView.register(HeadLineCell.self, forCellWithReuseIdentifier: NSStringFromClass(HeadLineCell.self))
        return imageCollectionView
    }()

    func loadImage() {
        self.imageLayout.images = self.articleModel?.smeta
        self.imageCollectionView.reloadData()
        self.imageCollectionView.scrollToItem(at: IndexPath(row: 0,section: 0), at: .left, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (articleModel?.smeta.count) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeadLineCell", for: indexPath) as? HeadLineCell
        cell?.imageModel = articleModel?.smeta[indexPath.item]
        return cell!
    }
}
