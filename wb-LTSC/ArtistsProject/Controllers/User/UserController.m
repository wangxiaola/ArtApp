//
//  ClassifyController.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "UserController.h"
#import "ClassifyCell.h"
#import "sendBtn.h"
#import "MyHomePageDockerVC.h"
#import "WalletVC.h"
#import "SetupVC.h"
#import "UserInfoVC.h"
#import "ShouCangVC.h"
#import "YTXOpenAuthentication.h"
#import "YTXOrderViewController.h"
#import "FensiVC.h"
#import "KaiShiJiandingVC.h"
#import "MessageController.h"
#import "InviteVc.h"
#import "YTXOpenAuthentication.h"
#import "AlertLoginVc.h"
#import "LogonVc.h"
#import "MemberVerifyC.h"
#define ONE_ONE_CELL (T_WIDTH(40))

@interface UserController ()<UITableViewDelegate,UITableViewDataSource>
{
    UserInfoModel *model;
}
@property(nonatomic,strong)UITableView* tbView;
@property(nonatomic,strong)NSArray* classifyArr;
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UIImageView* headVeiw;
@end

@implementation UserController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[Global sharedInstance] userID]) {
        [self loadUserData];
    }else{
        _nameLabel.text= @"点此登录>>";
    }
}
//加载用户信息
- (void)loadUserData{
    
    //1.设置请求参数
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"userinfo" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        ResultModel *result=[ResultModel modelWithDictionary:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        model=[UserInfoModel modelWithDictionary:responseObject];
        [_iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
        [Global sharedInstance].auth=[NSString stringWithFormat:@"%@",model.auth];
        [Global sharedInstance].userInfo=model;
        [Global sharedInstance].isgroup = model.isgroup;
        _nameLabel.text=model.nickname;
    }andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //名字头像
    UIImageView* leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 150,40)];
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, T_WIDTH(50), T_WIDTH(50))];
    _iconView.layer.cornerRadius = T_WIDTH(25);
    _iconView.image = [UIImage imageNamed:@"temp_Default_headProtrait"];
    _iconView.layer.masksToBounds = YES;
    [leftView addSubview:_iconView];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(getViewWidth(_iconView)+15, 0, kScreenW-200, 40)];
    _nameLabel.centerY = _iconView.centerY;
    _nameLabel.text = @"点此登录>>";
    _nameLabel.font = ART_FONT(ARTFONT_OFI);
    [leftView addSubview:_nameLabel];
    leftView.userInteractionEnabled = YES;
    UITapGestureRecognizer *LVTap = [[UITapGestureRecognizer alloc] init];
    [LVTap addTarget:self action:@selector(leftViewAction)];
    [leftView addGestureRecognizer:LVTap];
    /*************************************************/
    leftView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftView];
    
    UIImageView* rightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100,40)];
    sendBtn* btn = [[sendBtn alloc]init];
    btn.frame = CGRectMake(0, 0, 100, 40);
    btn.titleFrame = CGRectMake(35, 10, 50, 20);
    btn.centerY = _nameLabel.centerY;
    btn.imgFrame = CGRectMake(90, 15, 6, 10);
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = ART_FONT(ARTFONT_OZ);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"userEnter"] forState:UIControlStateNormal];
    [btn setTitle:@"简介资料" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:btn];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    _classifyArr = @[@{
                         @"title" : @"我的主页",
                         @"icon" : @"我的主页",
                         },
//                     @{
//                         @"title" : @"开通功能",
//                         @"icon" : @"userOpen",
//                         },
                     @{
                         @"title" : @"认证",
                         @"icon" : @"认证",
                         },
                     @{
                         @"title" : @"钱包",
                         @"icon" : @"钱包",
                         },
//                     @{
//                         @"title" : @"收藏",
//                         @"icon" : @"userFavorite",
//                         },
                     @{
                         @"title" : @"设置",
                         @"icon" : @"设置",
                         }
                     
                     ];
    _tbView  = [[UITableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tbView.scrollEnabled = NO;
    _tbView.backgroundColor = BACK_VIEW_COLOR;
    
    _tbView.tableFooterView = [UIImageView new];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tbView];
    _headVeiw = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(120))];
    _headVeiw.userInteractionEnabled = YES;
    _headVeiw.backgroundColor = [UIColor whiteColor];
    _tbView.tableHeaderView = _headVeiw;
    NSArray* titleArr = @[@"订单",@"收藏",@"消息",@"邀请"];
    NSArray* imageArr = @[@"订单",@"收藏",@"消息",@"邀请"];
    
    for (int i=0; i<4; i++) {
        sendBtn* btn = [[sendBtn alloc]init];
        btn.tag = 1000+i;
        btn.frame = CGRectMake(T_WIDTH(30)+i*(T_WIDTH(35)+T_WIDTH(40)), T_WIDTH(50), T_WIDTH(35), T_WIDTH(60));
        btn.imgFrame = CGRectMake(0, 0, T_WIDTH(35), T_WIDTH(35));
        //btn.imageView.layer.cornerRadius = T_WIDTH(17.5);
        btn.titleFrame = CGRectMake(0, T_WIDTH(35)+5, T_WIDTH(35), 17);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = ART_FONT(ARTFONT_OFI);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headVeiw addSubview:btn];
    }
    
    if (ISIOS7Later) {//ios7之前
        [self.tbView setSeparatorInset:UIEdgeInsetsZero];
    }
    if (ISIOS8Later) {//iOS8之前
        [self.tbView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        if (![Global sharedInstance].ishideMoney) {
            return 0;
        }
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return ONE_ONE_CELL;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section==3) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            
        }
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassifyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ClassifyCell"];
    if (cell==nil){
        cell = [[ClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClassifyCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, ONE_ONE_CELL)];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary* dic;
     dic = _classifyArr[indexPath.section];
//    if (indexPath.section==0) {
//        dic = _classifyArr[indexPath.row];
//    }else if(indexPath.section==1){
//        dic = _classifyArr[indexPath.row+2];
//    }else if(indexPath.section==2){
//        dic = _classifyArr[indexPath.row+3];
//    }else if(indexPath.section==3){
//        dic = _classifyArr[indexPath.row+4];
//    }
    
    [cell setClassifyImg:dic[@"icon"] title:dic[@"title"] subImg:nil];
    
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView* img = [[UIImageView alloc]init];
    if (section==0) {
        img.frame =  CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(15));
    }else if(section<4){
        img.frame = CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(20));
    }
    img.backgroundColor = BACK_VIEW_COLOR;
    return img;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return T_WIDTH(15);
    }else if(section==2){
        if (![Global sharedInstance].ishideMoney) {
            return 0;
        }
        return T_WIDTH(20);
    }else if(section<4){
        
        return T_WIDTH(20);
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if(![[Global sharedInstance] userID]){
                //            [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
                LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
                login.pushVC = [[UserController alloc] init];
                login.navTitle = @"用户验证";
                login.hidesBottomBarWhenPushed = YES;
                login.state = @"push";
                login.whichControl = [NSString stringWithFormat:@"%@",self.class];
                [self.navigationController pushViewController:login animated:YES];
                return;
//                AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//                login.navTitle = @"用户验证";
//                //        login.state = @"push";
//                login.hidesBottomBarWhenPushed = YES;
//                login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//                [self.navigationController pushViewController:login animated:YES];
//                return;
            }
            if (indexPath.row==0) {
                if (!model.nickname) {
                    return;
                }
                MyHomePageDockerVC *vc=[[MyHomePageDockerVC alloc]init];
                vc.navTitle = @"劳特斯辰艺术家线上展厅";
                vc.artId=[Global sharedInstance].userID;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                YTXOpenAuthentication *vc=[[YTXOpenAuthentication alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1:
        {//认证
            if(![[Global sharedInstance] userID]){
                LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
                login.navTitle = @"用户验证";
                login.hidesBottomBarWhenPushed = YES;
                login.state = @"push";
                login.whichControl = [NSString stringWithFormat:@"%@",self.class];
                [self.navigationController pushViewController:login animated:YES];
                return;
            }
            MemberVerifyC *authenticationVC = [[MemberVerifyC alloc]init];
            authenticationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:authenticationVC animated:YES];
            
//            AuthenticationViewController *authenticationVC = [[AuthenticationViewController alloc]init];
//            [self.navigationController pushViewController:authenticationVC animated:YES];
//            WalletVC *wallet=[[WalletVC alloc]init];
//            wallet.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:wallet animated:YES];
        }
            break;
        case 2:
        {
            if(![[Global sharedInstance] userID]){
                //            [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
//                AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//                login.navTitle = @"用户验证";
//                //        login.state = @"push";
//                login.hidesBottomBarWhenPushed = YES;
//                login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//                [self.navigationController pushViewController:login animated:YES];
//                return;
                LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
                login.navTitle = @"用户验证";
                login.hidesBottomBarWhenPushed = YES;
                login.state = @"push";
                login.whichControl = [NSString stringWithFormat:@"%@",self.class];
                [self.navigationController pushViewController:login animated:YES];
                return;
            }
            WalletVC *wallet=[[WalletVC alloc]init];
            wallet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wallet animated:YES];
//            ShouCangVC *vc=[[ShouCangVC alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            SetupVC *wallet=[[SetupVC alloc]init];
            wallet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wallet animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)headBtnClick:(UIButton*)btn{
    if (btn.tag==1000) {//订单
        if(![[Global sharedInstance] userID]){
//            [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
//            AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//            login.navTitle = @"用户验证";
//            //        login.state = @"push";
//            login.hidesBottomBarWhenPushed = YES;
//            login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//            [self.navigationController pushViewController:login animated:YES];
//            return;
            LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
            login.navTitle = @"用户验证";
            login.hidesBottomBarWhenPushed = YES;
            login.state = @"push";
            login.whichControl = [NSString stringWithFormat:@"%@",self.class];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        YTXOrderViewController *vc=[[YTXOrderViewController alloc]init];
        vc.isgroup = model.isgroup;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag==1001){//收藏
        if(![[Global sharedInstance] userID]){
            //            [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
//            AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//            login.navTitle = @"用户验证";
//            //        login.state = @"push";
//            login.hidesBottomBarWhenPushed = YES;
//            login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//            [self.navigationController pushViewController:login animated:YES];
//            return;
            LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
            login.navTitle = @"用户验证";
            login.hidesBottomBarWhenPushed = YES;
            login.state = @"push";
            login.whichControl = [NSString stringWithFormat:@"%@",self.class];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        ShouCangVC *vc=[[ShouCangVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        NSDictionary* dict = @{@"uid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0"};
//        __weak typeof(self)weakSelf = self;
//        [ArtRequest GetRequestWithActionName:@"getuserverified" andPramater:dict succeeded:^(id responseObject) {
//            if ([responseObject isKindOfClass:[NSArray class]]){
//                for (NSDictionary* dic in responseObject) {
//                    NSString* idStr = [NSString stringWithFormat:@"%@",dic[@"id"]];
//                    if ([idStr isEqualToString:@"1"]){//判断鉴定
//                        NSString* statusStr = [NSString stringWithFormat:@"%@",dic[@"status"]];
//                        if ([statusStr isEqualToString:@"1"]){//1是
//                            KaiShiJiandingVC *vc=[[KaiShiJiandingVC alloc]init];
//                            vc.hidesBottomBarWhenPushed = YES;
//                            [weakSelf.navigationController pushViewController:vc animated:YES];
//                            break;
//                        }else{
//                        [ArtUIHelper addHUDInView:KEY_WINDOW text:[NSString stringWithFormat:@"未认证"] hideAfterDelay:1.0];
//                        }
//                    }
//                }
//            }
//        } failed:^(id responseObject) {
//            
//        }];
       
        
    }else if (btn.tag==1002){//消息
        MessageController * findvc = [[MessageController alloc] init];
        findvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:findvc animated:YES];
//        FensiVC *coupon2=[[FensiVC alloc] init];
//        coupon2.navigationItem.title = @"粉丝";
//        coupon2.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:coupon2 animated:YES];
    }else if (btn.tag==1003){//邀请
        InviteVc * search =[[InviteVc alloc]init];
        search.navTitle = @"邀请好友";
        search.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:search animated:YES];
//    [ArtUIHelper addHUDInView:self.view text:@"暂未开通" hideAfterDelay:1.0];
    }
    
}
- (void)leftViewAction
{
    if(![[Global sharedInstance] userID]){
        //            [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
//        AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//        login.navTitle = @"用户验证";
//        //        login.state = @"push";
//        login.hidesBottomBarWhenPushed = YES;
//        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//        [self.navigationController pushViewController:login animated:YES];
//        return;
        LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
        login.navTitle = @"用户验证";
        login.pushVC = [[UserController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        login.state = @"push";
        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
}
//个人简介
-(void)sendClick{
    if(![[Global sharedInstance] userID]){
        //            [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
//        AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//        login.navTitle = @"用户验证";
//        //        login.state = @"push";
//        login.hidesBottomBarWhenPushed = YES;
//        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//        [self.navigationController pushViewController:login animated:YES];
//        return;
        LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
        login.navTitle = @"用户验证";
        login.hidesBottomBarWhenPushed = YES;
        login.state = @"push";
        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    UserInfoVC *vc = [[UserInfoVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
