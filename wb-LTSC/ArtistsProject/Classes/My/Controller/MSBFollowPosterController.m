//
//  MSBFollowPosterController.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

/**跟帖*/
#import "MSBFollowPosterController.h"
#import "MSBArticleDetailController.h"
#import "GeneralConfigure.h"

#import "MSBUserFollowPoster.h"
#import "MSBFollowPosterCell.h"

@interface MSBFollowPosterController ()<UITableViewDelegate, UITableViewDataSource>{
    NSString *_offset;
    NSMutableArray<MSBUserFollowPoster*>* _modelList;
}

@property(nonatomic,strong) UIView *headerView;
@property (nonatomic, weak) UIImageView  *iconImageView;
@property (nonatomic, weak) UILabel *nickName;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MSBFollowPosterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"跟帖";
    
    [self.tableView.header beginRefreshing];
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
        
        if (item.praise == 0) {
            
            item.praise = 1;
        }else {
        
            item.praise = 0;
        }
        
        [[LLRequestBaseServer shareInstance] requestArticleDetailCommentPraisePostId:nil commentId:item.comment_id  videoId:nil artistId:nil orgId:nil parise:item.praise type:2 success:^(LLResponse *response, id data) {
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshData{
    NSString *token = nil;
    if ([NSString isNull:self.uid]) {
        token = [MSBAccount getToken];
    }
    
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestBaseServer shareInstance] requestUserFollowPosterWithOffset:nil pagesize:10 token:token
                                                                       uid:self.uid success:^(LLResponse *response, id data) {
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
    [[LLRequestBaseServer shareInstance] requestUserFollowPosterWithOffset:_offset pagesize:10 token:token
                                                                       uid:self.uid success:^(LLResponse *response, id data) {
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, APP_NAVIGATIONBAR_H, self.view.width, SCREEN_HEIGHT - APP_NAVIGATIONBAR_H) style:UITableViewStylePlain];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        if (@available(iOS 11.0, *)) {
//            _tableView.insetsLayoutMarginsFromSafeArea = NO;
//        } else {
//            // Fallback on earlier versions
//        }
        _tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        [self.view addSubview:_tableView];
        [_tableView registerClass:[MSBFollowPosterCell class] forCellReuseIdentifier:[MSBFollowPosterCell identifier]];
        _tableView.tableHeaderView = self.headerView;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.header = header;
        self.tableView.footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(appendData)];
    }
    return _tableView;
}



- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        [_headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190.f)];
         _headerView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        UIImageView *iconImageView = [UIImageView new];
        [_headerView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        MSBUser *user = [MSBAccount getUser];
        if (user.avarImage) {
            iconImageView.image = user.avarImage;
        }else{
            iconImageView.image = [UIImage imageNamed:@"people_collection_cell"];
        }
        [iconImageView setFrame:CGRectMake((SCREEN_WIDTH - 100) * 0.5, 32, 100, 100)];
        [iconImageView.layer setCornerRadius:50.f];
        iconImageView.layer.borderColor = [UIColor redColor].CGColor;
        iconImageView.layer.borderWidth = 0.5;
        [iconImageView setClipsToBounds:YES];
        [iconImageView setContentMode:UIViewContentModeScaleAspectFill];
        
        UILabel *nickName = [UILabel new];
        self.nickName = nickName;
        [_headerView addSubview:nickName];
        [nickName setTextAlignment:NSTextAlignmentCenter];
        [nickName setText:user.nickname];
        nickName.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        [nickName setFont:[UIFont boldSystemFontOfSize:17]];
        [nickName setFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + 12, SCREEN_WIDTH, 30.f)];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        [_headerView.layer addSublayer:lineLayer];
        [lineLayer setFrame:CGRectMake(0, 189.5f, SCREEN_WIDTH, 0.5f)];
        lineLayer.dk_backgroundColorPicker = DKColorPickerWithRGB(0xaaaaaa, 0x282828);
    }
    return _headerView;
}

- (void)setUid:(NSString *)uid{
    _uid = uid;
}

@end
