//
//  MemberMallListController.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MemberMallListController.h"
#import "MemSearchView.h"
#import "ShopSearchListCell.h"
#import "ShoppingMallCollectionViewCell.h"
#define LEFTVIEWWIDTH 90
#define MINIMUNSPACE 15
#define NUMBEROFCOLUMN 2
#define CELLHEIGHT 50

static NSString *tableViewCellIdentifer = @"GoodsCategoryTableViewCell";
static NSString *collectionItemIdentifer = @"SearchGoodsCollectionViewItem";
static NSString *collectionHeaderIdentifer = @"HeaderIdentifier";
@interface MemberMallListController ()<MemSearchDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
{
    MemSearchView  *_search;
    UILabel * _nullDataLable;
    UIScrollView *scroll;
    CGFloat zuibiao_X;
    NSMutableArray *allArray;
    NSString *gtype;
    NSString *zhiding;
}
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *tableViewDataM;
@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *collectionDataM;
//
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong)NSMutableArray <CangyouQuanDetailModel *>*collectionArrayM;

@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic,copy)NSString *searchWord;

@end

@implementation MemberMallListController
//
- (NSMutableArray *)tableViewDataM{
    if (!_tableViewDataM) {
        _tableViewDataM = [NSMutableArray array];
    }
    return _tableViewDataM;
}
- (NSMutableArray<GoodsCategoryModel *> *)collectionDataM
{
    if (!_collectionDataM) {
        _collectionDataM = [[NSMutableArray alloc] init];
    }
    return _collectionDataM;
}
- (UIView *)navigationBarView{
    if (!_navigationBarView) {
        
        _navigationBarView  = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
        [self.view addSubview:_navigationBarView];
        
    }
    return _navigationBarView;
}
- (NSMutableArray *)collectionArrayM{
    if (!_collectionArrayM) {
        _collectionArrayM = [NSMutableArray array];
    }
    return _collectionArrayM;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH ) / 2;
        flowLayout.itemSize = CGSizeMake(width, width + 45);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 50, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _navigationBarView.endY+ 51, SCREEN_WIDTH, SCREEN_HEIGHT - 51-10) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ShopSearchListCell class] forCellWithReuseIdentifier:collectionItemIdentifer];
        [_collectionView registerClass:[ShoppingMallCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


#pragma mark - UI
- (void)setUpNavigationBar{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [backBtn setImage:[UIImage imageNamed:@"icon_navigationbar_back"]  forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:backBtn];
    _search = [[MemSearchView alloc] initWithFrame:CGRectMake(35, 5, kScreenW - 70-15, 35)];
    _search.delegate = self;
    _search.search.delegate = self;
    __weak __typeof(MemSearchView *)weakSearch = _search;
    kWeakSelf;
    [_search setYYGetCancel:^(NSString * title)
     {
         weakSearch.search.text = @"";
         weakSelf.pageIndex = 1;
         [weakSelf reloadData];
     }];
    
    [_search setYYGetTitle:^(NSString * title){
        _searchWord = [NSString stringWithFormat:@"%@",title];
        [weakSelf loadSearchDataWithKeyWord:title];
    }];
    [self.navigationBarView addSubview:_search];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW- 35, 12, 20, 20)];
    [rightButton addTarget:self action:@selector(rightPublicAction) forControlEvents:UIControlEventTouchUpInside];
    //    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navigationBarView addSubview:rightButton];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenW, 1)];
    view.backgroundColor = BACK_VIEW_COLOR;
    [self.navigationBarView addSubview:view];
}
- (void)rightPublicAction{
    if ([Global sharedInstance].isgroup.integerValue != 1) {
        [ArtUIHelper addHUDInView:self.view text:@"暂无权限" hideAfterDelay:1.0];
        return;
    }
    PublishDongtaiVC *vc=[[PublishDongtaiVC alloc]init];
    vc.topictype = @"4";// 商品类型
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 搜索视图消息代理方法
- (void)menSearchNewMessage:(UIButton *)button
{
    [self.view endEditing:YES];
    [button setTitle:@"" forState:(UIControlStateNormal)];
}
//请求数据
- (void)updataDate{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [ArtRequest GetRequestWithActionName:@"goodstype" andPramater:nil succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        [self hideHUD];
        [self.tableViewDataM addObjectsFromArray:[GoodsCategoryModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseObject]];
        //选中第一个cell
        if (self.tableViewDataM.count) {
            if (self.tableViewDataM[0].child) {
                [self.collectionDataM addObjectsFromArray: self.tableViewDataM[0].child];
                [self.collectionView reloadData];
                
            }
        }
        
    } failed:^(id responseObject) {
        
        [self hideHUD];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    _titleArray = [NSMutableArray array];
    [_titleArray addObject:@"今日推荐"];
    for (GoodsCategoryModel *model in self.collArray) {
        [_titleArray addObject:model.title];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 70, kScreenW, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    NSString *string = [_titleArray componentsJoinedByString:@""];
    CGSize size1 = [self sizeForLblContent:string fixMaxWidth:CGFLOAT_MAX andFondSize:14];
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, kScreenW - 30, 40)];
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.pagingEnabled = NO;
    scroll.userInteractionEnabled = YES;
    scroll.scrollEnabled = YES;
    scroll.contentSize = CGSizeMake(1*kScreenW, 0);
    [view addSubview:scroll];
    for (NSInteger i = 0; i<_titleArray.count ; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = _titleArray[i];
        label.font = [UIFont systemFontOfSize:14];
        label.tag = i + 1;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentLeft;
        CGSize size = [self sizeForLblContent:_titleArray[i] fixMaxWidth:CGFLOAT_MAX andFondSize:14];
        label.frame = CGRectMake(zuibiao_X + (1*kScreenW-size1.width-30)/(_titleArray.count-1)*i , 5, size.width, 30);
        zuibiao_X = size.width+zuibiao_X;
        if (i == 0) {
            label.textColor = [UIColor hexChangeFloat:@"ebb263"];
        }
        [scroll addSubview:label];
        UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelAction:)];
        [label addGestureRecognizer:tapLabel];
    }
    UIView *botview = [[UIView alloc] initWithFrame:CGRectMake(0, scroll.endY, kScreenW, 1)];
    botview.backgroundColor = BACK_VIEW_COLOR;
    [view addSubview:botview];
    self.pageIndex = 1;
    gtype = @"0";
    zhiding = @"1";
    // Do any additional setup after loading the view.
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
- (void)tapLabelAction:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    NSInteger tag  = label.tag;
    for (UILabel *templabel in scroll.subviews) {
        if (label == templabel) {
            templabel.textColor = [UIColor hexChangeFloat:@"ebb263"];
        }else{
            templabel.textColor = [UIColor blackColor];
        }
    }
    if (label.tag == 1) {
        _pageIndex = 1;
        zhiding = @"1";
        gtype = @"0";
    }else{
        zhiding = @"0";
        GoodsCategoryModel *model = _collArray[tag-2];
        self.pageIndex=1;
        gtype = model.goods_id;
    }
    [self reloadData];
}
// 通过给定文字和字体大小在指定的最大宽度下，计算文字实际所占的尺寸
- (CGSize)sizeForLblContent:(NSString *)strContent fixMaxWidth:(CGFloat)w andFondSize:(int)fontSize{
    // 先获取文字的属性，特别是影响文字所占尺寸相关的
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 把该属性放到字典中
    NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:font,NSFontAttributeName, nil];
    // 通过字符串的计算文字所占尺寸方法获取尺寸
    CGSize size = [strContent boundingRectWithSize:CGSizeMake(0, w) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicAttr context:nil].size;
    return size;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 点击事件
