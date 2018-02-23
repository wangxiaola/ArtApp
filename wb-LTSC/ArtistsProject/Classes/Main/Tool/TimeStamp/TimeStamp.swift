//
//  TimeStamp.swift
//  meishubao
//
//  Created by LWR on 2016/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit

class TimeStamp: NSObject {
    /*!
     @brief 时间戳(String) -> 时间(String)
     @param timeStamp 时间戳
     @param dateFormat 时间格式
     */
    class func timeStampToTime(timeStamp: String, dateFormat: String) -> String {
        let string = NSString(string: timeStamp) 
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = dateFormat
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return dfmatter.string(from: date as Date)
    }
    
    /*!
     @brief 判断是否是最新推荐
     @param timeStamp 时间戳
     */
    class func judgeLatestWith(timeStamp: String) -> Bool {
        
        let now  = Date().timeIntervalSince1970 * 1000
        if now - Double(timeStamp)! * 1000 < 24 * 60 * 60 * 1000 {
            
            return true
        }else {
        
            return false
        }
    }
}
