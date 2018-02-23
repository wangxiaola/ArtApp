//
//  PeopleModel.swift
//  meishubao
//
//  Created by LWR on 2016/12/6.
//  Copyright © 2016年 benbun. All rights reserved.
// 
//  人物首页顶部八个人物模型

import UIKit

class PeopleModel: NSObject {
    var artist_id: String = ""  // 艺术家id
    var artist_position: NSArray? {//人物职位数组
        didSet{
            guard artist_position?.count != 0 else {
                return;
            }
            let ss: NSString = artist_position?[0] as! NSString
            
            let posiStr = NSMutableString(string:ss)
            
            let count: Int  = (artist_position?.count)!
            for i in 1..<count {
                posiStr.append(",\((artist_position?[i])!)")
            }
            positionStr = posiStr as String
        }
    }       // 身份
    var name: String = ""       // 姓名
    var photo: String = ""      // 头像
    var intro: String = ""      // 简介
    var positionStr: String = "" //人物职位字符串形式
}
