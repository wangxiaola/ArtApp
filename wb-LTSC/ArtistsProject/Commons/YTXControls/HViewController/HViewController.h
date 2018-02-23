//
//  HViewController.h
//  Hospital
//
//  Created by by Heliulin on 15/5/19.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <UIScrollView+EmptyDataSet.h>

@interface HViewController : UIViewController<MBProgressHUDDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
typedef enum{
    HNoDataModeDefault,
    HNoDataModeNoSearchResult,
    HNoDataModeNoCartData,
    HNoDataModeNoOrderData
}HNoDataMode;
//导航栏高度
@property(nonatomic,readwrite) CGFloat navBarHight;
///导航栏加状态栏高度
@property(nonatomic,readwrite) CGFloat navBottomY;
///加载指示器
@property(nonatomic,strong) MBProgressHUD *hudLoading;
///自定义指示器
@property(nonatomic,strong) MBProgressHUD *hudCustom;
//无数据类型
@property (nonatomic, readwrite) HNoDataMode noDataMode;
@property (nonatomic, assign) BOOL isHome;
@property(nonatomic,assign)BOOL isHideTab;//是否隐藏tab


@property(nonatomic,readwrite) BOOL isFristLaunch;
- (void) showLoadingHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle;
- (void) showOkHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle Complete:(void(^)())complete;
- (void) showErrorHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle Complete:(void(^)())complete;


- (void) showOkHUDNotAutoHideWithTitle:(NSString*)title SubTitle:(NSString*)subTitle;
- (void) showErrorHUDNotAutoHideWithTitle:(NSString*)title SubTitle:(NSString*)subTitle;
- (void) hideKeyBoard;

- (BOOL) showCheckErrorHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle checkTxtField:(HTextField *)txt;
- (BOOL) isLogin;
-(void)logonAgain;
- (BOOL) isNavLogin;
- (NSString*)dictionaryToJson:(NSDictionary *)dic;
- (NSArray *)stringToJSON:(NSString *)jsonStr;
- (NSString *)objArrayToJSON:(NSArray *)array;
-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;
-(NSString *)getVideoIDWithVideoUrl:(NSString *)strVideo;
- (NSString*)urlEncodedString:(NSString *)string;
- (NSArray *)stringToJSON1:(NSString *)jsonStr ;
@end
