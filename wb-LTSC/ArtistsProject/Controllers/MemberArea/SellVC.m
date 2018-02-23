//
//  SearchViewController.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/11.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "SellVC.h"
#import "ShoppingMallCollectionViewCell.h"
#import "AppDelegate.h"
#import "CangyouQuanDetailModel.h"
#import "ArtApplyCell.h"
#import "ShopSearchListCell.h"
#define MINIMUNSPACE 15
#define NUMBEROFCOLUMN 2
#define CELLHEIGHT 50

#define DefineWeakSelf __weak __typeof(self) weakSelf = self

static NSString *tableViewCellIdentifer = @"GoodsCategoryTableViewCell";
static NSString *collectionItemIdentifer = @"SearchGoodsCollectionViewItem";
static NSString *collectionHeaderIdentifer = @"HeaderIdentifier";

@interface SellVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>{
    UIView *  _headerView;
    UILabel * _nullDataLable;
    UIWindow *_window;
    HButton *classBtn,*priceBtn,*hotBtn;
}

@property (nonatomic, assign)NSInteger selectedCategory;

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray <CangyouQuanDetailModel *>*collectionArrayM;
@property (nonatomic, strong)NSMutableArray *tableViewArrayM;
@property (nonatomic, strong)UIButton *selectCategoryBackgroundView;
@property (nonatomic, strong)UIView *navigationBarView;

//@property (nonatomic, copy)NSString *gtype; //类型
@property (nonatomic, copy)NSString *sellprice;// 价格
@property (nonatomic, copy)NSString *hot;// 热度

@property (nonatomic, assign)NSInteger pageIndex;


@property (nonatomic,copy)NSString *searchWord;

@end

@implementation SellVC

#pragma mark - 懒加载
//
-(NSMutableArray *)tableViewArrayM{
    if (!_tableViewArrayM) {
        _tableViewArrayM = [NSMutableArray array];
    }
    return _tableViewArrayM;
}

- (NSMutableArray *)collectionArrayM{
    if (!_collectionArrayM) {
        _collectionArrayM = [NSMutableArray array];
    }
    return _collectionArrayM;
}

-(UIView *)navigationBarView{
    if (!_navigationBarView) {
        
        _navigationBarView  = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
}

-(UIView *)selectCategoryBackgroundView{
    if (!_selectCategoryBackgroundView) {
        
        _selectCategoryBackgroundView = [[UIButton alloc]init];
        _selectCategoryBackgroundView.backgroundColor = [UIColor colorWithWhite:0.2f alpha: 0.5];
        
        [_selectCategoryBackgroundView addTarget:self action:@selector(clickBackground) forControlEvents:UIControlEventTouchUpInside];
        
        _selectCategoryBackgroundView.hidden = YES;
        [self.view addSubview:_selectCategoryBackgroundView];
        
        [_selectCategoryBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _selectCategoryBackgroundView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.selectCategoryBackgroundView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.selectCategoryBackgroundView.center);
            make.width.mas_equalTo(kScreenW - 60);
        }];
    }
    return _tableView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH ) / 2;
        flowLayout.itemSize = CGSizeMake(width, width + 45);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[ShopSearchListCell class] forCellWithReuseIdentifier:collectionItemIdentifer];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - viewController
- (void)createView {
//    [super viewDidLoad];
    [super createView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectedCategory = 0;
    //    self.gtype = @"0";
    self.sellprice = @"0";
    self.hot = @"0";
    self.pageIndex = 1;
    
    
//    [self setUpNavigationBar];
    
//    [self setupHeaderView];
    
    [self.tableView registerClass:[ArtApplyCell class] forCellReuseIdentifier:tableViewCellIdentifer];
    
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
        // 增加数据
        [self.collectionView.mj_header  beginRefreshing];
        
        //网络请求
        [self refreshData];
        
        [self.collectionView.mj_header   endRefreshing];
        
    }];
    
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        
        [self.collectionView.mj_footer  beginRefreshing];
        
        [self loadMoreData];
        
        [self.collectionView.mj_footer  endRefreshing];
        
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UI
- (void)setUpNavigationBar{
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [backBtn setImage:[UIImage imageNamed:@"icon_navigationbar_back"]  forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:backBtn];
}


#pragma mark --头部View
-(void)setupHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    titleView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
    [_headerView addSubview:titleView];
    _headerView.backgroundColor = [UIColor whiteColor];
    NSArray * searchArray =@[@"类别",@"价格",@"热度"];
    for (int i = 0; i < searchArray.count; i++) {
        UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15+(kScreenW-32)/3.0*i, 0, (kScreenW-32)/3.0, 44)];
        searchBtn.tag = 200 + i;
        [searchBtn setTitle:searchArray[i] forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(touchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:searchBtn];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(searchBtn.centerX + 15, 14, 15, 15)];
        imageV.image = ImageNamed(@"search_sort_down");
        imageV.tag = 2000+i;
        [_headerView addSubview:imageV];
        if (i != 2) {
            UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(searchBtn.endX,11.5, 1, 20)];
            sepView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
            [_headerView addSubview:sepView];
        }
    }
    [self.view addSubview:_headerView];
}

