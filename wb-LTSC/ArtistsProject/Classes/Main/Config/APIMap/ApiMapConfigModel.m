//
//  ApiMapConfigModel.m
//  evtmaster
//
//  Created by sks on 16/5/10.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "ApiMapConfigModel.h"
#import "LKDBHelper.h"

@implementation ApiMapConfigModel
//在类 初始化的时候
+(void)initialize
{
    //remove unwant property
    //比如 getTableMapping 返回nil 的时候   会取全部属性  这时候 就可以 用这个方法  移除掉 不要的属性
    [self removePropertyWithColumnName:@"error"];
    
    //    [self setTableColumnName:@"create_time" bindingPropertyName:@"createTime"];
    //    [self setTableColumnName:@"update_time" bindingPropertyName:@"updateTime"];
}

// 必写
+(LKDBHelper *)getUsingLKDBHelper {
    return [BaseModel getUsingLKDBHelper];
}

// 必写表名
+(NSString *)getTableName {
    return @"apimap_config";
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
