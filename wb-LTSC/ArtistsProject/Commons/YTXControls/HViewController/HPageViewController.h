//
//  HViewController.h
//  Hospital
//
//  Created by by Heliulin on 15/5/19.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//

#import "HViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import <UIKit/UIKit.h>

@interface HPageViewController : HViewController <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView* tab;
@property (nonatomic, strong) NSMutableArray* lstData;
@property (nonatomic, readwrite) int pageNo;
@property (nonatomic, strong) NSMutableDictionary* dicParamters;
@property (nonatomic, copy) NSString* sortName;
@property (nonatomic, copy) NSString* moduleName;
@property (nonatomic, copy) NSString* actionName;
@property (nonatomic, assign) BOOL toporder;
@property (nonatomic, assign) BOOL isZhiding;
@property (nonatomic, copy) NSString *topictype;
//  开启头部刷新
@property (nonatomic, assign) BOOL isCloseHeaderRefresh;
//  开启脚部刷新
@property (nonatomic, assign) BOOL isCloseFooterRefresh;
//1为专家预约列表
@property (nonatomic, copy) NSString* sortClass;
///是否使用分组视图
@property (nonatomic, readwrite) BOOL isGroup;
///是否post数据
@property (nonatomic, readwrite) BOOL isPost;
///是否在画面显示时自动刷新数据
@property (nonatomic, readwrite) BOOL autoReloadDataOnViewWillAppear;

- (void)beforeLoadData;
- (void)afterSuccessLoadData:(id)result;
- (void)afterSuccessLoadMoreData:(id)result;
- (void)afterFailLoadData:(id)result;
- (void)afterFailLoadMoreData:(id)result;
- (void)afterFailReLoadData;
///重新加载数据
- (void)reloadData;
- (void)loadData;

@end