#pragma mark - 点击事件
-(void)clickBack:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadSearchDataWithKeyWord:(NSString *)searchType
{
    NSString *getBundleID= [[Global sharedInstance] getBundleID];
    NSLog(@"2344444===postDic%@",getBundleID);
    NSDictionary * dict = @{
                            @"keyword" : searchType,
                            @"type":@"1",
                            @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"num":@"10",
                            //                            @"postuid":getBundleID,
                            @"topictype":@"4"
                            };
    kPrintLog(dict);
    [self showLoadingHUDWithTitle:@"搜索中" SubTitle:nil];
    __weak typeof(self)weakSelf = self;
    
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"search" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        
        [self.hudLoading hideAnimated:YES];
        _nullDataLable.hidden = YES;
        [self.collectionArrayM removeAllObjects];
        
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        kPrintLog(responseObject)
        [strongSelf.hudLoading hideAnimated:YES];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSLog(@"method = jianjieindex  \n response = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
            _nullDataLable.hidden = YES;
            for (NSDictionary *dic in responseObject) {
                
                [strongSelf.collectionArrayM addObject:[CangyouQuanDetailModel mj_objectWithKeyValues:dic]];
            }
            if (strongSelf.pageIndex > 1) {
                [strongSelf.collectionArrayM addObjectsFromArray:strongSelf.collectionArrayM];
            }
            if ([responseObject count] < 5) {
                
                [self.collectionView.mj_header   endRefreshing];
                [self.collectionView.mj_footer   endRefreshing];
                _nullDataLable.hidden = NO;
                
            }
            [self.collectionView reloadData];
            
            //            [self reloadData];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            _nullDataLable.hidden = YES;
            [self.collectionView.mj_header   endRefreshing];
            [self.collectionView.mj_footer   endRefreshing];
            if (self.collectionArrayM.count  == 0) {
                self.collectionView.mj_footer.hidden = YES;
            }
            else{
                [self.collectionArrayM removeAllObjects];
                self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [self showErrorHUDWithTitle:[responseObject objectForKey:@"msg"] SubTitle:nil Complete:nil];
            [self.collectionView reloadData];
        }
        [self.hudLoading hideAnimated:YES];
        
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        //        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self.hudLoading hideAnimated:YES];
        _nullDataLable.hidden = NO;
        [self.collectionView.mj_header   endRefreshing];
        [self.collectionView.mj_footer   endRefreshing];
    }];
}

-(void)clickBackground{
    self.selectCategoryBackgroundView.hidden = YES;
    [self.tableViewArrayM removeAllObjects];
    self.selectedCategory = 0;
}


-(void)touchTypeAction:(UIButton*)sender{
        
    NSArray *array = @[@"由高到低",@"由低到高"];
    NSUInteger tag = sender.tag;
    [self.tableViewArrayM removeAllObjects];
    if (tag == 200) {//类别
        self.selectedCategory = 1;
        [self.tableViewArrayM addObjectsFromArray:self.goodsCategorys];
        [self.tableViewArrayM addObject:@"全部"];
        
    }else if (tag == 201){//价格
        self.selectedCategory = 2;
        [self.tableViewArrayM addObjectsFromArray:array];
        
    }else if (tag == 202){//热度
        self.selectedCategory = 3;
        [self.tableViewArrayM addObjectsFromArray:array];
        
    }
    
    self.tableView.height = self.tableViewArrayM.count * CELLHEIGHT<kScreenH - 64*2?self.tableViewArrayM.count * CELLHEIGHT:kScreenH - 64*2;
    self.tableView.center = self.selectCategoryBackgroundView.center;
    
    
    //刷新tableview
    [self.tableView reloadData];
    
    //显示蒙版view
    self.selectCategoryBackgroundView.hidden = NO;
    [self.view bringSubviewToFront:self.selectCategoryBackgroundView];
    
}

#pragma mark - 加载数据

-(void)loadMoreData{
    self.pageIndex++;
    [self loadData];
}
-(void)refreshData{
    self.pageIndex = 1;
    [self loadData];
}

