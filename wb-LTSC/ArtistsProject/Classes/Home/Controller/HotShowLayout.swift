//
//  HotShowLayout.swift
//  meishubao
//
//  Created by 胡亚刚 on 2017/4/24.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit

let HotScrollHeight: CGFloat = ScreenW * 200 / 375.0 // 轮播图高度
let HotShowSearchBarHeight: CGFloat = 44.0 // 搜索框高度

let HotShowCellWidth: CGFloat = (ScreenW - 4 * 15) / 3
let HotShowCellImageViewHeight: CGFloat = ScreenW * 130 / 375
let HotShowCellHeight: CGFloat = HotShowCellImageViewHeight + 102

let AdCellWidth: CGFloat = ScreenW
let AdCellHeight: CGFloat = topPadding * 4 + 20 + adImageHeight + 15

let HotShowHeaderWidth: CGFloat = ScreenW
let HotShowHeaderHeight: CGFloat = HotScrollHeight + HotShowSearchBarHeight

protocol HotShowLayoutDataSource: NSObjectProtocol {
    
    func cellLayoutEachFrameForItemAtIndexPath(layout: HotShowLayout,indexPath: IndexPath) -> CGRect
    
    func collectionViewContentSize(layout: HotShowLayout) -> CGSize
}

class HotShowLayout: UICollectionViewFlowLayout {
    weak var dataSource: HotShowLayoutDataSource?
    
    override func prepare() {
        super.prepare()
    }
    
    override var collectionViewContentSize: CGSize {
        get{
            return dataSource?.collectionViewContentSize(layout: self) ?? CGSize.zero
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attr.frame = dataSource?.cellLayoutEachFrameForItemAtIndexPath(layout: self, indexPath: indexPath) ?? CGRect.zero
        return attr
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = [UICollectionViewLayoutAttributes]()
        
        for j in 0..<(collectionView?.numberOfSections)! {
            
            let indexPath: IndexPath = IndexPath(item: 0, section: j)
            
            attrs.append(layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)!)
            
            for i in 0..<(collectionView?.numberOfItems(inSection: j))! {
                let indexPath = IndexPath(item: i, section: j)
                attrs.append(layoutAttributesForItem(at: indexPath)!)
            }
        }
        return attrs
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionElementKindSectionHeader {
            let attr = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            attr.frame = CGRect(x: 0,y: 0,width: HotShowHeaderWidth,height: HotShowHeaderHeight)
            return attr
        }
        return nil
    }
}
