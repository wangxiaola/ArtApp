//
//  ArticleModel.swift
//  meishubao
//
//  Created by LWR on 2016/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//
//  首页文章模型

import UIKit

class ArticleModel: NSObject {
    var post_id: String = ""      // 文章id
    var post_title: String = ""   // 文章标题
    var post_excerpt: String = "" // 摘要
    var term: String = ""         // 分类
    var author: String = ""       // 作者
    var post_date: String? = ""
    var clicked_time: String? = ""// 点击时间
    var post_type: String = ""    // 1, 普通 2, 图集 3, 广告
    
    //最热展览
    var city: String = ""
    var medium: String = ""
    var start_time: String = ""
    var end_time: String = ""
    
    //广告
    var ad_name:String = ""
    var ad_content:String = ""
    var ad_url:String = ""
    var ad_image:String? {
        didSet {
            guard let adImage = ad_image else {
                ad_image = ""
                return
            }
            if adImage.hasSuffix(".jpg") || adImage.hasSuffix(".png") {
                ad_image = ad_image! + "?imageslim"
            }else {

                ad_image = ad_image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            }
        }
    }
    
    var smeta:[ArticleImageModel] = []
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["smeta":ArticleImageModel.self]
    }
    
    // 圆桌会
    var video: String = ""        // 视频地址
    var duration: String? {       // 视频时长(ms)
        didSet {
            guard let time = duration else {
                return
            }
            var time2 = NSString(string: time).floatValue
            time2 /= 1000
            
            duration = TimeStamp.timeStampToTime(timeStamp: "\(time2)", dateFormat: "mm:ss")
        }
    }
    var video_view: String = ""   // 浏览量
    
    var post_image: String? {     // 图片
        didSet {
            guard let postImage = post_image else {
                post_image = ""
                return
            }
            if postImage.hasSuffix(".jpg") || postImage.hasSuffix(".png") {
                post_image = post_image! + "?imageslim"
            }else {

                post_image = post_image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            }
        }
    }
    var comment_num: String?
    {    // 评论数
        didSet {
            guard let num = comment_num else {
                return
            }
            PrintLog(message: "评论数: \(num)");
            //let num1 = NSString(string: num)
            comment_num = comment_num! + "评论"
//            if num1.intValue > 999 {
//                comment_num = "999+评论"
//            }else {
//                comment_num = comment_num! + "评论"
//            }
        }
    }
    var attention_num: String?
//    {  // 关注数
//        didSet {
//            guard let num = attention_num else {
//                return
//            }
//            let num1 = NSString(string: num)
//            if num1.intValue > 999 {
//                attention_num = "999+"
//            }else {
//                attention_num = num
//            }
//        }
//    }

    var rowHeight: CGFloat? {
        get {
            let postType = NSString(string:post_type)
            if postType.integerValue == HeadLineTypeImages {
                let size = NSString.size(withText: post_title, font: UIFont.systemFont(ofSize: 16), maxSize: CGSize(width: ScreenW-leftPadding*2, height:999999))
                if smeta.count != 0 {
                    return topPadding*4+size.height+imageHeight+20
                }else{
                    return topPadding*3+size.height+20
                }
            }else if postType.integerValue == HeadLineTypeAds{
                if ad_content.isEmpty || ad_content == "" {
                    return topPadding * 3 + adImageHeight+15
                }
                let size = NSString.size(withText: ad_content, font: UIFont.systemFont(ofSize: 16), maxSize: CGSize(width: ScreenW-leftPadding*2, height:999999))
                return topPadding*4+size.height+adImageHeight+15
            }else{
                return ScreenW * 96.5 / 375.0
            }
        }
    }
}

