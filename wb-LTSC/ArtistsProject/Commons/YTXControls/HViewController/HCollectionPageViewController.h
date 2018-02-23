//
//  HViewController.h
//  Hospital
//
//  Created by by Heliulin on 15/5/19.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface HCollectionPageViewController : HViewController<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property(nonatomic,strong) UICollectionView *collection;
@property(nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,strong) NSMutableArray *lstData;
@property(nonatomic,readwrite) int pageNo;
@property(nonatomic,strong) NSMutableDictionary *dicParamters;
@property(nonatomic,copy) NSString *sortName;
@property(nonatomic,copy) NSString *moduleName;
@property(nonatomic,copy) NSString *actionName;
@property(nonatomic,readwrite) HNoDataMode noDataMode;
///是否在画面显示时自动刷新数据
@property(nonatomic,readwrite) BOOL autoReloadDataOnViewWillAppear;

- (void) afterSuccessLoadData:(id)result;
- (void) afterSuccessLoadMoreData:(id)result;
- (void) afterFailLoadData:(id)result;
- (void) afterFailLoadMoreData:(id)result;
- (void) afterFailReLoadData;
///重新加载数据
- (void) reloadData;
@end
