//
//  SDCycleModel.swift
//  meishubao
//
//  Created by LWR on 2016/11/23.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class SDCycleModel: NSObject {
    var tid: String = ""
    var post_title: String = ""
    var url: String = ""
    var type: NSString = ""
    
    var post_image: String? {     // 图片
        didSet {
            post_image = post_image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            post_image = post_image! + "?imageslim"
        }
    }

}
