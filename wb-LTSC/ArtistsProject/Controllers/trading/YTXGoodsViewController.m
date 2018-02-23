//
//  YTXGoodsViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXGoodsViewController.h"
#import "YTXGoodsCollectionViewCell.h"
#import "FTPopOverMenu.h"
#import "YTXGoodsTypeModel.h"
#import "UIScrollView+YTXRefreshControl.h"
#import "YTXGoodsModel.h"
#import "HomeListDetailVc.h"

static NSString * const kYTXGoodsCollectionViewCell = @"YTXGoodsCollectionViewCell";

@interface YTXGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray * goodsArray;//商品列表

@property (nonatomic, strong) NSMutableArray * typeArray;//商品总类分类

@property (nonatomic, assign) NSInteger autoRequestCount;//网络异常自动请求次数

@property (nonatomic, copy) NSString * catatype;//类别

@property (nonatomic, copy) NSString * sellprice;//加个排序（1-升序 2-降序）

@property (nonatomic, copy) NSString * hot;//热度 1 高到底 2 低到高 0 或不传 不按热度

@end

@implementation YTXGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _autoRequestCount = 10;
    _page = 1;
    _goodsArray = @[].mutableCopy;
    _typeArray = @[].mutableCopy;
    _sellprice = @"1";
    self.noDataMode = HNoDataModeDefault;
    self.view.backgroundColor = ColorHex(@"f6f6f6");
    [self customNavBar];
    [self fetchGoodsType];
    [self fetchGoodsList];
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
#pragma mark - Fetch Data

//获取店铺分类
- (void)fetchGoodsType {
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"goodstype" andPramater:nil andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        if (_autoRequestCount > 0) {
            _autoRequestCount--;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fetchGoodsType];
            });
        }
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [_typeArray removeAllObjects];
            for (NSDictionary * dict in responseObject) {
                YTXGoodsTypeModel * model = [YTXGoodsTypeModel modelWithDictionary:dict];
                [_typeArray addObject:model];
            }
        }
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_autoRequestCount > 0) {
                _autoRequestCount--;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self fetchGoodsType];
                });
            }
        });
    }];
}

- (void)fetchGoodsList {
    NSMutableDictionary * mDict = [@{
                                @"page" : [NSString stringWithFormat:@"%d",(int)_page],
                                @"num" : @"21",
                                @"topictype" : @"4",
                                @"cuid" : [NSString stripNullWithString:[Global sharedInstance].userID],
                                } mutableCopy];
    if (_catatype.length > 0) {
        [mDict setValue:_catatype forKey:@"catatype"];
    }
    if (_sellprice.length > 0) {
        [mDict setValue:_sellprice forKey:@"sellprice"];
    }
    if (_hot.length > 0) {
        [mDict setValue:_hot forKey:@"hot"];
    }
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"topiclist" andPramater:mDict.copy andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        [self reloadData];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (self.page == 1) {
                [_goodsArray removeAllObjects];
            }
            if ([responseObject count] < 5) {
                [self.collectionView endRefreshingWithNoMoreData];
            }
            for (NSDictionary * dict in responseObject) {
                YTXGoodsModel * model = [YTXGoodsModel modelWithDictionary:dict];
                YTXGoodsViewModel * viewModel = [YTXGoodsViewModel modelWithGoodsModel:model];
                [_goodsArray addObject:viewModel];
            }
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self.collectionView endRefreshingWithNoMoreData];
            [self showErrorHUDWithTitle:[responseObject objectForKey:@"msg"] SubTitle:nil Complete:nil];
        }
        [self reloadData];
        
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self.hudLoading hide:YES];
        [self reloadData];
    }];
}

#pragma mark - Private Methods

- (void)reloadData {
    [self.collectionView endRefreshing];
    [self.collectionView reloadData];
}

