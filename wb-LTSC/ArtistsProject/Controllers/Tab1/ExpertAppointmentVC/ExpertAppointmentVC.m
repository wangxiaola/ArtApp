//
//  ExpertAppointmentVC.m
//  ShesheDa
//
//  Created by chen on 16/7/11.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ExpertAppointmentVC.h"
#import "ExpertAppointmentCell.h"
#import "ExpertAppointmentModel.h"
#import "ExpertAppointmentDetailVCViewController.h"
#import "ExpertAppointmentDetailH5VC.h"

@interface ExpertAppointmentVC ()

@end

@implementation ExpertAppointmentVC

-(void)viewWillAppear:(BOOL)animated{
    self.actionName=@"eventlist";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID?:@"0",@"type":@"2"}];
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.title=@"专家预约";
}
-(void)viewDidLoad{
    self.isGroup=YES;
    self.sortClass=@"1";
    [super viewDidLoad];
}


#pragma mark - 列表视图代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lstData.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MyFansCell";
    ExpertAppointmentCell *cell=(ExpertAppointmentCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[ExpertAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    ExpertAppointmentModel *model=[ExpertAppointmentModel objectWithKeyValues:self.lstData[indexPath.section]];
    cell.model=model;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertAppointmentModel *model=[ExpertAppointmentModel objectWithKeyValues:self.lstData[indexPath.section]];
    ExpertAppointmentDetailVCViewController *vc=[[ExpertAppointmentDetailVCViewController alloc]init];
    vc.cid=model.eid;
    [self.navigationController pushViewController:vc animated:YES];
//    ExpertAppointmentDetailH5VC *vc=[[ExpertAppointmentDetailH5VC alloc]init];
//    vc.cid=model.eid;
//    vc.url=model.eurl ;//[NSString stringWithFormat:@"http://jianbao.guwanw.com/index.php?app=Event&mod=Info&act=content&id=%@",model.eid];
//    [self.navigationController pushViewController:vc animated:YES];
}
@end
