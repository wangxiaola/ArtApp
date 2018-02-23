//
//  AppraisalMeetingVC.m
//  ShesheDa
//
//  Created by chen on 16/7/12.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "AppraisalMeetingVC.h"
#import "AppraisalMeetingCell.h"
#import "ExpertAppointmentModel.h"
#import "ExpertAppointmentDetailH5VC.h"
#import "AppraisalMeetingDetailVC.h"
@interface AppraisalMeetingVC ()

@end

@implementation AppraisalMeetingVC


-(void)viewWillAppear:(BOOL)animated{
    self.actionName=@"eventlist";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID?:@"0",@"type":_type}];
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
//    self.navigationItem.title=@"鉴定会";
}
-(void)viewDidLoad{
    self.isGroup=YES;
    self.sortClass=@"1";
    self.tab.backgroundColor = BACK_VIEW_COLOR;
    [super viewDidLoad];
}


#pragma mark - 列表视图代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
    AppraisalMeetingCell *cell=(AppraisalMeetingCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[AppraisalMeetingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    ExpertAppointmentModel *model=[ExpertAppointmentModel mj_objectWithKeyValues:self.lstData[indexPath.section]];
    cell.model=model;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertAppointmentModel *model=[ExpertAppointmentModel mj_objectWithKeyValues:self.lstData[indexPath.section]];
    AppraisalMeetingDetailVC *vc=[[AppraisalMeetingDetailVC alloc]init];
    vc.cid=model.eid;
    [self.navigationController pushViewController:vc animated:YES];

}


@end
