//
//  YTXTopicListViewModel.h
//  ShesheDa
//
//  Created by 徐建波 on 2016/11/17.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTXTopicModel.h"

@interface YTXTopicListViewModel : NSObject

@property (nonatomic, strong) NSURL * imageURL;

@property (nonatomic, copy) NSString * position;

@property (nonatomic, copy) NSString * poster;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * shareCount;

@property (nonatomic, copy) NSString * participationCount;

@property (nonatomic, copy) NSString * browseCount;

@property (nonatomic, copy) NSString * postTime;

+ (instancetype)modelWithTopicModel:(YTXTopicModel *)topicModel;

@end