-(void)clickBack:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for (UILabel *templabel in scroll.subviews) {
        templabel.textColor = [UIColor blackColor];
    }
    gtype = @"";
    zhiding = @"";
    [_search.search resignFirstResponder];
    _searchWord = textField.text;
    [self loadSearchDataWithKeyWord:_searchWord];
    NSLog(@"点击了搜索");
    return YES;
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
                            @"huiyuan":@"1",
                            //                            @"postuid":getBundleID,
                            @"topictype":@"4"
                            };
    NSLog(@"postDic%@",dict);
    
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
        kPrintLog(responseObject);
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.collectionArrayM removeAllObjects];
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
#pragma mark - 加载数据

-(void)loadMoreData{
    self.pageIndex++;
    [self reloadData];
}
-(void)refreshData{
    self.pageIndex = 1;
    [self reloadData];
}

-(void)reloadData{
    
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    NSDictionary *dict = @{
                           @"type":@"1",
                           @"zhiding":zhiding?:@"0",
                           @"gtype":gtype?:@"0",
                            @"topictype" : @"4",
                            @"page" : @(self.pageIndex),
                            @"num" : @"10",
                            @"huiyuan":@"1"
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
#pragma mark collectionViewDelegate
#pragma mark - 头部视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return  CGSizeMake(kScreenW, 35);
//    }else{
        return CGSizeZero;
//    }
}
#pragma mark - 头部视图内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头视图
//    if (indexPath.section == 0) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.font = kFont(17);
        title.frame = CGRectMake(0 , 0, kScreenW, 30);
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"今日推荐";
        [header addSubview:title];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 34, kScreenW, 1)];
        view.backgroundColor = BACK_VIEW_COLOR;
        [header addSubview:view];
        return header;
//    }else{
//        return nil;
//    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    if (section == 1) {
//        return UIEdgeInsetsMake(15, 15, 15, 15);
//    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
//    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 30 - 45) / 4;
    CGSize itemSize = CGSizeMake(width, width * 1.5);
//    if (indexPath.section == 1) {
//        return itemSize;
//    }else{
        return CGSizeMake(kScreenW/2, kScreenW/2+45);
//    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (section == 1) {
//        return self.collArray.count;
//    }
    return self.collectionArrayM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1) {
//        ShoppingMallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
//        
//        // 取出图片名称
//        NSString *url = self.collArray[indexPath.row].imgurl;
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
//        // 取出文字
//        cell.titleLabel.text = self.collArray[indexPath.row].title;
//        //    cell.backgroundColor = [UIColor lightGrayColor];
//        return cell;
//    }
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


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionView被选中时调用的方法
//    if (indexPath.section == 0) {
//        
//    }else{
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = self.collectionArrayM[indexPath.row].id;
    detailVC.topictype = @"4";
    [self.navigationController pushViewController:detailVC animated:YES];
//    }
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
