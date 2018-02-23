//
//  WorksVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/29.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "WorksVc.h"
#import "WorksFirstCell.h"
#import "WorkListVc.h"

#define HEAD_CELL_HEIGHT (SCREEN_WIDTH/1.5+10)

@interface WorksVc ()
@property(nonatomic,strong)NSMutableArray* worksArr;
@end

@implementation WorksVc
-(void)createView{
    [super createView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
-(void)loadData{
    _worksArr = [[NSMutableArray alloc]init];
    
    NSDictionary * dict = @{@"uid":self.artId?self.artId:[[Global sharedInstance] getBundleID],
                            @"cuid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0",
                            @"type":@"1"
                            };
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
    __weak typeof(self)weakSelf = self;
    
    [ArtRequest GetRequestWithActionName:@"catalist" andPramater:dict succeeded:^(id responseObject) {
        [self.hudLoading hideAnimated:YES];
  
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [_worksArr removeAllObjects];
            [_worksArr addObjectsFromArray:responseObject];
        }else{
            [weakSelf showErrorHUDWithTitle:responseObject[@"msg"] SubTitle:nil Complete:nil];
        }
        [weakSelf.tabView reloadData];
        
    } failed:^(id responseObject) {
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
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
    WorksFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WorksFirstCell"];
    if (cell==nil) {
        cell = [[WorksFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WorksFirstCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, HEAD_CELL_HEIGHT)];
    }
    if (_worksArr.count>0) {
        [cell setArtTableViewCellDicValue:_worksArr[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = _worksArr[indexPath.row];
    WorkListVc* listVc = [[WorkListVc alloc] init];
    listVc.artId = self.artId;
    listVc.isOpenHeaderRefresh = YES;
    listVc.isOpenFooterRefresh = YES;
    listVc.albumidStr = [NSString stringWithFormat:@"%@",dic[@"id"]];
    listVc.topictypeStr = @"6";
    listVc.navTitle = dic[@"name"];
    listVc.hidesBottomBarWhenPushed = YES;
    [self.view.containingViewController.navigationController pushViewController:listVc animated:YES];
}
@end
