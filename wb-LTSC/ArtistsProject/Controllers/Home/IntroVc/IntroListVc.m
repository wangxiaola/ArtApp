//
//  IntroListVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/8.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "IntroListVc.h"
#import "IntroListCell.h"
#import "HomeListDetailVc.h"

@interface IntroListVc ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _cellHeight;
}

@property(nonatomic,strong)NSMutableArray* introListArr;
@property(nonatomic,copy)NSString* yearStr;
@end

@implementation IntroListVc

-(void)createView{
    [super createView];
    self.tabView.separatorStyle = UITableViewCellSelectionStyleNone;
       [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSDictionary * dict = @{@"postuid":self.artId?self.artId:[[Global sharedInstance] getBundleID],
                            @"uid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0",
                            @"topictype":self.topictypeStr?self.topictypeStr:@"0",
                            @"albumid":self.albumidStr?self.albumidStr:@"0",
                            };
    [self.dataDic addEntriesFromDictionary:dict];
    _introListArr = [[NSMutableArray alloc]init];
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
        
        //简介
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (weakSelf.pageIndex==1){
                [_introListArr removeAllObjects];
            }
            [_introListArr addObjectsFromArray:responseObject];
            
            [weakSelf.tabView.mj_header endRefreshing];
            [weakSelf.tabView.mj_footer endRefreshing];
        }else{
            if (weakSelf.pageIndex==1){//没有相关数据
               // [weakSelf showErrorHUDWithTitle:responseObject[@"msg"] SubTitle:nil Complete:nil];
                [_introListArr removeAllObjects];

                [weakSelf.tabView.mj_header endRefreshing];
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];

            }else{//没有更多数据
                [(MJRefreshAutoStateFooter*)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
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
    return _introListArr.count>0?_introListArr.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight>0?_cellHeight:1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IntroListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IntroListCell"];
    if (cell==nil) {
        cell = [[IntroListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroListCell"];
    }
    NSDictionary* dic = _introListArr[indexPath.row];
    cell.yearBlock = ^(NSString* str){
        self.yearStr = str;
    };
    if (dic.count>0){
             _cellHeight = [cell setIntroListCellDicValue:_introListArr[indexPath.row] yearStr:self.yearStr];
        }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = _introListArr[indexPath.row];
    
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",dic[@"id"]];
    detailVC.topictype = [NSString stringWithFormat:@"%@",dic[@"topictype"]];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
