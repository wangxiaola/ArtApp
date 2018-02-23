//
//  MSBPersonCenterArticleVC.m
//  meishubao
//
//  Created by T on 16/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBPersonCenterArticleVC.h"
#import "GeneralConfigure.h"

#import "MSBArticleDetailController.h"


#import "MSBPersonCenterFollowCell.h"
#import "MSBPersonCenterArticleCell.h"
#import "MSBShareContentView.h"

#import "MSBInfoStoreItem.h"

@interface MSBPersonCenterArticleVC ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *_datas;
    
    NSMutableArray<MSBInfoStoreItem*>* _modelList;
    NSString *_offset;
    NSString *_total;
}
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, weak) UILabel *totalArticleLab;
@end

@implementation MSBPersonCenterArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _datas = @[@{@"time":@"36分钟前",@"message":@"探索艺术语言 表现现实生活探索艺术语言 表现现实生活探索艺术语言 表现现实生活", @"article":@"内蒙古地区有很多人从事油画创作，我们这几个人只是其中的一小部分，其中有的人已经调离内蒙古，在外地工作。不管在哪里工作，大家都有许多共同点：1、都在描绘生活；2、都在寻找自己的艺术语言。这里发表几个人..."}, @{@"time":@"36分钟前", @"message":@"探索艺术语言 表现现实生活", @"article":@"内蒙古地区有很多人从事油画创作，我们这几个人只是其中的一小部分，其中有的人已经调离内蒙古，在外地工作。不管在哪里工作，大家都有许多共同点：1、都在描绘生活；2、都在寻找自己的艺术语言。这里发表几个人..."}];
    
//    [self.tableView reloadData];
    
     [self.tableView.header beginRefreshing];
    
    __weak __block typeof(self) weakSelf = self;
    self.deleteBlock = ^(UIButton *btn){
         [weakSelf.tableView setEditing:!weakSelf.tableView.isEditing animated:true];
        btn.selected = !btn.selected;
        if (btn.selected) {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"编辑" forState:UIControlStateNormal];
        }
    };
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
    return 110.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:[MSBPersonCenterArticleCell identifier]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSInteger row = indexPath.row;
    MSBInfoStoreItem *item = _modelList[row];
    MSBPersonCenterArticleCell *posterCell = (MSBPersonCenterArticleCell *)cell;
    [posterCell setModel:item];
    __weak __block typeof(self) weakSelf = self;
    
    posterCell.shareBlock = ^(UIImage *shareImage){
        MSBShareContentView * shareContentView = [MSBShareContentView shareInstance];
        [shareContentView setArticleDetialVC:weakSelf];
//        NSString *imageCachePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:item.share_image];
//        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageCachePath];
//        NDLog(@"分享图片:%@",image);
        shareContentView.post_type = @"1";
        shareContentView.post_id = item.post_id;
        [shareContentView shareTitle:item.share_title desc:item.share_desc url:item.share_url img:shareImage];
        [shareContentView show];
    };
    
    posterCell.commentBlock = ^(UIButton *btn){
        MSBArticleDetailController *articleVC = [MSBArticleDetailController new];
        articleVC.tid = item.post_id;
        [weakSelf.navigationController pushViewController:articleVC animated:YES];
    };
    
    posterCell.praiseBlock = ^(UIButton *btn){
        __weak __block typeof(self) weakSelf = self;
        [[LLRequestServer shareInstance] requestArticleDetailCommentPraisePostId:item.post_id commentId:nil videoId:nil artistId:nil orgId:nil parise:!item.is_praise type:1 success:^(LLResponse *response, id data) {
            item.is_praise = !item.is_praise;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(LLResponse *response) {
 
        } error:^(NSError *error) {
         
        }];

    };
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    MSBInfoStoreItem *item = _modelList[row];
    MSBArticleDetailController *articleVC = [MSBArticleDetailController new];
    articleVC.tid = item.post_id;
    [self.navigationController pushViewController:articleVC animated:YES];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    __weak __block typeof(self) weakSelf = self;
    MSBInfoStoreItem *item = _modelList[row];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf hudLoding];
       [[LLRequestServer shareInstance] requestDeletedCollectionWithType:1 post_id:item.post_id video_id:nil pic_url:nil success:^(LLResponse *response, id data) {

           [weakSelf showSuccess:@"删除成功"];
           [_modelList removeObjectAtIndex:row];
           [weakSelf.tableView reloadData];
       } failure:^(LLResponse *response) {
           
           [weakSelf showError:@"删除失败"];
       } error:^(NSError *error) {

           [weakSelf showError:@"删除失败"];
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
        [[LLRequestServer shareInstance] requestUserMyStoreItemsWithCollectType:@"1" offset:nil pagesize:10 success:^(LLResponse *response, id data) {
            [weakSelf.tableView.header endRefreshing];
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
                weakSelf.totalArticleLab.text =[NSString stringWithFormat:@"文章（%@）",[NSString notNilString:[NSString stringWithFormat:@"%@", data[@"total"]]]];
                NSArray *arr = [MSBInfoStoreItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
                _modelList = [NSMutableArray arrayWithArray:arr];
                //NSLog(@"数据数组 == %@",_modelList);
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
        [[LLRequestServer shareInstance] requestUserStoreItemsWithCollectType:@"1" uid:self.uid offset:nil pagesize:10 success:^(LLResponse *response, id data) {
            [weakSelf.tableView.header endRefreshing];
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
                weakSelf.totalArticleLab.text =[NSString stringWithFormat:@"文章（%@）",[NSString notNilString:[NSString stringWithFormat:@"%@", data[@"total"]]]];
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
}

- (void)appendData{
    __weak __block typeof(self) weakSelf = self;
    if ([NSString isNull:self.uid]) {
        [[LLRequestServer shareInstance] requestUserMyStoreItemsWithCollectType:@"1" offset:_offset pagesize:10 success:^(LLResponse *response, id data) {
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
        [[LLRequestServer shareInstance] requestUserStoreItemsWithCollectType:@"1" uid:self.uid offset:_offset pagesize:10 success:^(LLResponse *response, id data) {
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
        [self.view addSubview:_tableView];
        _tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        [_tableView registerClass:[MSBPersonCenterArticleCell class] forCellReuseIdentifier:[MSBPersonCenterArticleCell identifier]];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.header = header;
        self.tableView.footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(appendData)];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        
        UIView *headerView = [UIView new];
        headerView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.f);
        
        UILabel *totalArticleLab = [UILabel new];
        [totalArticleLab setTextColor:RGBCOLOR(181, 27, 32)];
        [totalArticleLab setFont:[UIFont systemFontOfSize:14.f]];
        [totalArticleLab setFrame:headerView.bounds];
        totalArticleLab.x = 15.f;
        [totalArticleLab setText:@"文章（0）"];
        self.totalArticleLab = totalArticleLab;
        [headerView addSubview:totalArticleLab];
        
        _tableView.tableHeaderView = headerView;
        
    }
    
    return _tableView;
}


@end
