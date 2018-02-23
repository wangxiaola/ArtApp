//
//  HeadLineImageLayout.swift
//  meishubao
//
//  Created by 胡亚刚 on 2017/7/19.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit

class HeadLineImageLayout: UICollectionViewFlowLayout {

    var attrs = [UICollectionViewLayoutAttributes]()
    var imageX: CGFloat = 0

    var images: [ArticleImageModel]? {

        didSet {
            attrs.removeAll()
            var x: CGFloat = leftPadding
            var width: CGFloat = 0

            for i in 0..<(images?.count)! {

                let indexPath = IndexPath(row: i, section: 0)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let imageModel = images?[i]
                width = imageModel?.width ?? 0
                attr.frame = CGRect(x: x, y: 0, width: width, height: imageHeight)
                if i == (images?.count)! - 1 {
                    x += (width + leftPadding);
                }else {
                    x += (width + self.minimumInteritemSpacing);
                }
                attrs.append(attr)
            }
            imageX = x
        }
    }

    override func prepare() {
        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        return attrs
    }

    override var collectionViewContentSize: CGSize {

        return CGSize(width: imageX, height: imageHeight)
    }
}
