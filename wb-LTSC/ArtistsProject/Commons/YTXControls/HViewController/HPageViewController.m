//
//  HViewController.m
//  Hospital
//
//  Created by by Heliulin on 15/5/19.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//
#import "HPageViewController.h"
#import "HLoadingFooter.h"
#import "HLoadingHeader.h"
#import "ListResultModel.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshBackNormalFooter.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
@interface HPageViewController ()

@end

@implementation HPageViewController
@synthesize lstData, pageNo;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.actionName) {
        if (self.isFristLaunch || self.autoReloadDataOnViewWillAppear) {
            self.isFristLaunch = NO;
            [self.hudLoading showAnimated:YES];
            [self loadData];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tab = [self tab];
}

- (UITableView*)tab
{
    if (!_tab) {
        if (self.isGroup) {
            _tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        }
        else {
            _tab = [UITableView new];
        }
        [self.view addSubview:_tab];
        [_tab mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.and.left.and.right.and.bottom.equalTo(self.view);
        }];
        _tab.dataSource = self;
        _tab.delegate = self;
        _tab.tableFooterView = [UIView new];
        _tab.scrollsToTop = YES;
        
        if (!self.isCloseFooterRefresh) {
            _tab.mj_footer = [HLoadingFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
        if (!self.isCloseHeaderRefresh) {
            _tab.mj_header = [HLoadingHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        }
        
        // 设置了底部inset
        _tab.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // 忽略掉底部inset
        _tab.mj_footer.ignoredScrollViewContentInsetBottom = 0;
    }
    return _tab;
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lstData.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

#pragma mark 加载数据
/**
 *  加载页面数据
 */
- (void)loadData
{
    
    //lstData=[[NSMutableArray alloc] initWithCapacity:0];
    pageNo = 1;
    [self.tab.mj_footer resetNoMoreData];
    [self beforeLoadData];
    HHttpRequest* request = [HHttpRequest new];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:self.dicParamters];
    if (dic[@"num"] == nil) {
        [dic setObject:kPageSize forKey:@"num"];
    }
    if (dic[@"page"] == nil) {
        [dic setObject:@(pageNo) forKey:@"page"];
    }
    
    
//    NSString* temp =  [Global sharedInstance].zhidingStr;
//    if (![temp isEqualToString:@"艺术圈"]){
//            [dic setObject:@"1" forKey:@"toporder"];
//            if (self.topictype) {
//                //[dic setObject:_topictype forKey:@"topictype"];
//            }
//    }
    if (self.isPost) {
        [request httpPostRequestWithActionName:self.actionName
                                   andPramater:dic
                          andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) { //无数据或者数据错误
                              
                              self.tab.emptyDataSetDelegate = self;
                              self.tab.emptyDataSetSource = self;
                              lstData = [[NSMutableArray alloc] initWithCapacity:0];
                              [self.tab reloadData];
                              [self.hudLoading hideAnimated:YES];
                              [self afterFailLoadData:responseObject];
                              [self.tab.mj_header endRefreshing];
                              ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
                              [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                          }
                     andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) { //请求成功
                         self.tab.emptyDataSetDelegate = self;
                         self.tab.emptyDataSetSource = self;
                         [self.hudLoading hideAnimated:YES];
                         //          ListResultModel *result=[ListResultModel objectWithKeyValues:responseObject];
                         if ([self.sortClass isEqualToString:@"1"]) {
                             if ([responseObject isKindOfClass:[NSArray class]]) {
                                 lstData = [(NSArray*)responseObject mutableCopy];
                             }
                         }
                         else {
                             if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSArray class]]) {
                                 lstData = [(NSArray*)[responseObject objectForKey:@"message"] mutableCopy];
                             }
                         }
                         
                         [self.tab reloadData];
                         [self afterSuccessLoadData:responseObject];
                         [self.tab.mj_header endRefreshing];
                     }
                      andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) { //请求失败
                          [self.tab.mj_header endRefreshing];
                          [self.tab reloadData];
                          [self.hudLoading hideAnimated:YES];
                      }];
    }else{
        [request httpGetRequestWithActionName:self.actionName
                                  andPramater:dic
                         andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) { //无数据或者数据错误
                             
                             self.tab.emptyDataSetDelegate = self;
                             self.tab.emptyDataSetSource = self;
                             lstData = [[NSMutableArray alloc] initWithCapacity:0];
                             [self.tab reloadData];
                             [self.hudLoading hideAnimated:YES];
                             [self afterFailLoadData:responseObject];
                             [self.tab.mj_header endRefreshing];
                             UserInfoModel* result = [UserInfoModel mj_objectWithKeyValues:responseObject];
                             [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                         }
                    andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) { //请求成功
                        self.tab.emptyDataSetDelegate = self;
                        self.tab.emptyDataSetSource = self;
                        [self.hudLoading hideAnimated:YES];
                        //          ListResultModel *result=[ListResultModel objectWithKeyValues:responseObject];
                        if ([self.sortClass isEqualToString:@"1"] && [responseObject isKindOfClass:[NSArray class]]) {
                            lstData = [(NSArray*)responseObject mutableCopy];
                        }
                        else {
                            NSDictionary* dicsySmsg = [responseObject objectForKey:@"sysmsg"];
                            NSMutableArray* arrayMessage = [[responseObject objectForKey:@"message"] mutableCopy];
                            if (dicsySmsg) {
                                [arrayMessage insertObject:dicsySmsg atIndex:0];
                            }
                            lstData = [arrayMessage mutableCopy];
                        }
                        
                        [self.tab reloadData];
                        [self afterSuccessLoadData:responseObject];
                        [self.tab.mj_header endRefreshing];
                    }
                     andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) { //请求失败
                         [self.tab.mj_header endRefreshing];
                         [self.tab reloadData];
                         [self.hudLoading hideAnimated:YES];
                     }];
    }
}
- (void)beforeLoadData
{
}
- (void)afterSuccessLoadData:(id)result
{
}
- (void)afterSuccessLoadMoreData:(id)result
{
}
- (void)afterFailLoadData:(id)result
{
}
- (void)afterFailLoadMoreData:(id)result
{
}
- (void)afterFailReLoadData
{
}
/**
 *  加载更多数据
 */
