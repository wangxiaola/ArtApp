//
//  YTXSearchDynamicModel.m
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXSearchDynamicModel.h"

@implementation YTXSearchDynamicModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"goodlong" : @"long"
             };
}

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"photoscbk" : [YTXPhotoscbkModel class]
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"user" : [YTXUser class],
             @"likeuser" : [YTXUser class],
             };
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


@end
