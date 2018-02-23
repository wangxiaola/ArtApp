//
//  FensiVC.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "FensiVC.h"
#import "MessageCell.h"
#import "GuanzhuCell.h"
#import "MyHomePageDockerVC.h"

@interface FensiVC ()

@end

@implementation FensiVC

-(void)viewWillAppear:(BOOL)animated{
    if (![self isLogin]) {
        return ;
    }
    self.sortClass=@"1";
    self.actionName=@"myfollowlist";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID?:@"0"}];
    self.view.backgroundColor=ColorHex(@"f6f6f6");
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuanzhuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GuanzhuCell"];
    if (cell==nil) {
        cell = [[GuanzhuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GuanzhuCell"];
    }
    [cell setArtTableViewCellDicValue:self.lstData[indexPath.row]];
    return cell;
    
//    NSString *identifier=@"MyFansCell";
//    GuanzhuCell *cell=(GuanzhuCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if (!cell){
//        cell=[[GuanzhuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        cell.backgroundColor=kWhiteColor;
//    }
//    MessageModel *model=[MessageModel objectWithKeyValues:self.lstData[indexPath.row]];
//    cell.model=model;
//    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model=[MessageModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    MyHomePageDockerVC *vc=[[MyHomePageDockerVC alloc]init];
    vc.navTitle=model.username;
    vc.artId=model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
