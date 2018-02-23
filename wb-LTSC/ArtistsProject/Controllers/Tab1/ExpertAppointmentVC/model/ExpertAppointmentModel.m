//
//  ExpertAppointmentModel.m
//  ShesheDa
//
//  Created by chen on 16/7/11.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ExpertAppointmentModel.h"

@implementation xczxxzModel

@end

@implementation xczxModel

@end


@implementation xczbModel


@end


@implementation ExpertAppointmentZhubandanweiDataModel



@end

@implementation ExpertAppointmentZhubandanweiModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [ExpertAppointmentZhubandanweiDataModel class]
             };
}

@end


@implementation ExpertAppointmentAudioModel



@end

@implementation ExpertAppointmentUserModel


@end

@implementation ExpertAppointmentZhuanjiaModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"audio" : [ExpertAppointmentAudioModel class],
             @"signuser" : [ExpertAppointmentUserModel class]
             };
}

@end

@implementation ExpertAppointmentModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"zhuanjia" : [ExpertAppointmentZhuanjiaModel class],
             @"xczb" : [xczbModel class]
             };
}

@end
