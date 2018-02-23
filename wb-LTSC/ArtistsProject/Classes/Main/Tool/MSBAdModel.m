//
//  MSBAdModel.m
//  meishubao
//
//  Created by T on 16/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBAdModel.h"
#import "LKDBHelper.h"

@implementation MSBAdModel
// 必写
+(LKDBHelper *)getUsingLKDBHelper {
    return [BaseModel getUsingLKDBHelper];
}

// 必写表名
+(NSString *)getTableName {
    return @"msb_ad";
}

// 必写 主键
+(NSString *)getPrimaryKey {
    return @"id";
}

// 保存后是否更新主键id到model中
+(BOOL)autoIncreatPrimaryKey {
    return YES;
}


// 重载 向数据库中保存时，将外键关联依次保存
-(id)userGetValueForModel:(LKDBProperty *)property {
    return nil;
}
// 重载 从数据库中获取值后 经过自己处理 再保存
-(void)userSetValueForModel:(LKDBProperty *)property value:(id)value {
}
@end
