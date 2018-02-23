//
//  DBHelper.h
//  ShaManager
//
//  Created by HeLiulin on 15/5/4.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBHelper : NSObject
+(instancetype)sharedInstance;
@property(nonatomic,strong) FMDatabase *sharedDB;
- (void) initDataBase;
@end
