//
//  ArtMacro.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#ifndef ArtMacro_h
#define ArtMacro_h


#endif /* ArtMacro_h */
#if DEBUG
#define ARTLog(FORMAT, ...) fprintf(stderr,"\nLog:%s on line:%d \n-->%s", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define ARTLog(FORMAT, ...) nil
#endif

// 打印输出
#ifdef DEBUG
#define kPrintLog(paramater)   NSLog(@"%@",paramater);
#define kPrintAllLog(...)      NSLog(@"paramater: %@", [NSString stringWithFormat:__VA_ARGS__]);
#define kPrintDetailLog(format, ...) do {                         \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#define kPrintAllLog(...)
#define kPrintLog(paramater)
#define kPrintDetailLog(format, ...)
#endif

//-------------------获取设备大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44
#define StatusBar_HEIGHT 20

// 屏幕
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define CELL_HEIGHT (self.bounds.size.height)
#define CELL_WIDTH (self.bounds.size.width)
#define KEY_WINDOW [[UIApplication sharedApplication]keyWindow]
#define TRUEW(v) (v*(SCREEN_WIDTH)/320)
//获取window
#define getWindow [[UIApplication sharedApplication] keyWindow]
//获取delegate
#define getDelegate [[UIApplication sharedApplication] delegate]
#define SharedApplication  [UIApplication sharedApplication]
#define UserDefaults   [NSUserDefaults standardUserDefaults]
#define SharedNotifiCenter                  [NSNotificationCenter defaultCenter]

//获取指定view高度
#define getViewHeight(v) (v.frame.size.height+v.frame.origin.y)
#define getViewWidth(v) (v.frame.size.width+v.frame.origin.x)
#define T_WIDTH(v) (v*(SCREEN_WIDTH)/320)
#define T_HEIGHT(v) (v*(SCREEN_HEIGHT)/568)
#define Rect(x, y, w, h)  CGRectMake(TRUEW(x), TRUEH(y), TRUEW(w), TRUEH(h))

#define UserDefaults    [NSUserDefaults standardUserDefaults]

#define IOSVersion     [[[UIDevice currentDevice] systemVersion] floatValue]
#define ISIOS7Later                         !(IOSVersion <= 7.0)
#define ISIOS8Later                         !(IOSVersion <= 8.0)

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define BACK_VIEW_COLOR RGB(245,245,245)
#define BACK_CELL_COLOR RGB(240,240,240)
#define CELL_LINE_COLOR RGB(200,200,200)

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height
#define kPageSize @"10"
#define kPayKey @"=3x+Z3ZV"

#define kDEFAULT_BUCKET @"artartimages"
#define kDEFAULT_PASSCODE @"vEhiz1+W4S7p5fSPAUFtigbCAgw="
#define kMutAPIDomain @"http://img.artart.cn"
//http://img.artart.cn/uploads/audio/art1284/2017/05/05/1493981936.mp3

//#define kRongCloudIMAppKey @"8brlm7ufrneu3"//debug
#define kRongCloudIMAppKey @"lmxuhwagxbtad"//release [[Global sharedInstance]fontWithSize:15]

//#define kAMapApiKey @"da49a2e08c6d50a4e5ecba70e668483e"//debug
//#define kAMapApiKey @"8394e2d316c046113ce0f4c610945775"//inhouse
#define kAMapApiKey @"7824f62b67c28dccf020b8b80c508467"//release


//#define kJPushApiKey @"f33640f94ab6fbb50fcb42b9"//debug
//#define kJPushApiKey @"f66495fd6fc1b14897ee8fa0"//inhouse
#define kJPushApiKey @"039eed5a8320ffddd595f9b9"//release


#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define PH_COLOR_BUTTON_BORDER RGB(196,196,196)
#define PH_COLOR_TEXT_COMMON RGB(27,27,27)
#define Art_Line_HEIGHT 0.5
#define Art_LineColor [UIColor colorWithRed:222./255. green:222./255. blue:222./255. alpha:1.]
#define kLineColor [UIColor colorWithHexString:@"#d5d5d5"]
#define kMidLineColor [UIColor colorWithHexString:@"#e7e7e7"]
#define kPriceColor [UIColor colorWithHexString:@"#e30000"]
#define kTitleColor [UIColor colorWithHexString:@"#333333"]
#define kSubTitleColor [UIColor colorWithHexString:@"#838383"]
#define kBlueColor [UIColor colorWithHexString:@"#06a1f2"]
#define kPurpleColor [UIColor colorWithHexString:@"#cf02b9"]
#define kYellowColor [UIColor colorWithHexString:@"#fed152"]
#define kOrangeColor [UIColor colorWithHexString:@"#f1a954"]
#define kRedColor [UIColor colorWithHexString:@"#cb0500"]
#define kWhiteColor [UIColor whiteColor]
#define kClearColor [UIColor clearColor]
#define kStarColor [UIColor colorWithHexString:@"#d1ab30"]
#define kLineHotColor [UIColor colorWithHexString:@"#bbbbbb"]
#define kZANLABELColor [UIColor colorWithHexString:@"#3399cc"]

#define kColore7e7e7            [UIColor hexChangeFloat:@"e7e7e7"]

