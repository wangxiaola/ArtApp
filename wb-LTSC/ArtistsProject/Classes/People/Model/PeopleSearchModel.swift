//
//  PeopleSearchModel.swift
//  meishubao
//
//  Created by LWR on 2016/12/20.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
//import LKDBHelper

class PeopleSearchModel: NSObject {
    var searchText: String = "" // 搜索关键字
    
    override static func getPrimaryKey() -> String {
        return "searchText"
    }
    
    override static func getTableName() -> String {
        return "people_search_t"
    }
}
