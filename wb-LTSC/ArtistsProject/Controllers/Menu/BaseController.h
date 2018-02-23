//
//  BaseController.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UserInfoModel.h"
typedef void(^BaseBlock)(NSString *string);

@interface BaseController : UIViewController<MBProgressHUDDelegate>
///加载指示器
@property(nonatomic,strong) MBProgressHUD *hudLoading;

///自定义指示器
@property(nonatomic,strong) MBProgressHUD *hudCustom;
@property(nonatomic,strong) UserInfoModel * model;
// block
@property (nonatomic, copy) BaseBlock block;

- (void)showOkHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle Complete:(void (^)())complete;

- (void) showLoadingHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle;
- (void) showErrorHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle Complete:(void(^)())complete;
- (BOOL)showCheckErrorHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle checkTxtField:(UITextField*)txt;

-(void)hideHUD;

- (NSArray*)stringToJSON:(NSString*)jsonStr;
- (NSString*)objArrayToJSON:(NSArray*)array;
- (NSDictionary*)parseJSONStringToNSDictionary:(NSString*)JSONString;
- (NSString*)getVideoIDWithVideoUrl:(NSString*)strVideo;

- (void)hideKeyBoard;
- (BOOL)isNavLogin;//判断登录
-(void)logonAgain;//重新登录
- (NSString*)urlEncodedString:(NSString*)string;
@end
