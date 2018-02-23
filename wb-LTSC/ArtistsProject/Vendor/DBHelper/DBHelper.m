//
//  DBHelper.m
//  ShaManager
//
//  Created by HeLiulin on 15/5/4.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper
/**
 步骤:
 1.一个静态变量_inastance
 2.重写allocWithZone, 在里面用dispatch_once, 并调用super allocWithZone
 3.自定义一个sharedXX, 用来获取单例. 在里面也调用dispatch_once, 实例化_instance
 -----------可选------------
 4.如果要支持copy. 则(先遵守NSCopying协议)重写copyWithZone, 直接返回_instance即可.
 */
/**第1步: 存储唯一实例*/
static DBHelper *_instance;

/**第2步: 分配内存孔家时都会调用这个方法. 保证分配内存alloc时都相同*/
+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

/**第3步: 保证init初始化时都相同*/
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DBHelper alloc] init];
    });
    return _instance;
}

/**第4步: 保证copy时都相同*/
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

- (FMDatabase*) sharedDB
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    NSString *dbPath=[documentDirectory stringByAppendingPathComponent:@"database.db"];
    FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
    if ([db open]==NO){
        NSLog(@"Could not open db");
        return nil;
    }
    
    return db;
}
//本地数据初始化
- (void) initDataBase
{
    FMDatabase *db=self.sharedDB;
    //好友列表
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_Friends(userId text,name text,portraitUri text)"];
    //群组列表
//    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_Groups(groupId text,groupName text,portraitUri text,memberCount text)"];
    
    [db close];
    
}
@end
