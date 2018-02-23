//
//  CangyouQuanDetailModel.m
//  ShesheDa
//
//  Created by MengTuoChina on 16/7/23.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangyouQuanDetailModel.h"
@implementation shareModel

@end

@implementation photoscbkModel


@end

@implementation CangyouQuanCommentsModel

@end


@implementation CangyouQuanDetailModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"longstr" : @"long",
//            };
//}
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"likeuser" : [UserInfoUserModel class],
             @"comments" : [CangyouQuanCommentsModel class],
             @"photoscbk" : [photoscbkModel class],
             };
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"longstr" : @"long"
             };
}

- (NSString *)firstTitle {
    return [[_topictitle componentsSeparatedByString:@"|"] firstObject];
}

- (NSString *)lastTitle {
    NSArray *array = [_topictitle componentsSeparatedByString:@"|"];
    if (array.count > 1) {
        return [array lastObject];
    }
    return @"";
}

- (NSString *)sourceUserName {
    if (_source == nil) {
        return @"";
    }
    if ([_source isKindOfClass:[NSString class]]) {
        return _source;
    }
    if ([_source isKindOfClass:[NSDictionary class]]) {
        return _source[@"username"] ? : @"";
    }
    return @"";
}

- (NSString *)peopleUserName
{
    if (_people == nil) {
        return @"";
    }
    if ([_people isKindOfClass:[NSString class]]) {
        return _people;
    }
    if ([_people isKindOfClass:[NSDictionary class]]) {
        return _people[@"username"] ? : @"";
    }
    return @"";
}

- (NSString *)catetypeName {
    if (_catatype.length == 0) {
        return @"";
    }
    
    switch (_catatype.intValue) {
        case 1:
            return @"陶瓷";
        case 2:
            return @"玉器";
        case 3:
            return @"铜器";
        case 4:
            return @"书画";
        case 5:
            return @"钱币";
        case 6:
            return @"杂项";
        default:
            return @"";
    }
}

- (NSString *)statusName {
    if (_status.length == 0) {
        return @"";
    }
    
    switch (_status.intValue) {
        case 1:
            return @"真";
        case 2:
            return @"假";
        case 3:
            return @"无法鉴定";
        case 4:
            return @"未鉴定";
        default:
            return @"";
    }
}

- (NSString *)topictypeName
{
    switch (_topictype.intValue) {
        case 1:
            return @"在线鉴定";
        case 2:
            return @"动态";
        case 3:
            return @"在线讲堂";
        case 4:
            return @"商品";
        case 6:
            return @"作品";
        case 7:
            return @"相册";
        case 8:
            return @"展览";
        case 9:
            return @"文字";
        case 13:
            return @"艺术年表";
        case 14:
            return @"荣誉奖项";
        case 15:
            return @"收藏拍卖";
        case 16:
            return @"公益捐赠";
        case 17:
            return @"媒体报道";
        case 18:
            return @"出版著作";
        default:
            return @"";
    }
}

- (NSString *)sellPriceText
{
    if (_sellprice.length == 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",_sellprice];
}

- (NSString *)priceText
{
    if (_price.length == 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"估价：%@",_price];
}

- (NSString *)ageText
{
    if (_age.length == 0) {
        return @"";
    }
    if ([_topictype isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"年代：%@",_age];
    }
    return [NSString stringWithFormat:@"%@",_age];
}

- (NSString *)resultSource
{
    NSString *result = @"未鉴定";
    if (![self.status isEqualToString:@"4"]) {
        result = @"已鉴定";
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.authtime integerValue]];
    return [NSString stringWithFormat:@"%@ %@ %@",self.replyuser.username,[formatter stringFromDate:date],result];
}

- (NSString *)sourceText
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.dateline integerValue]];
    return [NSString stringWithFormat:@"%@ %@ %@",self.user.username,[formatter stringFromDate:date],self.arttype.length > 0 ? self.arttype : [self topictypeName]];
}

- (NSString *)zuopinGuigeText
{
    NSMutableArray *array = @[].mutableCopy;
    if (![self.width isEqualToString:@"0"]) {
        [array addObject:self.width];
    }
    if (![self.height isEqualToString:@"0"]) {
        [array addObject:self.height];
    }
    if (![self.longstr  isEqualToString:@"0"]) {
        [array addObject:self.longstr];
    }
    
   
    if (array.count > 0) {
        NSString *str = [[array componentsJoinedByString:@" X "] stringByAppendingString:@" cm"];
        return str;
    }
    return @" ";
}


@end
