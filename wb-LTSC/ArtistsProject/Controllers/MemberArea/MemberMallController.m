//
//  MemberAreaController.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/9.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MemberMallController.h"
#import "YTXHomeSearchVC.h"
#import "MemberVerifyC.h"
#import "AuthenticationModel.h"
#import "PublishShopController.h"
#import "PublishDongtaiVC.h"
#import "MemVeriCell.h"
#import "MemberInterduceModel.h"
#import "MemberMallListController.h"
#import "GoodsCategoryModel.h"
#import "LogonVc.h"
#define kMemVeriCell   @"MemVeriCell"
#define UPANDBOTTOMSPACE 20
#define BUTTONHEIGHT 30
#define MINIMUNSPACE 15

@interface MemberMallController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel,*bottomLabel;
    UIButton *enterBtn;
    AuthenticationModel  *model;
    NSString *veryfied;
    MemberInterduceModel *memModel;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *cellHeightArrayM;
@property (nonatomic, strong)NSMutableArray *isDisplayArrayM;
@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *tableViewDataM;
@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *collectionDataM;
@end

@implementation MemberMallController

-(NSMutableArray *)isDisplayArrayM{
    if (!_isDisplayArrayM) {
        _isDisplayArrayM = [NSMutableArray array];
    }
    return _isDisplayArrayM;
}

-(NSMutableArray *)cellHeightArrayM{
    if (!_cellHeightArrayM) {
        _cellHeightArrayM = [NSMutableArray array];
    }
    return _cellHeightArrayM;
}
- (NSMutableArray *)tableViewDataM{
    if (!_tableViewDataM) {
        _tableViewDataM = [NSMutableArray array];
    }
    return _tableViewDataM;
}

- (NSMutableArray *) collectionDataM{
    if (!_collectionDataM) {
        _collectionDataM = [NSMutableArray array];
    }
    return _collectionDataM;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACK_VIEW_COLOR;
        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[MemVeriCell class] forCellReuseIdentifier:kMemVeriCell];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.height.mas_greaterThanOrEqualTo(150);
        }];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //菜单选择器
    if (iOS7Later) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(0,0,300, 44)];
    title.text = @"劳特斯辰VIP会员专区";
    title.textAlignment = NSTextAlignmentCenter;
    [userView addSubview:title];
    self.navigationItem.titleView = userView;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    view.backgroundColor = BACK_VIEW_COLOR;
    [self.view addSubview:view];
    titleLabel = [[UILabel alloc] init];
    [self.view addSubview:titleLabel];
    titleLabel.text = @"会员须知";
    titleLabel.font = kFont(18);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(30);
    }];
    bottomLabel = [[UILabel alloc] init];
    [self.view addSubview:bottomLabel];
    bottomLabel.font = kFont(14);
    bottomLabel.numberOfLines = 0;
    bottomLabel.text = @"如果你无法简洁的表达你的想法，那只说明你还不够了解它";
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-15);
    }];
    enterBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.view addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(150);
    }];
    [enterBtn setTintColor:[UIColor whiteColor]];
    enterBtn.backgroundColor = [UIColor blackColor];
    [enterBtn setTitle:@"进入会员商城" forState:(UIControlStateNormal)];
    [enterBtn addTarget:self action:@selector(enterAction) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)enterAction
{
    if (![[Global sharedInstance] userID]) {
        LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
        login.navTitle = @"用户验证";
        login.hidesBottomBarWhenPushed = YES;
        login.state = @"push";
        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    kPrintLog(@"认证");
    if([veryfied integerValue] != 1){
        [self setupAlertWithMessage:@"会员专区,请先认证会员"];
        return;
    }
    MemberMallListController *mallList = [[MemberMallListController alloc] init];
    GoodsCategoryModel *goodmodel = self.collectionDataM[0];
    mallList.collArray = goodmodel.child;
    kPrintLog(mallList.collArray);
    [self.navigationController pushViewController:mallList animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadUserData];
    [self updataDate];
    [self loadMemberIntroduce];
}

//加载用户认证信息
- (void)loadUserData{
    
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取信息" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?:@"0",@"type":@"16"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getUserAuth" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        kPrintLog(responseObject)
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        model = [AuthenticationModel mj_objectWithKeyValues:responseObject];
        if (responseObject[@"res"]&&[responseObject[@"res"] integerValue] == 0){
            veryfied = @"2";
        }else{
            veryfied = model.verified;
        }
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}

// 搜索视图消息代理方法
- (void)menSearchNewMessage:(UIButton *)button
{
    [self.view endEditing:YES];
    [button setTitle:@"" forState:(UIControlStateNormal)];
}


- (void)setupAlertWithMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        MemberVerifyC *authenticationVC = [[MemberVerifyC alloc]init];
        authenticationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authenticationVC animated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:nil];
    [alertVC addAction:action];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}
