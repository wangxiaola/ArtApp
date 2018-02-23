//
//  HeadLineCell.swift
//  meishubao
//
//  Created by LWR on 2017/7/19.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit

class HeadLineCell: UICollectionViewCell {

    @IBOutlet weak var iamgeView: UIImageView!

    var imageModel: ArticleImageModel? {

        didSet {

            dk_backgroundColorPicker = cell_backgroundColorPicker
            iamgeView.sd_setImage(with: URL(string: imageModel?.url ?? ""), placeholderImage: #imageLiteral(resourceName: "article_cell"))
        }
    }
}
