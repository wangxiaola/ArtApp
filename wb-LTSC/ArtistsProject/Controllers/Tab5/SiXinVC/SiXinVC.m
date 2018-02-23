//
//  SiXinVC.m
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "SiXinVC.h"
#import "CangyouBaomingJiluModel.h"
#import "HLoadingHeader.h"
#import "SixinCell.h"
#import "SixinModel.h"
#import "MyHomePageDockerVC.h"
#import "sendBtn.h"
#import "HomeListDetailVc.h"

@interface SiXinVC (){
    HTextField* txt;
    NSIndexPath *indexSelect;
}
@end

@implementation SiXinVC
@synthesize cID,navTitle;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"系统通知";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if ([self.state isEqualToString:@"1"]) {
        return ;
    }
    if (navTitle) {
        self.navigationItem.title=navTitle;
    }
         self.tab=[self tab];
   
    [self.tab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40);
    }];
    
    UIImageView* footView = [[UIImageView alloc]init];
    footView.userInteractionEnabled = YES;
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    txt=[[HTextField alloc]init];
    txt.backgroundColor = [UIColor whiteColor];
    txt.placeholder=@"请输入对话内容";
    txt.textColor=PH_COLOR_BUTTON_BORDER;
    txt.font=ART_FONT(ARTFONT_OF);
    txt.clearsOnBeginEditing = YES;
    txt.clearButtonMode = UITextFieldViewModeAlways;
    txt.textEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [footView addSubview:txt];
    [txt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(footView);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH-90);
    }];

    
    
    sendBtn* btn = [[sendBtn alloc]init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleFrame = CGRectMake(30, 11, 30, 20);
    btn.imgFrame = CGRectMake(0, 11, 20, 20);
    btn.titleLabel.font = ART_FONT(ARTFONT_OF);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"PrivateSend"] forState:UIControlStateNormal];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnSend_Click) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(footView);
        make.left.mas_equalTo(txt.mas_right);
        make.right.mas_equalTo(-15);
    }];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = BACK_VIEW_COLOR;
    self.tab.backgroundColor = BACK_VIEW_COLOR;

    self.sortClass=@"1";
    if ([self.state isEqualToString:@"1"]) {
        self.actionName=@"msgcenter";
        self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID,@"type":@"1"}];
    }else{
        self.actionName=@"messagecontent";
        self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"tuid":cID,
                                                                             @"uid":[Global sharedInstance].userID}];
    }
    [self loadData];
}

#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SixinModel *model=[SixinModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    CGSize sizeCell2=[model.message sizeWithFontSize:13 andMaxWidth:kScreenW-155 andMaxHeight:1000];
    return sizeCell2.height+80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if ([self.state isEqualToString:@"1"]) {
            SixinModel *model=[SixinModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
            HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
            detailVC.topicid = [NSString stringWithFormat:@"%@",model.toid];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.isScrollToBottom = NO;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MyFansCell";
    SixinCell *cell=(SixinCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[SixinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    SixinModel *model=[SixinModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    cell.model=model;
    return cell;
}

-(void)btnSend_Click{
    if ([self showCheckErrorHUDWithTitle:@"请输入私信内容" SubTitle:nil checkTxtField:txt]) {
        return ;
    }
    if (![self isNavLogin]) {
        return ;
    }
    
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID,
                           @"tuid":cID,
                           @"message":txt.text};
    
    [self showLoadingHUDWithTitle:@"正在发送私信" SubTitle:nil];
    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"postmessage" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        txt.placeholder=@"评论";
        [self hideKeyBoard];
        txt.text=@"";
        [self.tab.mj_header beginRefreshing];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}

@end
