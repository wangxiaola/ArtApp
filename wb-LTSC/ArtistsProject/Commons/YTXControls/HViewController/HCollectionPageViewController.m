//
//  HViewController.m
//  Hospital
//
//  Created by by Heliulin on 15/5/19.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//

#import "HCollectionPageViewController.h"
#import "ListResultModel.h"
#import "HLoadingHeader.h"
#import "HLoadingFooter.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshBackNormalFooter.h"

@interface HCollectionPageViewController ()
@property(nonatomic,readwrite) BOOL isFristLaunch;
@end

@implementation HCollectionPageViewController
@synthesize lstData,pageNo;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.actionName){
        if (self.isFristLaunch||self.autoReloadDataOnViewWillAppear){
            self.isFristLaunch = NO;
            [self.hudLoading show:YES];
            [self loadData];
        }
    }
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isFristLaunch=YES;
}
     
- (UICollectionView*) collection
{
    if (!_collection){
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        
        [self.view addSubview:_collection];
        [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.and.bottom.equalTo(self.view);
        }];
        _collection.dataSource=self;
        _collection.delegate=self;
        _collection.scrollsToTop=YES;
        _collection.mj_header=[HLoadingHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _collection.mj_footer=[HLoadingFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    return _collection;
}
     
#pragma mark UITableViewDelegate

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return lstData.count;
}
//每个UICollectionView展示的内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

#pragma mark - DZNEmptyDataSetSource Methods

//- (UIImage*) buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    return [UIImage imageNamed:@"icon_Default_Refresh"];
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    switch (self.noDataMode) {
        case HNoDataModeDefault://无数据
        {
            return  [UIImage imageNamed:@"bg_noData"];
        }
        case HNoDataModeNoCartData://购物车空
        {
            return [UIImage imageNamed:@"bg_noCart"];
        }
        case HNoDataModeNoOrderData://无订单
        {
            return [UIImage imageNamed:@"bg_noOrder"];
        }
        case HNoDataModeNoSearchResult://搜索无结果
        {
            return [UIImage imageNamed:@"bg_noSearch"];
        }
        default:
            return [UIImage imageNamed:@"bg_noData"];
    }
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
//{
//    [self.hudLoading show:YES];
//    [self loadData];
//}
#pragma mark 加载数据
/**
 *  加载数据
 */
- (void) loadData
{
    
    pageNo=1;
    [self.collection.mj_footer resetNoMoreData];
    HHttpRequest *request=[HHttpRequest new];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:self.dicParamters];
    if (dic[@"num"]==nil){
        [dic setObject:kPageSize forKey:@"num"];
    }
    if (dic[@"page"]==nil){
        [dic setObject:@(pageNo) forKey:@"page"];
    }
    
    [request httpGetRequestWithActionName:self.actionName
                               andPramater:dic
           andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {//无数据或者数据错误
               [self.hudLoading hideAnimated:YES];
               self.collection.emptyDataSetDelegate=self;
               self.collection.emptyDataSetSource=self;
               lstData=[[NSMutableArray alloc] initWithCapacity:0];
               [self afterFailLoadData:[((NSDictionary*)responseObject) objectForKey:@"data"]];
               [self.collection reloadData];
               [self.collection.mj_header endRefreshing];
               ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
               [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
           }
      andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {//请求成功

          [self.hudLoading hideAnimated:YES];
          lstData=[(NSArray *)responseObject mutableCopy];
          [self afterSuccessLoadData:responseObject];
          [self.collection reloadData];
          [self.collection.mj_header endRefreshing];
      }
       andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {//请求失败
           [self.collection.mj_header endRefreshing];
           [self.collection reloadData];
           [self.hudLoading hideAnimated:YES];
       }];
}
- (void) afterSuccessLoadData:(id)result
{
    
}
- (void) afterSuccessLoadMoreData:(id)result
{
    
}
- (void) afterFailLoadData:(id)result{
    
}
- (void) afterFailLoadMoreData:(id)result{
    
}
- (void) afterFailReLoadData
{
    
}
/**
 *  加载更多数据
 */
- (void) loadMoreData
{
    HHttpRequest *request=[HHttpRequest new];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:self.dicParamters];
    if (dic[@"num"]==nil){
        [dic setObject:kPageSize forKey:@"num"];
    }
    if (dic[@"page"]==nil){
        [dic setObject:@(pageNo+1) forKey:@"page"];
    }

    
    [request  httpGetRequestWithActionName:self.actionName
                               andPramater:dic
           andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {//无数据或者数据错误
               [self afterFailLoadMoreData:[((NSDictionary*)responseObject) objectForKey:@"data"]];
               [self.collection reloadData];
               [self.collection.mj_footer endRefreshingWithNoMoreData];
               ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
               [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
           }
      andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {//请求成功
          pageNo+=1;
          [lstData addObjectsFromArray:(NSArray *)responseObject];
          
          if ([(NSArray *)responseObject count]<1) {
              [self.collection.mj_footer endRefreshingWithNoMoreData];
          }
           [self afterSuccessLoadMoreData:responseObject];
          [self.collection reloadData];
          [self.collection.mj_footer endRefreshing];
      }
       andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {//请求失败
           [self.collection.mj_footer endRefreshing];
       }];
}
- (void) reloadData
{
    if (lstData==nil){
        lstData=[[NSMutableArray alloc] initWithCapacity:0];
        [self.collection reloadData];
    }
    
    HHttpRequest *request=[HHttpRequest new];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:self.dicParamters];
    [dic setObject:@([kPageSize intValue]*pageNo) forKey:@"num"];
    [dic setObject:@"1" forKey:@"page"];
    
    [request  httpPostRequestWithActionName:self.actionName
                                andPramater:dic
                  andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {//无数据或者数据错误
                      self.collection.emptyDataSetDelegate=self;
                      self.collection.emptyDataSetSource=self;
                      lstData=[[NSMutableArray alloc] initWithCapacity:0];
                      [self.collection reloadData];
                      [self afterFailReLoadData];
                      ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
                      [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                  }
             andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {//请求成功
                  lstData=[responseObject mutableCopy];
                  [self afterSuccessLoadData:responseObject];
                 [self.collection reloadData];
             }
              andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {//请求失败
              }];

}
@end
