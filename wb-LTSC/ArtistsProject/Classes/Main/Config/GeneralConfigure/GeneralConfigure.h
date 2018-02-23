//
//  GeneralConfigure.h
//  meishubao
//
//  Created by LWR on 2016/11/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#ifndef GeneralConfigure_h
#define GeneralConfigure_h

#import "ArtistsProject-Swift.h"
#import "DKNightVersion.h"
#import "NSObject+Extension.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "LLRequestServer.h"
#import "NSString+ToString.h"
#import "YPTabBarController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MSBAccount.h"
#import "MSBWebLoading.h"
#import "JPUSHService.h"
#import "SDPhotoBrowser.h"
#import "MSBJumpLoginVC.h"
#import "LKDBHelper.h"
#import "SDCycleScrollView.h"
#import "UIButton+LXMImagePosition.h"
#import "UIImage+Common.h"
#import "MSBCustomBtn.h"
#import "UIImage+HYGExtension.h"

//#define API_CONFIG_LOCAL_FILE @"EXT_MOCK" // 假数据调试
//#define API_CONFIG_LOCAL_FILE @"LAN_DEV" // 局域网调试
#define API_CONFIG_LOCAL_FILE @"EXT_RELEASE" // 上线版本
//#define API_CONFIG_LOCAL_FILE @"EXT_TEST" // 测试接口


#define APP_NIGHT_MODE @"APP_NIGHT_MODE"
#define APP_OFFLINE_MODE @"APP_OFFLINE_MODE"
#define APP_WIFI_PHOTO_MODE @"APP_WIFI_PHOTO_MODE"

//判断是否是夜间模式
#define isNightMode [[NSUserDefaults standardUserDefaults] boolForKey:APP_NIGHT_MODE]&&[[NSUserDefaults standardUserDefaults] boolForKey:APP_NIGHT_MODE] == YES
#define APP_NIGHT_BG_COLOR @"#1c1c1c"//夜间模式背景色
#define APP_NIGHT_TEXT_COLOR @"#909090"//夜间模式字体色
#define THEME_NORMAL [self.dk_manager.themeVersion isEqualToString:@"NORMAL"]
//统一单元格间隔线颜色
#define CellLineColor DKColorPickerWithRGB(0xe7e7e7, 0x454545)
// 按钮背景图片
#define NORMAL_BUTTON_IMAGE [UIImage hyg_imageWithColor:[UIColor colorWithHex:0xb51b20]]
#define NIGHT_BUTTON_IMAGE [UIImage hyg_imageWithColor:[UIColor colorWithHex:0x6f141a]]
#define HIGHLIGHT_BUTTON_IMAGE [UIImage hyg_imageWithColor:[UIColor colorWithHex:0x5c090f]]

/**user*/
#define APP_ACCESS_TOKEN @"APP_ACCESS_TOKEN"
#define APP_USER_PATH   [kDocumentsPath stringByAppendingPathComponent:MSBUserAccount]
#define kDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define MSBUserAccount @"MSBUserAccount"

//#define MSBUser_Tourists @"MSBUser_Tourists"

#define MSBADSHOW @"MSBADSHOW"

#define JPUSH_REGISTRATIONID @"JPUSH_REGISTRATIONID"

/**Font*/
#define APP_WEBVIEW_FONTSIZE @"APP_WEBVIEW_FONTSIZE"
/**大小*/
#define APP_WEB_FONTNAME @"APP_WEB_FONTNAME"
/**Log*/
#ifdef DEBUG
#define NDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NDLog(FORMAT, ...) nil
#endif

/*字符串size*/
#define AP_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

#define AP_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;


#define isiPhoneX SCREEN_HEIGHT == 812 || SCREEN_WIDTH == 812
#define iPhoneXBottomHeight 34
#define kBottomHeight (isiPhoneX?83:49)

#define APP_NAVIGATIONBAR_H (SCREEN_HEIGHT == 812?88:64)
#define APP_SEGMENT_H 40
#define RGBCOLOR(r,g,b)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0f]
#define RGBALCOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#endif /* GeneralConfigure_h */
