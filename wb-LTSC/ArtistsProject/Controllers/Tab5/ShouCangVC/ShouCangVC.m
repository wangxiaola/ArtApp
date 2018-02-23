//
//  ShouCangVC.m
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ShouCangVC.h"
#import "ShouCangCell.h"
#import "CangyouQuanDetailModel.h"
#import "HomeListDetailVc.h"

@interface ShouCangVC ()

@end

@implementation ShouCangVC

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    if (![self isLogin]) {
        return ;
    }
    self.sortClass=@"1";
    self.actionName=@"collecttopiclist";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID}];
    
    [super viewWillAppear:animated];
    self.navigationItem.title=@"收藏";
}

#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MyFansCell";
    ShouCangCell *cell=(ShouCangCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[ShouCangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    cell.model=model;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",model.id];
    detailVC.topictype = [NSString stringWithFormat:@"%@",model.topictype];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.isScrollToBottom = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

//设置编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tab setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[self.lstData count]) {
            [self removeData:indexPath];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}
/**
 *  删除数据
 */
-(void)removeData:(NSIndexPath *)indexPath{
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    [self showLoadingHUDWithTitle:@"正在删除收藏" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID,
                           @"topicid":model.id};
    
    [ArtRequest PostRequestWithActionName:@"delcollecttopic" andPramater:dict succeeded:^(id responseObject){
        [self.hudLoading hideAnimated:YES];
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"删除" obj:responseObject]) {
            //            self.sortClass=@"1";
            //            self.actionName=@"collecttopiclist";
            //            self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID}];
            [self loadData];
            
        }else{
            NSString* msg = responseObject[@"msg"];
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [self logonAgain];
            }
        }
        
    } failed:^(id responseObject) {
        [self.hudLoading hideAnimated:YES];
    }];
    
}

@end