- (void)customNavBar {
    HView *viewNav=[[HView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 95)];
    viewNav.backgroundColor = [UIColor colorWithHexString:@"#C4B173"];
    [self.view addSubview:viewNav];
    
    HButton *btnCancel=[[HButton alloc]init];
    [btnCancel setImage:[UIImage imageNamed:@"icon_navigationbar_back"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(leftBarItem_Click) forControlEvents:UIControlEventTouchUpInside];
    [viewNav addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewNav).offset(30);
        make.left.equalTo(viewNav).offset(20);
    }];
    
    HLabel * navTitle=[[HLabel alloc]init];
    navTitle.textColor = kWhiteColor;
    navTitle.font = kFont(18);
    navTitle.text = @"交易区";
    [viewNav addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnCancel);
        make.centerX.equalTo(viewNav);
    }];
    
    CGFloat btnWidth = floor(kScreenW / 3.0);
    NSArray * titleArray = @[@"按类别",@"按价格",@"按热度"];
    for (NSString * title in titleArray) {
        NSInteger index = [titleArray indexOfObject:title];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = kFont(14);
        [btn setFrame:CGRectMake(index * btnWidth, 64, btnWidth, 31)];
        [viewNav addSubview:btn];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        btn.tag = index + 1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [[FTPopOverMenuConfiguration defaultConfiguration] setTextAlignment:NSTextAlignmentCenter];
}

- (void)btnAction:(UIButton *)btn {
    NSMutableArray * titleArray = @[].mutableCopy;
    switch (btn.tag) {
        case 1:
        {
            for (YTXGoodsTypeModel * model in _typeArray) {
                [titleArray addObject:model.title];
            }
            [titleArray addObject:@"全部"];
        }
            break;
        case 2:
        {
            titleArray = [@[@"由高到低",@"由低到高"] mutableCopy];
        }
            break;
        case 3:
        {
            titleArray = [@[@"由高到低",@"由低到高"] mutableCopy];
        }
            break;
    }
    [FTPopOverMenu showFromSenderFrame:btn.frame withMenu:titleArray doneBlock:^(NSInteger selectedIndex) {
        switch (btn.tag) {
            case 1:
            {
                if (selectedIndex == _typeArray.count) {
                    _catatype = @"";
                } else {
                    
                    YTXGoodsTypeModel * model = [_typeArray objectOrNilAtIndex:selectedIndex];
                    NSMutableArray * title = @[].mutableCopy;
                    for (YTXGoodsTypeModel * childModel in model.child) {
                        [title addObject:childModel.title];
                    }
                    [FTPopOverMenu showFromSenderFrame:btn.frame withMenu:title doneBlock:^(NSInteger selectedIndex) {
                        YTXGoodsTypeModel * childModel = [model.child objectOrNilAtIndex:selectedIndex];
                        _catatype = childModel.goods_id;
                        self.page = 1;
                        [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
                        [self fetchGoodsList];
                    } dismissBlock:^{
                        
                    }];
                    return ;
                }
            }
                break;
            case 2:
            {
                if (selectedIndex == 0) {
                    _sellprice = @"2";
                } else {
                    _sellprice = @"1";
                }
                _hot = nil;
            }
                break;
            case 3:
            {
                if (selectedIndex == 0) {
                    _hot = @"2";
                } else {
                    _hot = @"1";
                }
                _sellprice = nil;
            }
                break;
        }
        self.page = 1;
        [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
        [self fetchGoodsList];
        
    } dismissBlock:^{
        
    }];
}
//返回按钮点击事件
- (void)leftBarItem_Click {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UICollectionViewDelegate/DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YTXGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYTXGoodsCollectionViewCell forIndexPath:indexPath];
    cell.model = [self.goodsArray objectOrNilAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YTXGoodsViewModel * model = [self.goodsArray objectOrNilAtIndex:indexPath.item];

    
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = model.gid;
    detailVC.topictype = @"4";
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [self fetchGoodsList];
}


#pragma mark -  Getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        CGFloat itemWidth = floor((kScreenW - 2) / 3.0);
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 95, kScreenW,kScreenH - 95) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.emptyDataSetSource = self;
        __weak typeof(self)weakSelf = self;
        [_collectionView headerRefreshingWithBlock:^{
            weakSelf.page = 1;
            [weakSelf fetchGoodsList];
        }];
        [_collectionView footerRefreshingWithBlock:^{
            weakSelf.page++;
            [weakSelf fetchGoodsList];
        }];
        _collectionView.backgroundColor = kWhiteColor;
        [_collectionView registerClass:[YTXGoodsCollectionViewCell class] forCellWithReuseIdentifier:kYTXGoodsCollectionViewCell];
        [self.view addSubview:_collectionView];
    }
    return  _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
