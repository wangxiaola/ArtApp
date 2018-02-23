//
//  ArticleCategoryModel.swift
//  meishubao
//
//  Created by LWR on 2016/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class ArticleCategoryModel: NSObject, NSCoding {
    var term_id: String = ""
    var name   : String = ""
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.term_id, forKey: "term_id")
        aCoder.encode(self.name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.term_id = aDecoder.decodeObject(forKey: "term_id") as! String
    }
    
    override init() {
        
    }
}


