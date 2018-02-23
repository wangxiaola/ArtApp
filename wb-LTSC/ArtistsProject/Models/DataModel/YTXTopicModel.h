//
//  YTXTopicModel.h
//  ShesheDa
//
//  Created by 徐建波 on 2016/11/17.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTXUser;

@interface YTXTopicModel : NSObject<YYModel>

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * fenxiang;
@property (nonatomic, copy) NSString * liulan;
@property (nonatomic, copy) NSString * canyu;
@property (nonatomic, copy) NSString * ctime;
@property (nonatomic, strong) YTXUser * user;

@end
