//
//  LiveListController.m
//  ArtistsProject
//
//  Created by 黄兵 on 2018/2/8.
//  Copyright © 2018年 HELLO WORLD. All rights reserved.
//

#import "LiveListController.h"
#import "LiveListCell.h"
#import "LiveListHeaderView.h"
@interface LiveListController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
{
    UserInfoModel *userModel;
    UIView *menuView;
    BOOL isShowMenu;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SDCycleScrollView *imageScroll;
@end

@implementation LiveListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.imageScroll;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)createView{
    [super createView];
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
        userModel = [UserInfoModel modelWithDictionary:responseObject];
      
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
        if ([responseObject isKindOfClass:[NSArray class]]) {
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LiveListHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:@"LiveListHeaderView"owner:self options:nil]lastObject];
    if (section == 0) {
        view.title.text = @"最新展览";
    }if (section == 1) {
        view.title.text = @"往期直播";
    }else {
        view.title.text = @"精彩视频";
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"LiveListCell"];
    return listCell;
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
