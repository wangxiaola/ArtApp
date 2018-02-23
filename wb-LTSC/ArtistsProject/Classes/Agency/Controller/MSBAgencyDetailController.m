//
//  MSBAgencyDetailController.m
//  meishubao
//
//  Created by T on 16/12/23.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBAgencyDetailController.h"
#import "MSBAgencyArticleSearchVC.h"
#import "GeneralConfigure.h"

#import "MSBAgencyDetailHeaderView.h"

@interface MSBAgencyDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, weak) MSBAgencyDetailHeaderView  *headerView;

@end

@implementation MSBAgencyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setTitle:@"机构详情"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self requestData];
    
    __weak __block typeof(self) weakSelf = self;
    self.headerView.btnClickBlock = ^(){
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.tableView.contentInset = UIEdgeInsetsMake(-246, 0, 0, 0);
        }];
    };

    self.headerView.searchBlock = ^(){
        HomeSearchViewController *searchVC = [HomeSearchViewController new];
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HeadLineGeneralCell rowHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:[HeadLineGeneralCell identifier]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    HeadLineGeneralCell *generalCell = (HeadLineGeneralCell *)cell;
//    [generalCell setArticleModel:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MSBArticleDetailController *detailVC = [MSBArticleDetailController new];
    detailVC.tid = @"10219";
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)requestData{
    __weak __block typeof(self) weakSelf = self;
    [self hudLoding];
    [[LLRequestServer shareInstance] requestAgencyDetailWithOrgId:self.orgId success:^(LLResponse *response, id data) {
        [weakSelf hiddenHudLoding];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *images = [NSMutableArray array];
            for (NSDictionary *pic in data[@"org_pic"]) {
                [images addObject:pic[@"url"]];
            }
            [weakSelf.headerView setImages:images message:[NSString filterHTML:data[@"intro"]]];
            [weakSelf.tableView reloadData];
        }
    } failure:^(LLResponse *response) {
         [weakSelf hiddenHudLoding];
          [weakSelf.headerView setImages:nil message:nil];
         [weakSelf.tableView reloadData];
    } error:^(NSError *error) {
         [weakSelf hiddenHudLoding];
          [weakSelf.headerView setImages:nil message:nil];
         [weakSelf.tableView reloadData];
    }];
}

#pragma mark - setter/getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
//        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        [self.view addSubview:_tableView];
        [_tableView registerClass:[HeadLineGeneralCell class] forCellReuseIdentifier:[HeadLineGeneralCell identifier]];
        
        MSBAgencyDetailHeaderView *headerView = [MSBAgencyDetailHeaderView new];
        // 350
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 305);
        _tableView.tableHeaderView = headerView;
        self.headerView = headerView;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    }
    
    return _tableView;
}

- (void)setOrgId:(NSString *)orgId{
    _orgId = orgId;
}

@end
