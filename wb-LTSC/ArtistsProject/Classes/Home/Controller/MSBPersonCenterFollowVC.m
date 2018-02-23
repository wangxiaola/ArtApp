//
//  MSBPersonCenterFollowVC.m
//  meishubao
//
//  Created by T on 16/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBPersonCenterFollowVC.h"
#import "MSBArticleDetailController.h"
#import "GeneralConfigure.h"

#import "MSBUserFollowPoster.h"

#import "MSBFollowPosterCell.h"
@interface MSBPersonCenterFollowVC ()<UITableViewDelegate, UITableViewDataSource>{
    NSString *_offset;
    NSMutableArray<MSBUserFollowPoster*>* _modelList;
}

@property (strong, nonatomic) UITableView *tableView;
@end

@implementation MSBPersonCenterFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    if (_tableView) {
        
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    MSBUserFollowPoster *item = _modelList[row];
    return [MSBFollowPosterCell rowHeight:item cellWidth:tableView.frame.size.width];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:[MSBFollowPosterCell identifier]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSInteger row = indexPath.row;
    MSBUserFollowPoster *item = _modelList[row];
    MSBFollowPosterCell *posterCell = (MSBFollowPosterCell *)cell;
    __weak __block typeof(self) weakSelf = self;
    posterCell.praiseBlock = ^(UIButton *btn){
        [[LLRequestBaseServer shareInstance] requestArticleDetailCommentPraisePostId:nil commentId:item.comment_id  videoId:nil artistId:nil orgId:nil parise:!item.is_praise type:2 success:^(LLResponse *response, id data) {
            item.is_praise = !item.is_praise;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(LLResponse *response) {
            
        } error:^(NSError *error) {
            
        }];

    };
    [posterCell setModel:item];
    
    posterCell.articleBlock = ^(){
        MSBArticleDetailController *articleVC = [MSBArticleDetailController new];
        articleVC.tid = item.post_id;
        [weakSelf.navigationController pushViewController:articleVC animated:YES];
    };
}


- (void)refreshData{
    __weak __block typeof(self) weakSelf = self;
    NSString *token = nil;
    if ([NSString isNull:self.uid]) {
        token = [MSBAccount getToken];
    }
    [[LLRequestBaseServer shareInstance] requestUserFollowPosterWithOffset:nil pagesize:10 token:token uid:self.uid success:^(LLResponse *response, id data) {
        [weakSelf.tableView.header endRefreshing];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
            NSArray *arr = [MSBUserFollowPoster mj_objectArrayWithKeyValuesArray:data[@"items"]];
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
    NSString *token = nil;
    if ([NSString isNull:self.uid]) {
        token = [MSBAccount getToken];
    }
    [[LLRequestBaseServer shareInstance] requestUserFollowPosterWithOffset:_offset pagesize:10 token:token uid:self.uid success:^(LLResponse *response, id data) {
        [weakSelf.tableView.footer endRefreshing];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
            NSArray *arr = [MSBUserFollowPoster mj_objectArrayWithKeyValuesArray:data[@"items"]];
            if (_modelList) {
                [_modelList addObjectsFromArray:arr];
            } else {
                _modelList = [NSMutableArray arrayWithArray:arr];
            }
            [weakSelf.tableView reloadData];
        }
    } failure:^(LLResponse *response) {
        if (response.code == 10006) {
            [weakSelf.tableView.footer noticeNoMoreData];
        } else {
            [weakSelf.tableView.footer endRefreshing];
        }
    } error:^(NSError *error) {
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
        [_tableView registerClass:[MSBFollowPosterCell class] forCellReuseIdentifier:[MSBFollowPosterCell identifier]];
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
