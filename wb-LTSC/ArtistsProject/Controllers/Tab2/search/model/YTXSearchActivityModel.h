//
//  YTXSearchActivityModel.h
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTXSearchActivityModel : NSObject
@property (nonatomic, copy) NSString * stime;
@property (nonatomic, copy) NSString * etime;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * tips;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * place;
@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * uid;

@property (nonatomic, strong) NSMutableArray * photoscbk;

@end
