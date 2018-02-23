//
//  DianZanListVC.m
//  ShesheDa
//
//  Created by chen on 16/8/14.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "DianZanListVC.h"
#import "DianZanListCell.h"
#import "MessageModel.h"
#import "MyHomePageDockerVC.h"

@interface DianZanListVC ()

@end

@implementation DianZanListVC
@synthesize topicid;
-(void)viewWillAppear:(BOOL)animated{
//    if (![self isLogin]) {
//        return ;
//    }
    self.tabBarController.tabBar.hidden=YES;
    self.sortClass=@"1";
    self.actionName=@"topiclikeuser";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"cuid":[Global sharedInstance].userID ? : @"0",@"topicid":topicid}];
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.title=@"赞";
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MyFansCell";
    DianZanListCell *cell=(DianZanListCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[DianZanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    MessageModel *model=[MessageModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    cell.model=model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model=[MessageModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = model.username;
    vc.artId = model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
