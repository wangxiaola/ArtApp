//
//  BalancePaymentsVC.m
//  ShesheDa
//
//  Created by chen on 16/7/16.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "BalancePaymentsVC.h"
#import "BalancePaymentsModel.h"
#import "BalancePaymentsCell.h"
@interface BalancePaymentsVC ()

@end

@implementation BalancePaymentsVC

-(void)viewWillAppear:(BOOL)animated{
    self.actionName=@"changelist";
    self.isPost=YES;
    self.sortClass=@"1";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID?:@"0"}];
    
    [super viewWillAppear:animated];
    self.navigationItem.title=@"收支明细";
}

#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MyFansCell";
    BalancePaymentsCell *cell=(BalancePaymentsCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[BalancePaymentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    BalancePaymentsModel *model=[BalancePaymentsModel objectWithKeyValues:self.lstData[indexPath.row]];
    cell.model=model;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
