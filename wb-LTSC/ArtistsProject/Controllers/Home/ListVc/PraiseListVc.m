//
//  PraiseListVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "PraiseListVc.h"
#import "PrivateListCell.h"
#import "MessageModel.h"
#import "MyHomePageDockerVC.h"

@interface PraiseListVc ()
@property(nonatomic,strong)NSMutableArray* lisrArr;
@end

@implementation PraiseListVc

-(void)createView{
    [super createView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    self.tabView.separatorColor=[UIColor grayColor];//分割线颜色
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSDictionary * dict = @{
                            @"topicid" : [NSString stripNullWithString:self.topicid],
                            @"cuid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0",
                            @"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                            @"num":@"10",
                            };
    
    [self.dataDic addEntriesFromDictionary:dict];
    _lisrArr = [[NSMutableArray alloc]init];
 [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
}
-(void)loadMoreData{
    self.pageIndex++;
    [self loadData];
}
-(void)refreshData{
    self.pageIndex = 1;
    [self loadData];
}

-(void)loadData{
    
   
    __weak typeof(self)weakSelf = self;
    [self.dataDic setObject:[NSString stringWithFormat:@"%ld",self.pageIndex] forKey:@"page"];
    [ArtRequest GetRequestWithActionName:@"topiclikeuser" andPramater:self.dataDic succeeded:^(id responseObject){
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [self.hudLoading hideAnimated:YES];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (self.pageIndex==1){
                [_lisrArr removeAllObjects];
            }
            [_lisrArr addObjectsFromArray:responseObject];
            [self.tabView.mj_header endRefreshing];
            [self.tabView.mj_footer endRefreshing];
            self.tabView.hidden = NO;
            [self.tabView reloadData];
            
        }else{
            if (strongSelf.pageIndex==1){//没有相关数据
               // [strongSelf showErrorHUDWithTitle:responseObject[@"msg"] SubTitle:nil Complete:nil];
                [_lisrArr removeAllObjects];
                [weakSelf.tabView.mj_header endRefreshing];
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];

            }else{//没有更多数据
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
            }
        }
       [self.tabView reloadData];
       
    } failed:^(id responseObject){
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
        [strongSelf.tabView.mj_header endRefreshing];
        [strongSelf.tabView.mj_footer endRefreshing];
        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];

    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lisrArr.count>0?_lisrArr.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivateListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PrivateListCell"];
    if (cell==nil) {
        cell = [[PrivateListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrivateListCell"];
    }
    [cell setArtTableViewCellDicValue:_lisrArr[indexPath.row]];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model=[MessageModel mj_objectWithKeyValues:self.lisrArr[indexPath.row]];
    MyHomePageDockerVC *vc=[[MyHomePageDockerVC alloc]init];
    vc.navTitle=model.username;
    vc.artId=model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
