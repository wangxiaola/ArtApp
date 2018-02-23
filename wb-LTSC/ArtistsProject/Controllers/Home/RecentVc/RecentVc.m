//
//  WorksVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/29.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "RecentVc.h"
#import "RecentFirstCell.h"
#import "HomeListDetailVc.h"
#import "H5VC.h"
#import "AppraisalMeetingVC.h"
#import "YTXMyFriendsViewController.h"
#import "GoodsCategoryModel.h"
#import "SearchGoodsViewController.h"
#import "CangyouQuanDetailModel.h"
#import "ShopSearchListCell.h"
#import "MyHomePageDockerVC.h"
#import "UserInfoModel.h"
#import "HomeImageModel.h"
#import "ShoppingArtClassController.h"
#import "RecentInfoTableCell.h"
#import "RecentShopTableCell.h"
#import "RecentCourseTableCell.h"
#import "RecentHeaderView.h"
#define HEAD_CELL_HEIGHT (SCREEN_WIDTH/2+15)

@interface RecentVc ()<SDCycleScrollViewDelegate,UITableViewDelegate, UITableViewDataSource,RecentShopTableCellDelegate>
{
    MJRefreshAutoGifFooter *footer;
    NSMutableArray <HomeImageModel *> *imageArray;
    CGFloat zuibiao_X;
    UIScrollView *scroll;
    UserInfoModel *userModel;
    
}
@property(nonatomic,strong)NSMutableArray <HomeImageModel*>* recentArr;
@property (nonatomic, strong) SDCycleScrollView *imageScroll;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RecentVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.imageScroll;
}

- (void)createView{
    [super createView];
    imageArray = [NSMutableArray array];
    
    NSDictionary * dict = @{
                            @"gtype":self.gtype?self.gtype:@"0",
                            @"postuid":self.artId?self.artId:@"0",
                            @"cuid":[Global sharedInstance].userID?:@"0",
                            //                            @"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                            @"num":@"50",
                            @"zhiding":@"1",
                            @"toporder":@"1",
                            @"groupsel":@"1"
                            };
    [self.dataDic addEntriesFromDictionary:dict];
    _recentArr = [[NSMutableArray alloc]init];
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
}


//请求数据
- (void)updataDate{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [ArtRequest GetRequestWithActionName:@"goodstype" andPramater:nil succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        [self hideHUD];
    } failed:^(id responseObject) {
        
        [self hideHUD];
    }];
}



- (SDCycleScrollView *)imageScroll
{
    if (!_imageScroll) {
        _imageScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, 200) delegate:self placeholderImage:ImageNamed(@"loading_image")];
        _imageScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _imageScroll.autoScrollTimeInterval = 3.;// 自动滚动时间间隔
    }
    return _imageScroll;
}
//加载用户信息
- (void)loadUserData:(NSString *)artId
{
    
    //1.设置请求参数
    NSDictionary *dict = @{@"uid":artId?:@"0"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"userinfo" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        ResultModel *result=[ResultModel modelWithDictionary:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        userModel=[UserInfoModel modelWithDictionary:responseObject];
        MyHomePageDockerVC *vc = [[MyHomePageDockerVC alloc]init];
        vc.navTitle = @"劳特斯辰艺术家线上展厅";
        vc.artName = userModel.nickname;
        vc.artId = artId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.obj.navigationController pushViewController:vc animated:YES];
    }andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
    }];
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

}

-(void)loadMoreData{
    self.pageIndex++;
    [self loadData];
}
-(void)refreshData{
    self.pageIndex = 1;
    [self loadData];
}
-(void)loadData{
    
    __weak typeof(self)weakSelf = self;
    [self.dataDic setObject:[NSString stringWithFormat:@"%ld",self.pageIndex] forKey:@"page"];
    kPrintLog(self.dataDic);
    [ArtRequest GetRequestWithActionName:@"topiclist" andPramater:self.dataDic succeeded:^(id responseObject) {
        [self.hudLoading hideAnimated:YES];
        kPrintLog(responseObject);
        [self getScrollImage];
        [self updataDate];
        [self getTableList];
        //近况
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (self.pageIndex==1){
            }
            
        }else{
            if(weakSelf.pageIndex==1){//没有相关数据
                
            }else{//没有更多数据
            }
        }
    }failed:^(id responseObject){
        
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];
    }];
}
- (void)getScrollImage
{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    NSDictionary *dic = @{@"uid": @"001"};
    [ArtRequest GetRequestWithActionName:@"indexslide" andPramater:dic succeeded:^(id responseObject) {
        [self hideHUD];
        [imageArray removeAllObjects];
        [imageArray addObjectsFromArray:[HomeImageModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseObject]];
        kPrintLog(imageArray);
        NSMutableArray *picArray = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (HomeImageModel *model in imageArray) {
            [picArray addObject:[NSString stringWithFormat:@"%@!3b1",model.photo]];
            [titleArray addObject:model.title];
        }
        kPrintLog(picArray);
        _imageScroll.imageURLStringsGroup = picArray;// 图片
        //        _imageScroll.titlesGroup = titleArray;// 标题
    } failed:^(id responseObject) {
        [self hideHUD];
    }];
}

- (void)getTableList
{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    kWeakSelf;
    NSDictionary *dic = @{@"uid": @"002"};
    [ArtRequest GetRequestWithActionName:@"indexslide" andPramater:dic succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        //近况
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [_recentArr removeAllObjects];
            [_recentArr addObjectsFromArray:[HomeImageModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseObject]];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_footer setHidden:YES];
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:YES];
        }
        [weakSelf.tableView reloadData];
    } failed:^(id responseObject) {
        [self hideHUD];
    }];
}

// 点击商品
- (void)getRecentShopCellIndex:(NSInteger)index
{
    NSLog(@"%@",@"点击了");
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1){
        return 230 * 2;
        return HEAD_CELL_HEIGHT;
    }else{
        return 120;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RecentHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:@"RecentHeaderView"owner:self options:nil]lastObject];
    if (section == 0) {
        view.title.text = @"资讯推荐";
    }if (section == 1) {
        view.title.text = @"好物推荐";
    }else {
        view.title.text = @"课程推荐";
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RecentInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentInfoTableCell"];
        return cell;
        
    }if (indexPath.section == 1) {
        RecentShopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentShopTableCell"];
        cell.delegate = self;
        cell.shopList = nil;
        return cell;
        
    }else{
        RecentCourseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentCourseTableCell"];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        
    }else if (indexPath.section == 1){
        
    }else{
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

