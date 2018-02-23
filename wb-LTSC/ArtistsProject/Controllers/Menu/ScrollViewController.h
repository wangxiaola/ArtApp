//
//  ScrollViewController.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "BaseController.h"

@class HomeController;
@interface ScrollViewController : BaseController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isOpenHeaderRefresh;//  开启头部刷新
@property (nonatomic, assign) BOOL isOpenFooterRefresh;//  开启尾部部刷新
@property(nonatomic,assign)NSInteger pageIndex;//页码
@property(nonatomic,strong)UITableView* tabView;
@property(nonatomic,strong)NSMutableDictionary* dataDic;
@property(nonatomic,weak)UIViewController* obj;
@property(nonatomic,copy)NSString * artId;//艺术家id如果艺术家id
@property (nonatomic, copy) NSString *zhiding;// 是否取置顶数据
@property (nonatomic, copy) NSString *gtype;// 搜索内容

-(void)createView;
-(void)loadData;
-(void)loadMoreData;//上拉加载
-(void)refreshData;//下啦刷新
-(void)loadAgain;
@end
