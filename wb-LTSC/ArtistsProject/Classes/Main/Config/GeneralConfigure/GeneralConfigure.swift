//
//  GeneralConfigure.swift
//  meishubao
//
//  Created by LWR on 2016/11/15.
//  Copyright © 2016年 benbun. All rights reserved.
//

import UIKit
import Foundation
//import LKDBHelper

let CHECKPHONENUM = "^((12[0-9])|(13[0-9])|(14[6-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$" // 统一检验手机号正则
let CHECKEMAIL = "^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$" // 统一检验邮箱正则
let CHECKPWD = "^[0-9A-Za-z]{6,16}$" // 统一检验密码(6-16)

func PrintLog<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
        print("\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息:\n\(message)");
    #endif
}
let APP_NIGHT_MODE = "APP_NIGHT_MODE"
let APP_OFFLINE_MODE = "APP_OFFLINE_MODE"
let APP_WIFI_PHOTO_MODE = "APP_WIFI_PHOTO_MODE"
//APP分享相关
let APP_SHARE_TITLE = "中国美术报"
let APP_SHARE_DESC = "弘扬中国美术精神，彰显中国美术气派，建立中国美术标准，创新中国美术风格。"
let APP_SHARE_URL = "http://a.app.qq.com/o/simple.jsp?pkgname=com.meishubao.app"

// 屏幕高
let ScreenH =  UIScreen.main.bounds.height
// 屏幕宽
let ScreenW = UIScreen.main.bounds.width
// 屏幕尺寸
let Screen  = UIScreen.main.bounds

// tabbar高度
let APP_TABBAR_HEIGHT: CGFloat = 49

// 数据库操作者
let dbHelper  = BaseModel.getUsingLKDBHelper()

// iPhone 4s
let isIPhone4 = ScreenH == 480 ? true : false
// iPhone 5
let isIPhone5 = ScreenH == 568 ? true : false
// iPhone 6
let isIPhone6 = ScreenH == 667 ? true : false
// iPhone 6P
let isIPhone6P = ScreenH == 736 ? true : false

//iPhone X
let isIPhoneX = ScreenH == 812 ? true : false

// 导航高度
let APP_NAVIGATIONBAR_HEIGHT: CGFloat = isIPhoneX ? 88 : 64
let iPhoneXBottomHeight: CGFloat = 34

func RGBColor(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    let color: UIColor = UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    return color
}

func RGBAColor(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    let color: UIColor = UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    return color
}
//文章列表样式类型
let HeadLineTypeGenneral:NSInteger = 1//普通类型
let HeadLineTypeImages  :NSInteger = 2//多图
let HeadLineTypeAds     :NSInteger = 3//广告
let HeadLineTypeVideo   :NSInteger = 4//广告

//轮播图类型
let SDCycleImageTypeArticle:NSInteger = 1//文章
let SDCycleImageTypeUrl:NSInteger = 2//链接
let SDCycleImageTypeNone:NSInteger = 3//仅图片

// 基础背景色
let APP_COMMONT_BG_COLOR: UIColor = RGBColor(238, g: 238, b: 238)

// 通用tabBarItem和navigaitonBar背景色
let APP_TABBARITEM_SELET_COLOR = UIColor.colorWithHex(0xB51B20)
let APP_TABBARITEM_NORMAL_COLOR = UIColor.colorWithHex(0x989898)
// 按钮背景图片
let NORMAL_BUTTON_IMAGE = UIImage.hyg_image(with: UIColor.colorWithHex(0xb51b20))
let NIGHT_BUTTON_IMAGE = UIImage.hyg_image(with: UIColor.colorWithHex(0x6f141a))
let HIGHLIGHT_BUTTON_IMAGE = UIImage.hyg_image(with: UIColor.colorWithHex(0x5c090f))


// 统一设置夜间模式颜色 (normal, night)
/*! 统一单元格分割线 */
let separatorColorPicker = DKColorSwiftWithRGB(0xe7e7e7, 0x454545)

/*! 统一tabBar背景色 */
let barTintColorPicker = DKColorSwiftWithRGB(0xECECEC, 0x3D3C3C)

/*! 统一Cell背景色 */
let cell_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x222222)

/*! 统一HeaderView背景色 */
let headerView_backgroundColorPicker = DKColorSwiftWithRGB(0xE8E8E8, 0x222222)

/*! 统一Tableview背景色 */
let tableView_backgroundColorPicker = DKColorSwiftWithRGB(0xDCDCDC, 0x1c1c1c)

/*! 统一topBar背景色 */
let topBar_backgroundColorPicker = DKColorSwiftWithRGB(0xe0e0e0, 0x222222)