- (void)loadMoreData
{
    HHttpRequest* request = [HHttpRequest new];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:self.dicParamters];
    if (dic[@"num"] == nil) {
        [dic setObject:kPageSize forKey:@"num"];
    }
    if (dic[@"page"] == nil) {
        [dic setObject:@(pageNo + 1) forKey:@"page"];
    }
    if (self.isZhiding) {
        [dic setObject:@"1" forKey:@"zhiding"];
    }
    if (self.topictype) {
        [dic setObject:_topictype forKey:@"topictype"];
    }

    if (self.isPost) {
        [request httpPostRequestWithActionName:self.actionName
                                   andPramater:dic
                          andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) { //无数据或者数据错误
                              [self.tab.mj_footer endRefreshingWithNoMoreData];
                              [self afterFailLoadMoreData:[((NSDictionary*)responseObject) objectForKey:@"data"]];
                              ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
                              [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                          }
                     andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) { //请求成功
                         [self.tab.mj_footer endRefreshing];
                         //          ListResultModel *result=[ListResultModel objectWithKeyValues:responseObject];
                         
                         pageNo += 1;
                         if ([self.sortClass isEqualToString:@"1"]) {
                             [lstData addObjectsFromArray:(NSArray*)responseObject];
                             if ([(NSArray*)responseObject count] < 1) {
                                 [self.tab.mj_footer endRefreshingWithNoMoreData];
                             }
                         }
                         else {
                             [lstData addObjectsFromArray:[responseObject objectForKey:@"message"]];
                             if ([(NSArray*)[responseObject objectForKey:@"message"] count] < 1) {
                                 [self.tab.mj_footer endRefreshingWithNoMoreData];
                             }
                         }
                         
                         [self.tab reloadData];
                         [self afterSuccessLoadMoreData:responseObject];
                     }
                      andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) { //请求失败
                          [self.tab.mj_footer endRefreshing];
                      }];
    }
    else {
        [request httpGetRequestWithActionName:self.actionName
                                  andPramater:dic
                         andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) { //无数据或者数据错误
                             [self.tab.mj_footer endRefreshingWithNoMoreData];
                             [self afterFailLoadMoreData:[((NSDictionary*)responseObject) objectForKey:@"data"]];
                         }
                    andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) { //请求成功
                        [self.tab.mj_footer endRefreshing];
                        //          ListResultModel *result=[ListResultModel objectWithKeyValues:responseObject];
                        
                        pageNo += 1;
                        if ([self.sortClass isEqualToString:@"1"]) {
                            if ([responseObject isKindOfClass:[NSArray class]]) {
                                [lstData addObjectsFromArray:(NSArray*)responseObject];
                                if ([(NSArray*)responseObject count] < 1) {
                                    [self.tab.mj_footer endRefreshingWithNoMoreData];
                                }
                            }
                            
                        }
                        else {
                            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                [lstData addObjectsFromArray:[responseObject objectForKey:@"message"]];
                                if ([(NSArray*)[responseObject objectForKey:@"message"] count] < 1) {
                                    [self.tab.mj_footer endRefreshingWithNoMoreData];
                                }
                            }
                            
                        }
                        
                        [self.tab reloadData];
                        [self afterSuccessLoadMoreData:responseObject];
                    }
                     andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) { //请求失败
                         [self.tab.mj_footer endRefreshing];
                     }];
    }
}
//刷新页面数据
- (void)reloadData
{
    if (lstData == nil) {
        lstData = [[NSMutableArray alloc] initWithCapacity:0];
        [self.tab reloadData];
    }
    
    HHttpRequest* request = [HHttpRequest new];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:self.dicParamters];
    [dic setObject:@([kPageSize intValue] * pageNo) forKey:@"num"];
    [dic setObject:@"1" forKey:@"page"];

        //[dic setObject:@"1" forKey:@"zhiding"];
     //[dic setObject:@"1" forKey:@"toporder"];

    if (self.topictype) {
        [dic setObject:_topictype forKey:@"topictype"];
    }
    
    if (self.isPost) {
        [request httpPostRequestWithActionName:self.actionName
                                   andPramater:dic
                          andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) { //无数据或者数据错误
                              self.tab.emptyDataSetDelegate = self;
                              self.tab.emptyDataSetSource = self;
                              lstData = [[NSMutableArray alloc] initWithCapacity:0];
                              [self.tab reloadData];
                              [self afterFailReLoadData];
                              ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
                              [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                          }
                     andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) { //请求成功
                         //                 ListResultModel *result=[ListResultModel objectWithKeyValues:responseObject];
                         if ([self.sortClass isEqualToString:@"1"]) {
                             lstData = [responseObject mutableCopy];
                         }
                         else {
                             lstData = [[responseObject objectForKey:@"message"] mutableCopy];
                         }
                         
                         [self afterSuccessLoadData:responseObject];
                         [self.tab reloadData];
                         [self.hudLoading hide:YES];
                     }
                      andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error){
                          //请求失败
                      }];
    }else {
        [request httpGetRequestWithActionName:self.actionName
                                  andPramater:dic
                         andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) { //无数据或者数据错误
                             self.tab.emptyDataSetDelegate = self;
                             self.tab.emptyDataSetSource = self;
                             lstData = [[NSMutableArray alloc] initWithCapacity:0];
                             [self.tab reloadData];
                             [self afterFailReLoadData];
                         }andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) { //请求成功
                        //                 ListResultModel *result=[ListResultModel objectWithKeyValues:responseObject];
                        if ([self.sortClass isEqualToString:@"1"]) {
                            lstData = [responseObject mutableCopy];
                        }else {
                            NSDictionary* dicsySmsg = [responseObject objectForKey:@"sysmsg"];
                            NSMutableArray* arrayMessage = [[responseObject objectForKey:@"message"] mutableCopy];
                            if (dicsySmsg) {
                                [arrayMessage insertObject:dicsySmsg atIndex:0];
                            }
                            lstData = [arrayMessage mutableCopy];
                        }
                        
                        [self afterSuccessLoadData:responseObject];
                        [self.tab reloadData];
                        [self.hudLoading hide:YES];
                    }
                     andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error){
                         
                         //请求失败
                     }];
    }
    [self.tab reloadData];
}

+ (NSString*)dictionaryToJson:(NSDictionary*)dic

{
    
    NSError* parseError = nil;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
