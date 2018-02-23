//
//  HomeImageModel.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/8/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "HomeImageModel.h"

@implementation HomeImageModel

// 不同key值传值
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"picId" : @"id",
             };
}

@end

