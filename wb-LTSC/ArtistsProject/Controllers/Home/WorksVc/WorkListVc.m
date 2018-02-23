//
//  WorkListVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/4.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "WorkListVc.h"
#import "WorksListCell.h"
#import "HomeListDetailVc.h"

#define HEAD_CELL_HEIGHT (SCREEN_WIDTH/1.5+10)


@interface WorkListVc ()
@property(nonatomic,strong)NSMutableArray* worksArr;
@end

@implementation WorkListVc
-(void)createView{
    [super createView];
    self.tabView.separatorStyle = UITableViewCellStyleDefault;
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSDictionary * dict = @{@"postuid":self.artId?self.artId:[[Global sharedInstance] getBundleID],
                            @"uid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0",
                            @"topictype":self.topictypeStr?self.topictypeStr:@"0",
                            @"albumid":self.albumidStr?self.albumidStr:@"0",
                            };
    [self.dataDic addEntriesFromDictionary:dict];
    _worksArr = [[NSMutableArray alloc]init];
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

    NSString* pageStr = [NSString stringWithFormat:@"%ld",self.pageIndex];
    [self.dataDic setObject:pageStr forKey:@"page"];
    
    __weak typeof(self)weakSelf = self;
    
    [ArtRequest GetRequestWithActionName:@"topiclist" andPramater:self.dataDic succeeded:^(id responseObject) {
        [weakSelf.hudLoading hideAnimated:YES];
        //个人简介
        //近况
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (weakSelf.pageIndex==1){
                [_worksArr removeAllObjects];
            }
            [_worksArr addObjectsFromArray:responseObject];
            
            [weakSelf.tabView.mj_header endRefreshing];
            [weakSelf.tabView.mj_footer endRefreshing];
        }else{
            if (weakSelf.pageIndex==1){//没有相关数据
       // [weakSelf showErrorHUDWithTitle:responseObject[@"msg"] SubTitle:nil Complete:nil];
                [_worksArr removeAllObjects];
                [weakSelf.tabView.mj_header endRefreshing];
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];

            }else{//没有更多数据
        [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
       [weakSelf.tabView reloadData];
    } failed:^(id responseObject) {
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
    return _worksArr.count>0?_worksArr.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEAD_CELL_HEIGHT;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorksListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WorksListCell"];
    if (cell==nil) {
        cell = [[WorksListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WorksListCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, HEAD_CELL_HEIGHT)];
    }
    if (_worksArr.count>0) {
        [cell setArtTableViewCellDicValue:_worksArr[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = _worksArr[indexPath.row];
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",dic[@"id"]];
    detailVC.topictype = [NSString stringWithFormat:@"%@",dic[@"topictype"]];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
