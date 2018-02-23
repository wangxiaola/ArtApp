//
//  YTXTagsViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/8.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXTagsViewController.h"
#import "YTXTagsTableViewCell.h"
#import "YTXTagsModel.h"
#import "YTXUserTagListViewController.h"

static NSString * const kYTXTagsTableViewCell = @"YTXTagsTableViewCell";

@interface YTXTagsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) YTXTagsModel * model;

@end

@implementation YTXTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"标签";
    self.noDataMode = HNoDataModeDefault;
    [self fetchTags];
    // Do any additional setup after loading the view.
}

#pragma mark - Fetch Data

- (void)fetchTags {
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"authuserlist" andPramater:nil andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        [self reloadData];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.model = [YTXTagsModel modelWithDictionary:responseObject];
        }
        [self.hudLoading hideAnimated:YES];
        [self reloadData];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self.hudLoading hideAnimated:YES];
        [self reloadData];
    }];
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.model.czlx.count;
    }
    if (section == 1) {
        return self.model.rzlx.count;
    }
    return self.model.biaoqian.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTXTagsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXTagsTableViewCell];
    YTXTagsViewModel * model = nil;
    if (indexPath.section == 0) {
        model = [self.model.czlx objectOrNilAtIndex:indexPath.row];
    }
    if (indexPath.section == 1) {
        model =  [self.model.rzlx objectOrNilAtIndex:indexPath.row];
    }
    model =  [self.model.biaoqian objectOrNilAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTXTagsViewModel * model = nil;
    if (indexPath.section == 0) {
        model = [self.model.czlx objectOrNilAtIndex:indexPath.row];
    }
    if (indexPath.section == 1) {
        model =  [self.model.rzlx objectOrNilAtIndex:indexPath.row];
    }
    model =  [self.model.biaoqian objectOrNilAtIndex:indexPath.row];
    YTXUserTagListViewController * vc = [[YTXUserTagListViewController alloc]init];
    vc.tag = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"创作类型";
    }
    if (section == 1) {
        return @"认证类型";
    }
    return @"标签";
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
        [_tableView registerNib:[UINib nibWithNibName:kYTXTagsTableViewCell bundle:nil] forCellReuseIdentifier:kYTXTagsTableViewCell];
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
