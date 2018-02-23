//
//  Ann30ImageModel.m
//  meishubao
//
//  Created by benbun－mac on 17/2/28.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "Ann30ImageModel.h"
#import "MJExtension.h"
#import "ArticleImageModel.h"
@implementation Ann30ImageModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"smeta":[ArticleImageModel class]};
}

@end
