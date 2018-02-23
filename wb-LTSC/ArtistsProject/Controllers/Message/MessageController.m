//
//  MessageVC.m
//  ShesheDa
//
//  Created by chen on 16/7/9.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"
#import "MessageController.h"
#import "SiXinVC.h"

@interface MessageController ()

@end

@implementation MessageController

- (void)viewWillAppear:(BOOL)animated
{
    
    //设置导航栏标题字体和颜色
    NSDictionary* dictTitle = @{ NSFontAttributeName : [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName : kTitleColor };
    self.navigationController.navigationBar.titleTextAttributes = dictTitle;
    
    //设置导航栏返回按钮样式
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(0, 0, 14, 60);
    [customButton addTarget:self action:@selector(leftBarItem_Click) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"icon_navigationbar_back"] forState:UIControlStateNormal];
    customButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem* leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;

    
    self.actionName = @"messagelist";
    self.dicParamters = [[NSMutableDictionary alloc] initWithDictionary:@{ @"uid" : [Global sharedInstance].userID ? : @"" }];
    
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden=NO;
    [self loadData];
}

-(void)leftBarItem_Click{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"消息";
    //self.lstData = [[NSMutableArray alloc]init];
}

#pragma mark - 列表视图代理方法

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 80;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"MyFansCell";
    MessageCell* cell = (MessageCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MessageModel* model = [MessageModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MessageModel* model = [MessageModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    if (model.fromuser) {
        SiXinVC* vc = [[SiXinVC alloc] init];
        if ([model.fromuser.uid isEqualToString:[Global sharedInstance].userID]) {
            
            vc.cID = model.touser.uid;
            vc.navTitle = model.touser.username;
        }
        else {
            
            vc.cID = model.msgfromid;
            vc.navTitle = model.fromuser.username;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        SiXinVC* vc = [[SiXinVC alloc] init];
        vc.cID = model.msgfromid;
        vc.state = @"1";
        vc.navTitle = @"系统消息";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
