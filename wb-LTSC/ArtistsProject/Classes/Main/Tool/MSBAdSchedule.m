//
//  MSBAdSchedule.m
//  meishubao
//
//  Created by T on 16/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBAdSchedule.h"
#import "MSBAdModel.h"
#import "NSString+ToString.h"
#import "LLRequestServer/LLRequestServer.h"
#import "LKDBHelper.h"

@implementation MSBAdSchedule
static MSBAdSchedule *_sharedInstance = nil;
+ (instancetype)shareInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

- (void)dealloc{
    _sharedInstance = nil;
}

+ (MSBAdModel *)currentAdSchedule {
    return [[MSBAdSchedule shareInstance] currentAdSchedule];
}

+ (void)requestSchedule {
    [[MSBAdSchedule shareInstance] requestServer];
}

- (MSBAdModel *)currentAdSchedule {
    long long time = (long long)[[NSDate date] timeIntervalSince1970] * 1000;
    NSArray *results = [MSBAdModel searchWithWhere:nil orderBy:nil offset:0 count:0];
    NSMutableArray<MSBAdModel *> *arr = [NSMutableArray array];
    for (MSBAdModel *adModel in results) {
        if (adModel.startTime <= time && adModel.endTime>=time) {
            [arr addObject:adModel];
            continue;
        }
    }
    
    for (MSBAdModel *adModel in arr) {
        if (adModel.adBinaryData==nil) {
            continue;
        }
        return adModel;
    }
    
    return nil;
}

- (void)requestServer{

//    [[LLRequestServer shareInstance] requestAdSuccess:^(LLResponse *response, id data) {
//        if (data && [data isKindOfClass:[NSArray class]]) {
//            [self updataScheduleWithArray:data];
//        }else{
//            [self updataScheduleWithArray:nil];
//        }
//    } failure:nil error:nil];
}

- (void)updataScheduleWithArray:(NSArray<MSBAdModel *> *)datas{
    dispatch_queue_t serialQueue = dispatch_queue_create("UpdateScheduleThead", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        @try {
            
        } @catch (NSException *exception) {
            
        }
    });
}


@end
