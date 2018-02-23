//
//  MSBFollowRecommendController.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBFollowRecommendController.h"
#import "GeneralConfigure.h"
#import "UITableView+Common.h"
#import "MSBFollowCell.h"
#import "MSBFollowModel.h"
#import "MSBFollowItem.h"
@interface MSBFollowRecommendController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray<MSBFollowItem*>* _modelList;
    NSString *_offset;
}
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation MSBFollowRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:[MSBFollowCell identifier]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSInteger row = indexPath.row;
    __block  MSBFollowItem *model = _modelList[row];
    MSBFollowCell *valueCell = (MSBFollowCell *)cell;
    [valueCell setModel:model];
    __weak __block typeof(self) weakSelf = self;
    valueCell.followBlock = ^(UIButton *btn){
        [weakSelf hudLoding];
        
        NSString *uid;
        NSString *org_id;
        if (model.type == 1) {
            uid = model.payload.uid;
        }else{
            org_id = model.payload.org_id;
        }
        
        NSInteger state;
        if (btn.selected) {
            
            state = 0;
        }else {
        
            state = 1;
        }
        
        [[LLRequestServer shareInstance] requestUserPayAttentionWithUid:uid org_id:org_id type:model.type attention_status:state success:^(LLResponse *response, id data) {
            [weakSelf hiddenHudLoding];
            btn.selected =! btn.selected;
//            [weakSelf.tableView reloadData];
        } failure:^(LLResponse *response) {
             [weakSelf hiddenHudLoding];
        } error:^(NSError *error) {
             [weakSelf hiddenHudLoding];
             [weakSelf showError:@"网络出错"];
        }];
    };
   
}

- (void)refreshData{
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestServer shareInstance] requestUserAttentionListWithOffset:nil pagesize:10 type:self.followType success:^(LLResponse *response, id data) {
        [weakSelf.tableView.header endRefreshing];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
            NSArray *arr = [MSBFollowItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
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
    [[LLRequestServer shareInstance] requestUserAttentionListWithOffset:_offset pagesize:10 type:self.followType success:^(LLResponse *response, id data) {
        [weakSelf.tableView.footer endRefreshing];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
            NSArray *arr = [MSBFollowItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
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


// requestUserAttentionListWithOffset
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
        [_tableView registerClass:[MSBFollowCell class] forCellReuseIdentifier:[MSBFollowCell identifier]];
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

- (void)setFollowType:(MSBFollowType)followType{
    _followType = followType;
}

@end
