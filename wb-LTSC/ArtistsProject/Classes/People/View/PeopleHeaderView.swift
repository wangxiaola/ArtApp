//
//  PeopleHeaderView.swift
//  meishubao
//
//  Created by LWR on 2016/11/18.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import SnapKit

class PeopleHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collection)
        layer.addSublayer(lineOne)
        layer.addSublayer(lineTwo)
        layer.addSublayer(lineThree)
        layer.addSublayer(lineFour)
        layer.addSublayer(lineFive)
        
        collection.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        let xOne = (ScreenW / 3.0) - 0.5
        let xTwo = 2 * xOne
        
        lineOne.frame = CGRect(x: 14, y: 74 - 0.5, width: ScreenW - 28, height: 0.5)
        lineTwo.frame = CGRect(x: xOne, y: 13.5, width: 0.5, height: 50)
        lineThree.frame = CGRect(x: xTwo, y: 13.5, width: 0.5, height: 50)
        lineFour.frame = CGRect(x: xOne, y: 85.5, width: 0.5, height: 50)
        lineFive.frame = CGRect(x: xTwo, y: 85.5, width: 0.5, height: 50)
    }
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing  = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: ScreenW / 3.0, height: 74.25)
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height), collectionViewLayout: layout)
        collection.bounces = false
        collection.register(PeopleHeaderCell.self, forCellWithReuseIdentifier: peopleHeaderCellID)
        
        collection.dk_backgroundColorPicker = cell_backgroundColorPicker
        collection.dataSource = self
        
        return collection
    }()
    
    var peopleArr: [PeopleModel]? {
        didSet {
            collection.reloadData()
            
            var collectionViewH: CGFloat = 74.0
            if peopleArr?.count == 1 {
                lineTwo.isHidden = false
            }else if peopleArr?.count == 2 {
                lineTwo.isHidden = false
                lineThree.isHidden = false
                lineOne.isHidden = true
                lineFour.isHidden = true
                lineFive.isHidden = true
            }else if peopleArr?.count == 3 {
                lineTwo.isHidden = false
                lineThree.isHidden = false
                lineOne.isHidden = true
                lineFour.isHidden = true
                lineFive.isHidden = true
            }else if peopleArr?.count == 4 {
                collectionViewH = 148.0
                lineTwo.isHidden = false
                lineOne.isHidden = false
                lineThree.isHidden = false
                lineFour.isHidden = false
                lineFive.isHidden = true
            }else if peopleArr?.count == 5 {
                collectionViewH = 148
                lineTwo.isHidden = false
                lineOne.isHidden = false
                lineThree.isHidden = false
                lineFour.isHidden = false
                lineFive.isHidden = false
            }else if (peopleArr?.count)! >= 6 {
                collectionViewH = 148
                lineTwo.isHidden = false
                lineOne.isHidden = false
                lineThree.isHidden = false
                lineFour.isHidden = false
                lineFive.isHidden = false
            }
            
            self.collection.snp.remakeConstraints { (make) in
                make.left.right.top.equalTo(self)
                make.height.equalTo(collectionViewH)
            }
        }
    }
    
    // 五根分割线
    lazy var lineOne: CAShapeLayer = {
        let lineOne = CAShapeLayer()
        lineOne.dk_backgroundColorPicker = separatorColorPicker
        lineOne.isHidden = true
        
        return lineOne
    }()
    
    lazy var lineTwo: CAShapeLayer = {
        let lineTwo = CAShapeLayer()
        lineTwo.dk_backgroundColorPicker = separatorColorPicker
        lineTwo.isHidden = true
        
        return lineTwo
    }()
    
    lazy var lineThree: CAShapeLayer = {
        let lineThree = CAShapeLayer()
        lineThree.dk_backgroundColorPicker = separatorColorPicker
        lineThree.isHidden = true
        
        return lineThree
    }()
    
    lazy var lineFour: CAShapeLayer = {
        let lineFour = CAShapeLayer()
        lineFour.dk_backgroundColorPicker = separatorColorPicker
        lineFour.isHidden = true
        
        return lineFour
    }()
    
    lazy var lineFive: CAShapeLayer = {
        let lineFive = CAShapeLayer()
        lineFive.dk_backgroundColorPicker = separatorColorPicker
        lineFive.isHidden = true
        
        return lineFive
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PeopleHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let peopleArr = peopleArr  else {
            return 0
        }
        return peopleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: peopleHeaderCellID, for: indexPath) as! PeopleHeaderCell
        cell.model = (peopleArr?[indexPath.row])!
        return cell
    }
}