// 会员介绍
- (void)loadMemberIntroduce
{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取信息" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?:@"0"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"groupcontent" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        kPrintLog(responseObject)
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        memModel = [MemberInterduceModel mj_objectWithKeyValues:responseObject];
        [self.tableView reloadData];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGSize jsSize = [self sizeForLblContent:memModel.hyjs fixMaxWidth:kScreenWidth - 30 andFondSize:14];
            CGSize tqSize = [self sizeForLblContent:memModel.hytq fixMaxWidth:kScreenWidth - 30 andFondSize:14];
            if (jsSize.height + tqSize.height<160) {
                make.height.mas_equalTo(200);
            }else{
                make.height.mas_equalTo(jsSize.height + tqSize.height + 40 );
            }
        }];
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
    
}
//请求数据
- (void)updataDate{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [ArtRequest GetRequestWithActionName:@"goodstype" andPramater:nil succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        [self hideHUD];
        [self.tableViewDataM removeAllObjects];
        [self.collectionDataM removeAllObjects];
        [self.tableViewDataM addObjectsFromArray:[GoodsCategoryModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseObject]];
        //选中第一个cell
        if (self.tableViewDataM.count) {
            for (GoodsCategoryModel *goodmodel in self.tableViewDataM) {
                if ([goodmodel.title isEqualToString:@"会员区"]) {
                    [self.collectionDataM addObject:goodmodel];
                }
            }
        }
        kPrintLog(self.collectionDataM);
    } failed:^(id responseObject) {
        
        [self hideHUD];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CGSize Size = [self sizeForLblContent:memModel.hyjs fixMaxWidth:kScreenWidth - 30 andFondSize:14];
        return Size.height > 100?Size.height:100;

    }else{
        CGSize Size = [self sizeForLblContent:memModel.hytq fixMaxWidth:kScreenWidth - 30 andFondSize:14];
        return Size.height > 100?Size.height:100;
    }
}
// 通过给定文字和字体大小在指定的最大宽度下，计算文字实际所占的尺寸
- (CGSize)sizeForLblContent:(NSString *)strContent fixMaxWidth:(CGFloat)w andFondSize:(int)fontSize{
    // 先获取文字的属性，特别是影响文字所占尺寸相关的
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 把该属性放到字典中
    NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:font,NSFontAttributeName, nil];
    // 通过字符串的计算文字所占尺寸方法获取尺寸
    CGSize size = [strContent boundingRectWithSize:CGSizeMake(w, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicAttr context:nil].size;
    return size;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemVeriCell *cell = [tableView dequeueReusableCellWithIdentifier:kMemVeriCell forIndexPath:indexPath];
    cell.backgroundColor = BACK_VIEW_COLOR;
    if (indexPath.row == 0){
        cell.title.text = @"会员介绍";
        cell.content.text = memModel.hyjs;
    }else{
        cell.title.text = @"会员特权";
        cell.content.text = memModel.hytq;
    }
    return cell;
}

@end
