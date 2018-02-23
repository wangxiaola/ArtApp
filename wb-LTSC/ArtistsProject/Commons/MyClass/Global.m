//
//  Global.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "Global.h"

@implementation Global
/**
 步骤:
 1.一个静态变量_inastance
 2.重写allocWithZone, 在里面用dispatch_once, 并调用super allocWithZone
 3.自定义一个sharedXX, 用来获取单例. 在里面也调用dispatch_once, 实例化_instance
 -----------可选------------
 4.如果要支持copy. 则(先遵守NSCopying协议)重写copyWithZone, 直接返回_instance即可.
 */
/**第1步: 存储唯一实例*/
static Global *_instance;

/**第2步: 分配内存空间时都会调用这个方法. 保证分配内存alloc时都相同*/
+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

/**第3步: 保证init初始化时都相同*/
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[Global alloc] init];
    });
    return _instance;
}

/**第4步: 保证copy时都相同*/
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

- (NSString*)userID
{
    if (![[TMCache sharedCache] objectForKey:@"userID"]) {
        return nil;
    }else {
        
        return [NSString stringWithFormat:@"%@", [[TMCache sharedCache] objectForKey:@"userID"]];
    }
}//
-(NSString*)getBundleID{
    //TODO
    NSString* str = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSArray* arr = [str componentsSeparatedByString:@"."];
    return @"1060";
//    return [NSString stringWithFormat:@"%@",arr[2]];
}

-(NSString*)getBundleName{
    //TODO
    NSString* str = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return str.length>0?str:@" ";
}

-(void)setAuth:(NSString *)auth{
    [[TMCache sharedCache] setObject:auth forKey:@"auth"];
}

-(NSString *)auth{
    return [[TMCache sharedCache] objectForKey:@"auth"];
}

-(void)setUserID:(NSString *)userID{
    [[TMCache sharedCache] setObject:userID forKey:@"userID"];
}

-(NSString *)token{
    return  [[TMCache sharedCache] objectForKey:@"token"]; //@"zl1rDGTN";//
}

-(void)setToken:(NSString *)token{
    [[TMCache sharedCache] setObject:token forKey:@"token"];
}

- (NSString*) userType
{
    return [NSString stringWithFormat:@"%@",[[TMCache sharedCache] objectForKey:@"userType"]];
}

-(void)setArraySearchHistory:(NSMutableArray *)arraySearchHistory{
    [[TMCache sharedCache] setObject:arraySearchHistory forKey:@"arraySearchHistory"];
}

-(NSMutableArray *)arraySearchHistory{
    return [[TMCache sharedCache]objectForKey:@"arraySearchHistory"];
}

- (void) setUserInfo:(UserInfoModel *)userInfo
{
    [[TMCache sharedCache] setObject:userInfo forKey:@"userInfo"];
}
- (UserInfoModel*) userInfo
{
    return (UserInfoModel*)[[TMCache sharedCache] objectForKey:@"userInfo"];
}

- (AddressModel *)addressModel {
    return (AddressModel *)[[TMCache sharedCache] objectForKey:@"addressModel"];
}

- (void)setAddressModel:(AddressModel *)addressModel {
    [[TMCache sharedCache] setObject:addressModel forKey:@"addressModel"];
}

- (NSDate*) refreshTime
{
    return (NSDate*)[[TMCache sharedCache] objectForKey:@"refreshTime"];
}
- (void) setRefreshTime:(NSDate *)refreshTime
{
    [[TMCache sharedCache] setObject:refreshTime forKey:@"refreshTime"];
}

- (NSDate*) adRefreshTime
{
    return (NSDate*)[[TMCache sharedCache] objectForKey:@"adRefreshTime"];
}
- (void) setAdRefreshTime:(NSDate *)adRefreshTime
{
    [[TMCache sharedCache] setObject:adRefreshTime forKey:@"adRefreshTime"];
}

- (NSNumber*) lastVer
{
    return (NSNumber*)[[TMCache sharedCache] objectForKey:@"lastVer"];
}
- (void) setLastVer:(NSNumber *)lastVer
{
    [[TMCache sharedCache] setObject:lastVer forKey:@"lastVer"];
}


- (NSString*) inStore
{
    return (NSString*)[[TMCache sharedCache] objectForKey:@"inStore"];
}
- (void) setInStore:(NSString*)inStore
{
    [[TMCache sharedCache] setObject:inStore forKey:@"inStore"];
}


//当前位置GPS坐标
- (void) setCurrentPostion:(CLLocationCoordinate2D)currentPostion
{
    [[TMCache sharedCache] setObject:@(currentPostion.latitude) forKey:@"currentLatitude"];
    [[TMCache sharedCache] setObject:@(currentPostion.longitude) forKey:@"currentLongitude"];
}
- (CLLocationCoordinate2D) currentPostion
{
    NSString *lat=[[TMCache sharedCache] objectForKey:@"currentLatitude"];
    NSString *lng=[[TMCache sharedCache] objectForKey:@"currentLongitude"];
    return (CLLocationCoordinate2D){[lat floatValue],[lng floatValue]};
}

- (int) lastPostionUpdateTime
{
    return (int)[[TMCache sharedCache] objectForKey:@"lastPostionUpdateTime"];
}
- (void) setLastPostionUpdateTime:(int)lastPostionUpdateTime
{
    [[TMCache sharedCache] setObject:@(lastPostionUpdateTime) forKey:@"lastPostionUpdateTime"];
}

- (void) Logout
{
    //取消针对分组和个人的推送设置
    [[TMCache sharedCache] removeObjectForKey:@"userID"];
    [[TMCache sharedCache] removeObjectForKey:@"userInfo"];
    [[TMCache sharedCache] removeObjectForKey:@"auth"];
    [[TMCache sharedCache] removeObjectForKey:@"token"];
    [[TMCache sharedCache] removeObjectForKey:@"addressModel"];
}

-(void)delCaoGao:(NSString *)caogaoID{
    NSMutableArray *arrayCaoGao=[[[TMCache sharedCache] objectForKey:@"caogao"] mutableCopy];
    for (NSDictionary *dicNow in arrayCaoGao) {
        if ([dicNow objectForKey:@"id"]) {
            [arrayCaoGao removeObject:dicNow];
            if (arrayCaoGao.count<1) {
                [[TMCache sharedCache] removeObjectForKey:@"caogao"];
            }else{
                [[TMCache sharedCache] setObject:arrayCaoGao forKey:@"caogao"];
            }
            return  ;
        }
    }
}

-(void)addCaoGao:(NSDictionary *)dicCaogao{
    NSMutableArray *arrayCaoGao=[[[TMCache sharedCache] objectForKey:@"caogao"] mutableCopy];
    if (arrayCaoGao.count<1) {
        NSMutableArray *arrayFirst=[[NSMutableArray alloc]init];
        [arrayFirst addObject:dicCaogao];
        [[TMCache sharedCache] setObject:arrayFirst forKey:@"caogao"];
    }else{
        [arrayCaoGao addObject:dicCaogao];
        [[TMCache sharedCache] setObject:arrayCaoGao forKey:@"caogao"];
        
    }
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (UIFont*) fontWithSize:(CGFloat)size
{
    return ART_FONT(size);
}

/*手机号码验证
 MODIFIED BY HELENSONG*/

- (BOOL)isValidateMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

@end
