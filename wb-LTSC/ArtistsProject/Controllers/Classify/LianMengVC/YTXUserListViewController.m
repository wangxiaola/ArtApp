//
//  YTXUserListViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/8.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXUserListViewController.h"
#import "YTXFriendsTableViewCell.h"
#import "MyHomePageDockerVC.h"
#import "YTXInviteUserModel.h"
#import "YTXInviteUserCell.h"

@interface YTXUserListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * mArrayData;

@property (nonatomic, strong) NSMutableArray * mArrayIndexs;//索引数组

@property (nonatomic, strong) NSMutableDictionary * mDictData;//原始数据字典

@property (nonatomic, assign) NSInteger page;

@end

@implementation YTXUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataMode = HNoDataModeDefault;
    [self fetchData];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)fetchData {
    NSDictionary * dict = @{
                            @"uid" : [NSString stripNullWithString:[Global sharedInstance].userID],
                            @"level" : _level,
                            };
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"invitedlist" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *infoArray = [responseObject objectForKey:@"info"];
            for (int i = 0; i < infoArray.count; i++) {
                NSDictionary *dic = [infoArray objectAtIndex:i];
                YTXInviteUserModel * model = [YTXInviteUserModel modelWithDictionary:dic];
                [self.mArrayData addObject:model];
            }
            [self.tableView reloadData];
        } else {
            //[self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        }
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        //[self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self.hudLoading hideAnimated:YES];
    }];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mArrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTXInviteUserCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXInviteUserTableViewCell];
    cell.model = [self.mArrayData objectAtIndex:indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YTXInviteUserModel * viewModel = [self.mArrayData objectAtIndex:indexPath.section];
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = viewModel.uname;
    vc.artId = viewModel.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    }
    return [self.mArrayIndexs objectAtIndex:section];
}

//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.mArrayIndexs;
}

//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        return NSNotFound;
    }
    else
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
    }
}
#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self fetchData];
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = 55;
        [_tableView registerNib:[UINib nibWithNibName:@"YTXInviteUserCell" bundle:nil] forCellReuseIdentifier:kYTXInviteUserTableViewCell];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)mArrayData {
    if (!_mArrayData) {
        _mArrayData = [[NSMutableArray alloc]init];
    }
    return _mArrayData;
}

- (NSMutableArray *)mArrayIndexs {
    if (!_mArrayIndexs) {
        _mArrayIndexs = [[NSMutableArray alloc]init];
    }
    return _mArrayIndexs;
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
