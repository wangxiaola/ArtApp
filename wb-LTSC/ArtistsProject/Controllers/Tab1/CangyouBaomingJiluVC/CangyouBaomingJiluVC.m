//
//  CangyouBaomingJiluVC.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangyouBaomingJiluVC.h"
#import "CangyouBaomingJiluCell.h"
#import "CangyouBaomingJiluModel.h"

@interface CangyouBaomingJiluVC ()

@end

@implementation CangyouBaomingJiluVC
@synthesize cID;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"藏友报名记录";
}

-(void)viewWillAppear:(BOOL)animated{
    self.sortClass=@"1";
    self.actionName=@"eventuser";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"eid":cID}];
    
    [super viewWillAppear:animated];
}

#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MyFansCell";
    CangyouBaomingJiluCell *cell=(CangyouBaomingJiluCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[CangyouBaomingJiluCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    CangyouBaomingJiluModel *model=[CangyouBaomingJiluModel objectWithKeyValues:self.lstData[indexPath.row]];
    cell.model=model;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