- (void)loadData{
    
    [self clickBackground];
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    NSDictionary *dict = @{ @"postuid":self.artId?:@"0",
                            @"gtype" : self.gtype ,
                            @"getpeople" : @"1" ,
                            @"topictype" : @"4",
                            @"sellprice" : self.sellprice,
                            @"hot" : self.hot,
                            @"page" : @(self.pageIndex),
                            @"num" : @"10",
                            @"cuid":[Global sharedInstance].userID?:@"0"
//                            @"huiyuan":_huiyuan
                            };
    NSLog(@"%@",dict);
    __weak typeof(self)weakSelf = self;
    [ArtRequest GetRequestWithActionName:@"topiclist" andPramater:dict succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        //近况
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (self.pageIndex==1){
                [self.collectionArrayM removeAllObjects];
            }
            [self.collectionArrayM addObjectsFromArray:[CangyouQuanDetailModel mj_objectArrayWithKeyValuesArray:responseObject]];
        }else{
            if(weakSelf.pageIndex==1){//没有相关数据
                [self.collectionArrayM removeAllObjects];
            }else{//没有更多数据
                
            }
        }
        [self.collectionView reloadData];
        
        [self hideHUD];
        
    } failed:^(id responseObject) {
        
        [self hideHUD];
    }];
    
}

#pragma mark - tableViewDelegate , dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArtApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifer forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.tableViewArrayM[indexPath.row] isKindOfClass:[NSString class]]) {
        cell.title.text = self.tableViewArrayM[indexPath.row];
    }else{
        GoodsCategoryModel *model = self.tableViewArrayM[indexPath.row];
        if (model.cname) {
            cell.title.text = model.cname;
        }else{
            cell.title.text = model.title;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtApplyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.pageIndex = 1;
    if (self.selectedCategory == 1) {//点击分类
        
        if([self.tableViewArrayM[indexPath.row] isKindOfClass:[GoodsCategoryModel class]]){
            //数据处理
            GoodsCategoryModel *model = self.tableViewArrayM[indexPath.row];
            self.gtype = model.goods_id;
            
            if (model.child) {
                NSLog(@"%@",cell.title.text);
                NSArray <GoodsCategoryModel *>*childArray = model.child;
                [self.tableViewArrayM removeAllObjects];
                [self.tableViewArrayM addObjectsFromArray:childArray];
                //处理tableview
                self.tableView.height = self.tableViewArrayM.count * CELLHEIGHT<kScreenH - 64*2?self.tableViewArrayM.count * CELLHEIGHT:kScreenH - 64*2;
                self.tableView.center = self.selectCategoryBackgroundView.center;
                [self.tableView reloadData];
            }else{
                //没有child
                [self loadData];
            }
            
        }else if([self.tableViewArrayM[indexPath.row] isKindOfClass:[NSString class]]){
            //全部
            self.gtype = @"0";
            [self loadData];
        }
    }else if (self.selectedCategory == 2){//价格排序
        //        UIButton *btn = [_headerView viewWithTag:201];
        UIImageView *imageV = [_headerView viewWithTag:2001];
        if (indexPath.row == 0) {//由高到低
            self.sellprice = @"1";
            imageV.image = ImageNamed(@"search_sort_down");
        }else if(indexPath.row == 1){//由低到高
            self.sellprice = @"2";
            imageV.image = ImageNamed(@"search_sort_up");
        }
        [self loadData];
    }else if (self.selectedCategory == 3){//热度排序
        UIImageView *imageV = [_headerView viewWithTag:2002];
        if (indexPath.row == 0) {//由高到低
            self.hot = @"1";
            imageV.image = ImageNamed(@"search_sort_down");
        }else if(indexPath.row == 1){//由低到高
            self.hot = @"2";
            imageV.image = ImageNamed(@"search_sort_up");
        }
        [self loadData];
    }
}

#pragma mark collectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionArrayM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopSearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionItemIdentifer forIndexPath:indexPath];
    CangyouQuanDetailModel *model = self.collectionArrayM[indexPath.row];
    
    NSArray* arrayYuanlai = [model.photos componentsSeparatedByString:@","];
    if (arrayYuanlai.count>0) {
        NSString* imgUrl = arrayYuanlai[0];
        [cell.imageView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgUrl] tempTmage:@"icon_Default_Product.png"];
    }
    cell.titleLabel.text = model.topictitle;
    cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    cell.price.text = [NSString stringWithFormat:@"¥%.2f",[model.sellprice floatValue]/100];
    if (indexPath.row%2 == 0) {
        cell.rightView2.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        cell.leftbotView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        cell.rightView2.hidden = NO;
        cell.leftbotView.hidden = NO;
        cell.rightbotView.hidden = YES;
    }else{
        cell.rightbotView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        cell.rightView2.hidden = YES;
        cell.leftbotView.hidden = YES;
        cell.rightbotView.hidden = NO;
    }
    if (indexPath.row == 0) {
        cell.rightView.hidden = NO;
        cell.rightView2.hidden = YES;
    }else{
        cell.rightView.hidden = YES;
        cell.rightView2.hidden = NO;
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionView被选中时调用的方法
    
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = self.collectionArrayM[indexPath.row].id;
    detailVC.topictype = @"4";
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.view.containingViewController.navigationController pushViewController:detailVC animated:YES];
}
@end
