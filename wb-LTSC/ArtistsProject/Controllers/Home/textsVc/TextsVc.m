//
//  IntroVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "TextsVc.h"
#import "TextsListVc.h"
#import "MyHomePageDockerVC.h"

#define SECTION_FIRST 0//icon

#define ICON_CELL_HEIGHT T_WIDTH(100)
#define HEAD_CELL_HEIGHT (SCREEN_WIDTH/2)
#define Text_HEIGHT T_WIDTH(110)

#import "TextsFirstCell.h"
#import "IntroHeadCell.h"
#import "TextsListCell.h"


@interface TextsVc ()
{
    
}
@property(nonatomic,strong)NSMutableArray * userlogoArray;
@property(nonatomic,strong)NSMutableArray * artListArray;
@end

@implementation TextsVc
-(void)createView{
    [super createView];
    self.tabView.separatorColor=[UIColor clearColor];
    self.tabView.hidden = YES;
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _userlogoArray = [[NSMutableArray alloc]init];
    _artListArray = [[NSMutableArray alloc]init];
    
}
-(void)loadData{
    [_userlogoArray removeAllObjects];
    [_artListArray removeAllObjects];
    NSDictionary * dict = @{@"uid":self.artId?self.artId:[[Global sharedInstance] getBundleID],
                            @"cuid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0",
                            @"topictype":@"9"
                            };
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
    __weak typeof(self)weakSelf = self;

    [ArtRequest GetRequestWithActionName:@"textindex" andPramater:dict succeeded:^(id responseObject) {
        [self.hudLoading hideAnimated:YES];
        kPrintLog(responseObject)
        //个人简介
        weakSelf.model=[UserInfoModel mj_objectWithKeyValues:responseObject[@"grjj"]];
        //[_introDic addEntriesFromDictionary:responseObject];
        NSArray* arr = [responseObject[@"userlogo"] copy];
        for (id obj in arr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [_userlogoArray addObject:obj];
            }
        }
        [_artListArray addObjectsFromArray:responseObject[@"info"]];
        self.tabView.hidden = NO;
        [self.tabView reloadData];
        
        
    } failed:^(id responseObject) {
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _artListArray.count>0?_artListArray.count+1:1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==SECTION_FIRST){
        return 1;
    }else{
        NSDictionary* dic = _artListArray[section-1];
        NSArray* arr = dic[@"info"];
        if(arr.count>0&&arr.count<6){
           return arr.count+1;
        }else if(arr.count>6){
            return 7;
        }else{
            return 1;
        }
    }
        return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==SECTION_FIRST) {
        return ICON_CELL_HEIGHT;
    }else{
        if (indexPath.row==0) {
            return HEAD_CELL_HEIGHT;
        }else if(indexPath.row>0&&indexPath.row<6){
            return Text_HEIGHT;
        }else if(indexPath.row==6){
            return 40;//查看全部
        }
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==SECTION_FIRST) {
        TextsFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TextsFirstCell"];
        if (cell==nil) {
            cell = [[TextsFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextsFirstCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, ICON_CELL_HEIGHT)];
            cell.selectImgCilck = ^(NSInteger index){
                NSDictionary* dic = _userlogoArray[index];
                MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
                vc.navTitle = dic[@"username"];
                vc.artId = dic[@"uid"];
            [self.view.containingViewController.navigationController pushViewController:vc animated:YES];
            };
        }
        [cell setArtTableViewCellArrValue:_userlogoArray];
        
        return cell;
    }else{
        NSDictionary* dic = _artListArray[indexPath.section-1];
        if (indexPath.row==0){
            IntroHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroHeadCell"];
            if (cell==nil) {
                cell = [[IntroHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroHeadCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, HEAD_CELL_HEIGHT)];
            }
            if (dic.count>0){
                [cell setArtTableViewHeadCellDicValue:dic];
            }
            return cell;
        }else if(indexPath.row<6){
            NSArray* arr = dic[@"info"];
            TextsListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TextsListCell"];
            if (cell==nil) {
                cell = [[TextsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextsListCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, Text_HEIGHT)];
            }
            __weak typeof(self)weakSelf = self;
            cell.baseViews = weakSelf.view;
            [cell setArtTableViewCellDicValue:arr[indexPath.row-1]];
            
            return cell;
        }else{//查看全部
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
        cell.textLabel.text = @"查看全部";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0){
        if (indexPath.row>0&&indexPath.row<6){//进详情
            NSDictionary* bigDic = _artListArray[indexPath.section-1];
            NSArray* arr = bigDic[@"info"];
            NSDictionary* dic = arr[indexPath.row-1];
            
            HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
            detailVC.topicid = [NSString stringWithFormat:@"%@",dic[@"id"]];
            detailVC.topictype = [NSString stringWithFormat:@"%@",dic[@"topictype"]];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.obj.navigationController pushViewController:detailVC animated:YES];

        }else{//进列表
            NSDictionary* dic = _artListArray[indexPath.section-1];
            TextsListVc * listVc = [[TextsListVc alloc]init];
            listVc.isOpenHeaderRefresh = YES;
            listVc.isOpenFooterRefresh = YES;
            listVc.albumidStr = [NSString stringWithFormat:@"%@",dic[@"albumid"]];
            listVc.topictypeStr = @"9";
            listVc.artId = self.artId;
            if(([dic[@"title"] rangeOfString:@"|"].location!=NSNotFound)){
                listVc.navTitle = [NSString stringWithFormat:@"%@",[dic[@"title"] componentsSeparatedByString:@"|"][0]];
            }else{
                listVc.navTitle = dic[@"title"];
            }
            
            listVc.hidesBottomBarWhenPushed = YES;
            [self.view.containingViewController.navigationController pushViewController:listVc animated:YES];
        }
 }
}
@end
