//
//  MSBReadHistoryTool.m
//  meishubao
//
//  Created by T on 16/12/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBReadHistoryTool.h"
#import "LKDBHelper.h"

@implementation MSBReadHistoryTool
+ (void)insertDBModel:(MSBHistoryModel *)model{
    NSMutableArray *array = [MSBHistoryModel searchWithWhere:nil orderBy:nil offset:0 count:0];
    NSInteger i = 0;
    for (MSBHistoryModel *oldModel in array) {
        if ([oldModel.tid isEqualToString:model.tid]) {
            oldModel.time = model.time;
            [oldModel updateToDB];
            return;
        }else{
            i++;
        }
    }
    
    if (i == array.count) {
         [model saveToDB];
    }
}

+ (NSMutableArray *)searchDBWithTime:(NSString *)time{
    NSMutableArray *array = [MSBHistoryModel searchWithWhere:@{@"time": time} orderBy:@"id desc" offset:0 count:50];
    return array;
}
@end
