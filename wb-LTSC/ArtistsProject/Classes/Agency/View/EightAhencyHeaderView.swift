//
//  EightAhencyHeaderView.swift
//  meishubao
//
//  Created by LWR on 2016/11/23.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class EightAhencyHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collection)
        backgroundColor = UIColor.clear
    }
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing  = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.width / 3.0, height: 60)
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height), collectionViewLayout: layout)
        
        collection.register(EightAgencyCell.self, forCellWithReuseIdentifier: eightAgencyCellID)
        
        collection.backgroundColor = UIColor.clear
        collection.dataSource = self
        
        return collection
    }()
    
    var eightArr: [AgencyHeaderModel]? {
        didSet {
            collection.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
            collection.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EightAhencyHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let eightArr = eightArr  else {
            return 0
        }
        return eightArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eightAgencyCellID, for: indexPath) as! EightAgencyCell
        cell.model = eightArr?[indexPath.row]
        return cell
    }
}
