//
//  CangyouZixunVC.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangyouZixunVC.h"
#import "CangyouZixunCell.h"
#import "CangyouBaomingJiluModel.h"
#import "HLoadingHeader.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
@interface CangyouZixunVC (){
    HTextField *txt;
    NSIndexPath *indexSelect;
}

@end

@implementation CangyouZixunVC
@synthesize cID;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"藏友咨询";
    self.tab=[self tab];
    [self.tab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    HView *viewBottom=[[HView alloc]init];
    viewBottom.backgroundColor=kClearColor;
    [self.view addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    txt=[[HTextField alloc]init];
    txt.placeholder=@"输入";
    txt.layer.borderColor=kLineColor.CGColor;
    txt.layer.borderWidth=1;
    txt.layer.masksToBounds=YES;
    txt.textColor=kTitleColor;
    txt.font=kFont(15);
    txt.layer.cornerRadius=5;
    txt.textEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [viewBottom addSubview:txt];
    [txt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(viewBottom);
        make.right.equalTo(viewBottom).offset(-65);
    }];
    
    //发送按钮
    HButton *btnSend=[[HButton alloc]init];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [btnSend setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnSend.titleLabel.font=kFont(15);
    btnSend.layer.borderWidth=1;
    btnSend.layer.borderColor=kLineColor.CGColor;
    btnSend.layer.cornerRadius=5;
    btnSend.backgroundColor=ColorHex(@"f6f6f6");
    [btnSend addTarget:self action:@selector(btnSend_Click) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnSend];
    [btnSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(viewBottom);
        make.width.mas_equalTo(70);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.sortClass=@"1";
    self.actionName=@"eventcomment";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"eid":cID}];
    
    [super viewWillAppear:animated];
}

#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertAppointmentZhubandanweiDataModel *model=[ExpertAppointmentZhubandanweiDataModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    CGSize sizeCell1=[model.hf.content sizeWithFontSize:13 andMaxWidth:kScreenW-105 andMaxHeight:1000];
    CGSize sizeCell2=[model.zx.content sizeWithFontSize:13 andMaxWidth:kScreenW-105 andMaxHeight:1000];
    return sizeCell1.height+sizeCell2.height+80;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MyFansCell";
    CangyouZixunCell *cell=(CangyouZixunCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[CangyouZixunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    ExpertAppointmentZhubandanweiDataModel *model=[ExpertAppointmentZhubandanweiDataModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    cell.model=model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    indexSelect=indexPath;
        ExpertAppointmentZhubandanweiDataModel *model=[ExpertAppointmentZhubandanweiDataModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    txt.placeholder=[NSString stringWithFormat:@"@%@",model.zx.uname];
}

-(void)btnSend_Click{
    if ([self showCheckErrorHUDWithTitle:@"请输入评论内容" SubTitle:nil checkTxtField:txt]) {
        return ;
    }
    if (![self isNavLogin]) {
        return ;
    }
    
    NSString *strto_comment_id=@"";
    NSString *strto_uid=@"";
    NSDictionary *dict;
    if (indexSelect) {
        ExpertAppointmentZhubandanweiDataModel *model=[ExpertAppointmentZhubandanweiDataModel mj_objectWithKeyValues:self.lstData[indexSelect.row]];
        strto_comment_id=model.zx.comment_id;
        strto_uid=model.zx.uid;
        dict = @{@"uid":[Global sharedInstance].userID?:@"0",
                 @"eid":cID,
                 @"content":txt.text,
                 @"to_comment_id":strto_comment_id,
                 @"to_uid":strto_uid};
    }else{
        dict = @{@"uid":[Global sharedInstance].userID?:@"0",
                  @"eid":cID,
                  @"content":txt.text};

    }
    
    [self showLoadingHUDWithTitle:@"正在评论" SubTitle:nil];
    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"commentevent" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        indexSelect=nil;
        txt.placeholder=@"评论";
        [self hideKeyBoard];
        txt.text=@"";
        [self.tab.mj_header beginRefreshing];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];

}

@end
