//
//  Global.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UserInfoModel.h"
#import "AddressModel.h"


@interface Global : NSObject
+(instancetype)sharedInstance;
@property(nonatomic,assign)BOOL ishideMoney;//是否隐藏钱包 和 赞赏功能
@property(nonatomic,assign)BOOL isHideState;//记录状态栏是否为隐藏状态

///当前用户ID
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,copy)NSString* shareId;//所分享的动态的发布者的id
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *auth;//身份
@property (nonatomic, strong) NSString *isgroup;//编辑管理用户组
@property (nonatomic, strong)AddressModel * addressModel;//默认地址本地存储
///当前用户个人信息
@property(nonatomic,strong) UserInfoModel *userInfo;
//上次首页强制更新时间
@property(nonatomic,strong) NSDate *refreshTime;
//上次轮播图显示时间
@property(nonatomic,strong) NSDate *adRefreshTime;
//版本更新之前的版本号
@property(nonatomic,strong) NSNumber *lastVer;
//是否已经上架成功s
@property(nonatomic,strong) NSString *inStore;
@property (strong, nonatomic) NSMutableArray *arraySearchHistory;

@property(nonatomic, readwrite) int lastPostionUpdateTime;
@property(nonatomic, readwrite) CLLocationCoordinate2D currentPostion;
- (void) Logout;

- (NSString*)dictionaryToJson:(NSDictionary *)dic;
- (UIFont*) fontWithSize:(CGFloat)size;
-(NSString*)getBundleID;
-(NSString*)getBundleName;
-(NSString*)getAAABundleName;


//添加草稿箱数据
-(void)addCaoGao:(NSDictionary *)dicCaogao;
//删除草稿箱数据
-(void)delCaoGao:(NSString *)caogaoID;

// 判断手机号有效性
- (BOOL)isValidateMobile:(NSString *)mobile;


@end

