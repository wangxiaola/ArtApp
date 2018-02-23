//
//  MSBVideoDetaiModel.m
//  meishubao
//
//  Created by T on 17/1/9.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "MSBVideoDetaiModel.h"
#import "GeneralConfigure.h"
#import "CorrelationVideoModel.h"

@implementation MSBVideoDetaiModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"correlation":[CorrelationVideoModel class]};
}

@end
