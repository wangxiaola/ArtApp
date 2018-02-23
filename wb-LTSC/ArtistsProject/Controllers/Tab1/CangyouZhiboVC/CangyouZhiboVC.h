//
//  CangyouZhiboVC.h
//  ShesheDa
//
//  Created by chen on 16/8/5.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HPageViewController.h"
#import "YTXTopicListViewModel.h"

@interface CangyouZhiboVC : HPageViewController

@property (nonatomic, copy) NSString * topicName;

@property (nonatomic, strong) YTXTopicListViewModel * model;

@end
