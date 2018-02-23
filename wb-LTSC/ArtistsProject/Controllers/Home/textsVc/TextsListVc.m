//
//  TextsListVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/31.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "TextsListVc.h"
#import "TextsListCell.h"
#define Text_HEIGHT T_WIDTH(110)


@interface TextsListVc ()
@property(nonatomic,strong)NSMutableArray* lisrArr;
@end

@implementation TextsListVc
-(void)createView{
    [super createView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _lisrArr = [[NSMutableArray alloc]init];
    NSDictionary * dict = @{@"postuid":self.artId?self.artId:@"0",
                            @"cuid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0",
                            @"num":@"10",
                            @"topictype":self.topictypeStr?self.topictypeStr:@"0",
                            @"albumid":self.albumidStr?self.albumidStr:@"0"
                            };
    [self.dataDic addEntriesFromDictionary:dict];
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
        [self.hudLoading hideAnimated:YES];
        //文字
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (weakSelf.pageIndex==1){
                [_lisrArr removeAllObjects];
            }
            [_lisrArr addObjectsFromArray:responseObject];
            [self.tabView.mj_header endRefreshing];
            [self.tabView.mj_footer endRefreshing];
            

        }else{
            if (weakSelf.pageIndex==1){//没有相关数据
                
                //[weakSelf showErrorHUDWithTitle:responseObject[@"msg"] SubTitle:nil Complete:nil];
                [_lisrArr removeAllObjects];
                [weakSelf.tabView.mj_header endRefreshing];
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];

            }else{//没有更多数据
              [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tabView reloadData];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Text_HEIGHT;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lisrArr.count>0?_lisrArr.count:0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextsListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TextsListCell"];
    if (cell==nil) {
        cell = [[TextsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextsListCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, Text_HEIGHT)];
    }
   

    NSDictionary* dic = _lisrArr[indexPath.row];
    if (dic){
        [cell setArtTableViewCellDicValue:_lisrArr[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = _lisrArr[indexPath.row];
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",dic[@"id"]];
    detailVC.topictype = [NSString stringWithFormat:@"%@",dic[@"topictype"]];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
