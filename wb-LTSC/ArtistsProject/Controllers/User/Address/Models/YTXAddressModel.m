//
//  YTXAddressModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXAddressModel.h"

@implementation YTXAddressModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"aid" : @"id",
             @"defaultStr" : @"default"
             };
}


@end
