//
//  YTXUserTagListViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/13.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXUserTagListViewController.h"
#import "YTXFriendsTableViewCell.h"
#import "UIScrollView+YTXRefreshControl.h"
#import "MyHomePageDockerVC.h"

@interface YTXUserTagListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * mArrayUsers;
@property (nonatomic, assign) NSInteger page;//页码

@end

@implementation YTXUserTagListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    _page = 1;
    self.title = _tag;
    self.noDataMode = HNoDataModeDefault;
    _mArrayUsers = @[].mutableCopy;
    [super viewDidLoad];
    [self fetchUserList];
    // Do any additional setup after loading the view.
}

- (void)fetchUserList {
    NSDictionary * dict =  @{
                                @"page" : [NSString stringWithFormat:@"%d",(int)_page],
                                @"num" : @"5",
                                @"tag" : _tag,
                                };
   
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"searchtaguser" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        [self reloadData];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (self.page == 1) {
                [_mArrayUsers removeAllObjects];
            }
            if ([responseObject count] < 5) {
                [self.tableView endRefreshingWithNoMoreData];
            }
            for (NSDictionary * dict in responseObject) {
                YTXUser * model = [YTXUser modelWithDictionary:dict];
                YTXFriendsViewModel * viewModel = [YTXFriendsViewModel modelWithFriendsModel:model];
                [_mArrayUsers addObject:viewModel];
            }
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView endRefreshingWithNoMoreData];
            [self showErrorHUDWithTitle:[responseObject objectForKey:@"msg"] SubTitle:nil Complete:nil];
        }
        [self reloadData];
        
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self.hudLoading hideAnimated:YES];
        [self reloadData];
    }];
}

#pragma mark - Private Methods

- (void)reloadData {
    [self.tableView endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_mArrayUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTXFriendsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXFriendsTableViewCell];
    cell.model = [_mArrayUsers objectOrNilAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTXFriendsViewModel * viewModel = [_mArrayUsers objectOrNilAtIndex:indexPath.row];
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = viewModel.name;
    vc.artId = viewModel.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [self fetchUserList];
}

#pragma mark - Getter

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.rowHeight = 55.0f;
        __weak typeof(self)weakSelf = self;
        [_tableView headerRefreshingWithBlock:^{
            weakSelf.page = 1;
            [weakSelf fetchUserList];
        }];
        
        [_tableView footerRefreshingWithBlock:^{
            weakSelf.page++;
            [weakSelf fetchUserList];
        }];
        
        [_tableView registerNib:[UINib nibWithNibName:kYTXFriendsTableViewCell bundle:nil] forCellReuseIdentifier:kYTXFriendsTableViewCell];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
