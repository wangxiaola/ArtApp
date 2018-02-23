//
//  ApiMap.h
//  evtmaster
//
//  Created by sks on 16/5/10.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiMap : NSObject

+ (void)initConfig;
// 加载本地的config文件
+ (void)loadLocalConfig:(NSString*) path;
+ (void)setApiMapUserDefaults:(NSDictionary *)apiConfig;
// 获取一个url配置
+ (NSString *)url: (NSString *)key;
@end
