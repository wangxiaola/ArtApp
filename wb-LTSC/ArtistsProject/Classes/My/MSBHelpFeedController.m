//
//  MSBHelpFeedController.m
//  meishubao
//
//  Created by T on 16/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBHelpFeedController.h"
#import "MSBFeedController.h"
#import "MSBCommonQuestionVC.h"

#import "GeneralConfigure.h"

#import "LDNetDiagnoService.h"

#import "HDSettingArrowCell.h"
#import "UITableView+Common.h"
#import "AFNetworkReachabilityManager.h"

@interface MSBHelpFeedController ()<UITableViewDelegate, UITableViewDataSource, LDNetDiagnoServiceDelegate>{
    LDNetDiagnoService *_netDiagnoService;
    BOOL _isRunning;
}
@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,strong) AFNetworkReachabilityManager *manager ;

@end

@implementation MSBHelpFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助与反馈";
//    [self setTitle:@"帮助与反馈"];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    _netDiagnoService = [[LDNetDiagnoService alloc] initWithAppCode:@"test"
//                                                            appName:@"网络诊断应用"
//                                                         appVersion:@"1.0.0"
//                                                             userID:@"836132162@qq.com"
//                                                           deviceID:nil
//                                                            dormain:@"www.baidu.com"
//                                                        carrierName:nil
//                                                     ISOCountryCode:nil
//                                                  MobileCountryCode:nil
//                                                      MobileNetCode:nil];
//    _netDiagnoService.delegate = self;
//    _isRunning = NO;

    
    // commitInit
    [self commitInit];
    
    [self requestDatas];
    
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)feedClick{
    [self.navigationController pushViewController:[MSBFeedController new] animated:YES];
}

- (void)networkClick{
    [self hudLoading:@"检测中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            //当网络状态发生变化时会调用这个block
            [weakSelf .manager stopMonitoring];
            weakSelf.manager = nil;
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWiFi:
                case AFNetworkReachabilityStatusReachableViaWWAN:{

                    [weakSelf showSuccess:@"网络正常"];
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                case AFNetworkReachabilityStatusUnknown:{
                    [weakSelf hiddenHudLoding];

                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请到设置中检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                    [weakSelf.navigationController presentViewController:alert animated:YES completion:nil];
                }
                    break;
                default:
                    break;
            }
        }];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *contentView = [UIView new];
    contentView.frame = CGRectMake(15, 0, SCREEN_WIDTH - 15, 44.f);
    contentView.dk_backgroundColorPicker =  DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
    UILabel *title = [UILabel new];
    [title setText:@"常见问题"];
     title.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
    title.frame = CGRectMake(15, 0, 100, 44.f);
    [contentView addSubview:title];
    return contentView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HDSettingArrowCell identifier]];
//    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    HDSettingArrowCell * arrowCell = (HDSettingArrowCell *)cell;
    NSDictionary *dic = self.datas[row];
    [arrowCell setTitle:dic[@"question"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.datas[indexPath.row];
    MSBCommonQuestionVC *questionVC = [MSBCommonQuestionVC new];
    questionVC.titleContent =dic[@"question"];
    questionVC.desContent = dic[@"answer"];
    [self.navigationController pushViewController:questionVC animated:YES];
}

#pragma mark NetDiagnosisDelegate
- (void)netDiagnosisDidStarted{
    NSLog(@"netDiagnosisDidStarted");
}

- (void)netDiagnosisStepInfo:(NSString *)stepInfo{
    NSLog(@"%@", stepInfo);
}


- (void)netDiagnosisDidEnd:(NSString *)allLogInfo{
    __weak __block typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf hudTip:@"诊断完成"];
    });

    //NSLog(@"logInfo>>>>>\n%@====%@", allLogInfo, [NSThread currentThread]);
}

- (void)requestDatas{
    __weak __block typeof(self) weakSelf = self;
    [self hudLoding];
    [[LLRequestBaseServer shareInstance] requestCommonQuestionSuccess:^(LLResponse *response, id data) {
        [weakSelf hiddenHudLoding];
        if (data && [data isKindOfClass:[NSArray class]]) {
            _datas = [NSMutableArray array];
            [_datas addObjectsFromArray:data];
            [weakSelf.tableView reloadData];
        }
    } failure:^(LLResponse *response) {
         [weakSelf hiddenHudLoding];
    } error:^(NSError *error) {
         [weakSelf hiddenHudLoding];
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setRowHeight:44.f];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        _tableView.dk_separatorColorPicker = DKColorPickerWithRGB(0xaaaaaa, 0x282828);
        [self.view addSubview:_tableView];
        [_tableView registerClass:[HDSettingArrowCell class] forCellReuseIdentifier:[HDSettingArrowCell identifier]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    }
    
    return _tableView;
}

- (void)commitInit{
    UIView *headerView = [UIView new];
    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.view addSubview:headerView];
    headerView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
    
    UIButton *feedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [feedBtn setTitle:@"意见反馈" forState:UIControlStateNormal];

    feedBtn.dk_backgroundColorPicker = DKColorPickerWithRGB(0xfafafa, 0x222222);
    [feedBtn.layer setCornerRadius:5.f];
    [feedBtn setClipsToBounds:YES];
    UIImage *feedImage = [UIImage imageNamed:@"pencil_normal"];
    UIImage  *networkImage = [UIImage imageNamed:@"network_wifi"];
    if (THEME_NORMAL) {
        feedImage =  [feedImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
        networkImage = [networkImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
    }else{
        feedImage =  [feedImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        networkImage = [networkImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
    }

    [feedBtn setImage:feedImage forState:UIControlStateNormal];

    [feedBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    
    [feedBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x5e5e5e, 0x989898) forState:UIControlStateNormal];

    [feedBtn addTarget:self action:@selector(feedClick) forControlEvents:UIControlEventTouchUpInside];
    [feedBtn setFrame:CGRectMake(15, 4, SCREEN_WIDTH - 30, 44.f)];
    [headerView addSubview:feedBtn];
    
    UIButton *networkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [networkBtn setTitle:@"网络诊断" forState:UIControlStateNormal];

    networkBtn.dk_backgroundColorPicker = DKColorPickerWithRGB(0xfafafa, 0x222222);
    [networkBtn.layer setCornerRadius:5.f];
    [networkBtn setImage:networkImage forState:UIControlStateNormal];
    [networkBtn setClipsToBounds:YES];

    [networkBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [networkBtn.imageView setMj_size:CGSizeMake(networkBtn.imageView.width+10, networkBtn.imageView.height+10)];
    
    [networkBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x5e5e5e, 0x989898) forState:UIControlStateNormal];
    [networkBtn addTarget:self action:@selector(networkClick) forControlEvents:UIControlEventTouchUpInside];
    [networkBtn setFrame:CGRectMake(15, CGRectGetMaxY(feedBtn.frame)+ 4, SCREEN_WIDTH - 30, 44.f)];
    [headerView addSubview:networkBtn];
}

- (AFNetworkReachabilityManager *)manager
{
    if (!_manager) {
        _manager = [AFNetworkReachabilityManager sharedManager];
        [_manager startMonitoring];
    }
    return _manager;
}
@end
