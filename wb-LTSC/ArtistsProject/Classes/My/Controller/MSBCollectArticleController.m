//
//  MSBCollectArticleController.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBCollectArticleController.h"
#import "GeneralConfigure.h"
#import "HDSettingArrowCell.h"
#import "UITableView+Common.h"

#import "MSBInfoStoreItem.h"

@interface MSBCollectArticleController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray<MSBInfoStoreItem*>* _modelList;
    NSString *_offset;
}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MSBCollectArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView.header beginRefreshing];
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:[HDSettingArrowCell identifier]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    NSInteger row = indexPath.row;
    MSBInfoStoreItem *item = _modelList[row];
    HDSettingArrowCell *valueCell = (HDSettingArrowCell *)cell;
    [valueCell setModel:item];
}

- (void)refreshData{
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestServer shareInstance] requestUserStoreItemsWithCollectType:@"1" uid:nil offset:nil pagesize:10 success:^(LLResponse *response, id data) {
        [weakSelf.tableView.header endRefreshing];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
            NSArray *arr = [MSBInfoStoreItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
            _modelList = [NSMutableArray arrayWithArray:arr];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.footer resetNoMoreData];
        }

    } failure:^(LLResponse *response) {
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.footer noticeNoMoreData];
        [weakSelf.tableView.header endRefreshing];
    } error:^(NSError *error) {
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.footer noticeNoMoreData];
        [weakSelf.tableView.header endRefreshing];
    }];
}

- (void)appendData{
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestServer shareInstance] requestUserStoreItemsWithCollectType:@"1"  uid:nil offset:_offset pagesize:10 success:^(LLResponse *response, id data) {
        [weakSelf.tableView.footer endRefreshing];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
            NSArray *arr = [MSBInfoStoreItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
            if (_modelList) {
                [_modelList addObjectsFromArray:arr];
            } else {
                _modelList = [NSMutableArray arrayWithArray:arr];
            }
            [weakSelf.tableView reloadData];
        }

    }failure:^(LLResponse *response) {
        if (response.code == 10006) {
            [weakSelf.tableView.footer noticeNoMoreData];
        } else {
            [weakSelf.tableView.footer endRefreshing];
        }

    }error:^(NSError *error) {
     [weakSelf.tableView.footer endRefreshing];
    }];
}



#pragma mark - setter/getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        [self.view addSubview:_tableView];
        [_tableView registerClass:[HDSettingArrowCell class] forCellReuseIdentifier:[HDSettingArrowCell identifier]];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.header = header;
        self.tableView.footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(appendData)];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    }
    
    return _tableView;
}

@end
