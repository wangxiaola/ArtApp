//
//  MSBHistoryModel.m
//  meishubao
//
//  Created by T on 16/12/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBHistoryModel.h"
#import "LKDBHelper.h"

@implementation MSBHistoryModel

+(LKDBHelper *)getUsingLKDBHelper {
    return [BaseModel getUsingLKDBHelper];
}

// 表名
+(NSString *)getTableName {
    return @"read_history_db";
}

// 主键
+(NSString *)getPrimaryKey {
    return @"id";
}

// 保存后是否更新主键id到model中
+(BOOL)autoIncreatPrimaryKey {
    return YES;
}

@end