#define kColor0 [UIColor colorWithHexString:@"#f6f6f6"]
#define kColor1 [UIColor colorWithHexString:@"#cf02b9"]
#define kColor2 [UIColor colorWithHexString:@"#d21c47"]
#define kColor3 [UIColor colorWithHexString:@"#666666"]
#define kColor4 [UIColor colorWithHexString:@"#999999"]
#define kColor5 [UIColor colorWithHexString:@"#f65f82"]
#define kColor6 [UIColor colorWithHexString:@"#000000"]
#define kColor7 [UIColor colorWithHexString:@"#333333"]
#define kColor8 [UIColor colorWithHexString:@"#888888"]
#define kColor9 [UIColor colorWithHexString:@"#e8e8e8"]
#define kColor10 [UIColor colorWithHexString:@"#aaaaaa"]
#define kColor11 [UIColor colorWithHexString:@"#666666"]
#define kColor12 [UIColor colorWithHexString:@"#999999"]
#define kColor13 [UIColor colorWithHexString:@"#d21c47"]
#define kColor14 [UIColor colorWithHexString:@"#e1c562"]
#define kColor15 [UIColor colorWithHexString:@"#f4f4f4"]
#define kColor16 [UIColor colorWithHexString:@"#d38b00"]
#define kColor17 [UIColor colorWithHexString:@"#e47b00"]
#define kColor18 [UIColor colorWithHexString:@"#e2e2e2"]
#define kColor19 [UIColor colorWithHexString:@"#ffd154"]
#define kColor20 [UIColor colorWithHexString:@"#efc11f"]
#define kColor21 [UIColor colorWithHexString:@"#fafafa"]
#define kColor22 [UIColor colorWithHexString:@"#d1aa30"]
#define kColor23 [UIColor colorWithHexString:@"#e2c662"]
#define kColor24 [UIColor colorWithHexString:@"#d5ba5c"]
#define kColor25 [UIColor colorWithHexString:@"#e6e6e6"]
#define kColor26 [UIColor colorWithHexString:@"#f7f7f7"]
#define kColor27 [UIColor colorWithHexString:@"#b38e0d"]
#define kColor28 [UIColor colorWithHexString:@"#e0c461"]
#define kColor29 [UIColor colorWithHexString:@"#be8600"]
#define kColor30 [UIColor colorWithHexString:@"#d8d8d7"]
#define kColor31 [UIColor colorWithHexString:@"#ffda58"]

//#define ARTFONT_TT (T_WIDTH(22))
//#define ARTFONT_OT (T_WIDTH(12))
//#define ARTFONT_OZ (T_WIDTH(10))
//#define ARTFONT_OE (T_WIDTH(18))
//#define ARTFONT_OF (T_WIDTH(14))

#define ARTFONT_TT 22
#define ARTFONT_TZ 20
#define ARTFONT_OE 18
#define ARTFONT_OFI 15
#define ARTFONT_OF 14
#define ARTFONT_OTH 13
#define ARTFONT_OT 12
#define ARTFONT_OZ 10
#define ARTFONT_E 6.5
//PingFangSC-Ultralight  PingFangSC-Light
#define kFont(font) [[Global sharedInstance]fontWithSize:font]
#define ART_FONT(F) [UIFont fontWithName:@"PingFang-SC-Light" size:F]//细体
//#define ART_FONT(F) [UIFont fontWithName:@"PingFangSC-Regular" size:F]//常规

//重写NSLog,Debug模式下打印日志和当前行数 -Start be8600


//优酷
#define DEVICE_TYPE_IPAD ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
#define youKuclientId @"e7b7e2b85d590387"
#define youKuclientSecret @"cc74658b2df9a05ffd257eed24c6f7ad"

//public final static String youku_appKey = "b402d3dc7caf288c";
//public final static String youku_secret = "4dcd8a8baba3c88c285af8bfd7275007";
//
//public final static String tudou_appKey = "b82229aba07962c4";
//public final static String tudou_secret = "80714707a2a95be137250c195612dac6";


//自定义屏幕尺寸
#define KKWidth(pixel) DeviceSize.width / 640 * pixel
//  屏幕的frame
#define DeviceFrame [UIScreen mainScreen].bounds
//  屏幕的size
#define DeviceSize [UIScreen mainScreen].bounds.size


#define KeyWindow [UIApplication sharedApplication].keyWindow
#define ImageNamed(parameter) [UIImage imageNamed:parameter]
#define kWeakSelf   __weak typeof(self)  weakSelf = self;

// 缩放比
#define kScale ([UIScreen mainScreen].bounds.size.width) / 414

#define hScale ([UIScreen mainScreen].bounds.size.height-64) / 736

// 友盟推送
#define  UMPushAppKey  @"5989f80f07fe65046b001377"
#define UMPushAppMasterSecret @"qiku8jidyhekw4w6mj3kiarbp4qncmeh"
#define UMPushType     @"allalias"
#define UMPushTag     @"alltag"
// 分享
#define wechatAppID  @"wx09435b6cf2d9876a"
#define wechatAppSecret  @"63bfdea8a37f7a54bc53fff11e22c7b9"
#define QQAppID  @"ID1106156483"
#define QQAppSecret  @"KEYlRdXgeOqqLhsILqI"
#define weiboAppID  @"3671016885"
#define weiboAppSecret  @"5c87871f3b574d7663587045e070a030"
#define shareAppID @"1e6ea8a6ff228"
#define shareAppSecret @"ee6c388575cb278f77bf67fc16323afb"

// 支付宝scheme
#define kAppScheme   @"lotuschen"



//rgb颜色
#import "UIColor+UIRBG.h"
#define  COLOR_FROM_RGB(rgb,alpha1)  [UIColor mgColorWithRGB:(rgb) alpha:(alpha1)]
/***分割线***/
#define ST_SEPERATE_LINE_COLOR  COLOR_FROM_RGB(@"#cccccc" , 1.0f)

#define kShareTitle @"关注艺术收藏，请下载“劳特斯辰APP” 点击此链接：http://dwz.cn/lotuschen"

