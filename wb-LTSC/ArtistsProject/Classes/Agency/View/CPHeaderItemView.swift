//
//  CPHeaderItemView.swift
//  meishubao
//
//  Created by benbun－mac on 17/1/22.
//  Copyright © 2017年 benbun. All rights reserved.
//

import UIKit

let CPHeaderItemTopPadding: CGFloat = 12
let CPHeaderItemPadding: CGFloat = 10
let CPHeaderItemLeftPadding: CGFloat = 12
let CPHeaderItemWidth: CGFloat = (ScreenW-CPHeaderItemLeftPadding*6)/5
let CPHeaderItemViewHeight: CGFloat = CPHeaderItemTopPadding*2 + CPHeaderItemPadding + CPHeaderItemWidth*2
fileprivate let num = 10

class CPHeaderItemView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
    }
    
    var currentVc: UIViewController? {
        didSet {
           
        }
    }
    
    var datas: [CPHeaderItem]? {
        didSet {
            guard datas?.count != 0 else {
                return
            }
            for i in 0..<num {
                let item: CPHeaderItem = datas![i]
                
                let imageView: UITapImageView = itemViews[i] as! UITapImageView
                
                imageView.setImageWith(URL(string: item.img), placeholderImage: #imageLiteral(resourceName: "article_cell"), tap: { (obj) in
                    print("\(item.title)")
                    let detailVc = PaintDetailController()
                    detailVc.webUrl = WebTimeStamp.webUrl(withTimeStamp: item.url)
                    detailVc.titleType = WebTitleType(rawValue: UInt(0))!
                    self.currentVc?.navigationController?.pushViewController(detailVc, animated: true)
                })
            }
        }
    }
    
    
    lazy var itemViews: NSMutableArray = {
        let array = NSMutableArray()
        for i in 0..<num {
            let imageView = UITapImageView()
            imageView.contentMode = .scaleAspectFill
            
            let indexX: CGFloat = CGFloat(i%5)
            let indexY: CGFloat = CGFloat(i/5)
            imageView.frame = CGRect(x:CPHeaderItemLeftPadding+indexX*(CPHeaderItemWidth+CPHeaderItemLeftPadding),y:CPHeaderItemTopPadding+indexY*(CPHeaderItemWidth+CPHeaderItemPadding),width:CPHeaderItemWidth,height:CPHeaderItemWidth)
            imageView.layer.cornerRadius = imageView.width/2
            imageView.clipsToBounds = true
            array.add(imageView)
            self.addSubview(imageView)
        }
        return array
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

