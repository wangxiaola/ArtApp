

//
//  MSBCollectVideoController.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBCollectVideoController.h"
#import "MSBYZHDetailController.h"
#import "GeneralConfigure.h"
#import "MSBInfoStoreItem.h"

@interface MSBCollectVideoController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray<MSBInfoStoreVideoItem*>* _modelList;
    NSString *_offset;
}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MSBCollectVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self.tableView.mj_header beginRefreshing];
    __weak __block typeof(self) weakSelf = self;
   
    self.deleteBlock = ^(UIButton *btn){
        NSLog(@"MSBCollectVideoController deleteBlock");
        [weakSelf.tableView setEditing:!weakSelf.tableView.isEditing animated:true];
        btn.selected = !btn.selected;
        if (btn.selected) {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"编辑" forState:UIControlStateNormal];
        }

    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:[MSBYZHCell identifier]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSInteger section = indexPath.section;
    MSBInfoStoreVideoItem *item = _modelList[section];
    MSBYZHCell *valueCell = (MSBYZHCell *)cell;
    [valueCell setInfoStoreModel:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 13.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MSBInfoStoreVideoItem *item = _modelList[indexPath.section];
    MSBYZHDetailController *vc = [MSBYZHDetailController new];
    vc.wantsNavigationBarVisible = NO;
    vc.videoUrl = item.video;
    vc.videoId = item.video_id;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    __weak __block typeof(self) weakSelf = self;
    MSBInfoStoreVideoItem *item = _modelList[section];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf hudLoding];
        [[LLRequestServer shareInstance] requestDeletedCollectionWithType:2 post_id:nil video_id:item.video_id pic_url:nil success:^(LLResponse *response, id data) {
            [weakSelf hiddenHudLoding];
            [weakSelf hudTip:@"删除成功"];
            [_modelList removeObjectAtIndex:section];
            [weakSelf.tableView reloadData];
        } failure:^(LLResponse *response) {
            [weakSelf hiddenHudLoding];
            [weakSelf hudTip:@"删除失败"];
        } error:^(NSError *error) {
            [weakSelf hiddenHudLoding];
            [weakSelf hudTip:@"删除失败"];
        }];

    }];
    
    if ([NSString isNull:self.uid]) {
        return @[deleteRowAction];
    }
    return nil;
    
}


- (void)refreshData{
    __weak __block typeof(self) weakSelf = self;
  
    if ([NSString isNull:self.uid]) {
        [[LLRequestServer shareInstance] requestUserMyStoreItemsWithCollectType:@"2" offset:nil pagesize:10 success:^(LLResponse *response, id data) {
            [weakSelf.tableView.header endRefreshing];
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
                NSArray *arr = [MSBInfoStoreVideoItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
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
    }else{
        [[LLRequestServer shareInstance] requestUserStoreItemsWithCollectType:@"2" uid:self.uid offset:nil pagesize:10 success:^(LLResponse *response, id data) {
            [weakSelf.tableView.header endRefreshing];
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
                NSArray *arr = [MSBInfoStoreVideoItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
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
}

- (void)appendData{
    __weak __block typeof(self) weakSelf = self;

    if ([NSString isNull:self.uid]) {
        [[LLRequestServer shareInstance] requestUserMyStoreItemsWithCollectType:@"2" offset:_offset pagesize:10 success:^(LLResponse *response, id data) {
            [weakSelf.tableView.footer endRefreshing];
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
                NSArray *arr = [MSBInfoStoreVideoItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
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
    }else{

        [[LLRequestServer shareInstance] requestUserStoreItemsWithCollectType:@"2"  uid:self.uid offset:_offset pagesize:10 success:^(LLResponse *response, id data) {
            [weakSelf.tableView.footer endRefreshing];
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
                NSArray *arr = [MSBInfoStoreVideoItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
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
    
}


#pragma mark - setter/getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        [self.view addSubview:_tableView];
        [_tableView registerClass:[MSBYZHCell class] forCellReuseIdentifier:[MSBYZHCell identifier]];
        
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
