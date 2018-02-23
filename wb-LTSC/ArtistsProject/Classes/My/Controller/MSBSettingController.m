//
//  MSBSettingController.m
//  meishubao
//
//  Created by T on 16/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBSettingController.h"
#import "MSBInfoSettingController.h"
#import "MSBHelpFeedController.h"
#import "GeneralConfigure.h"

#import "HDSettingArrowCell.h"
#import "LGMessSettingSwitchCell.h"

#import "OfflineReadViewController.h"
#import "OfflineListViewController.h"

//#import "UITableView+Common.h"
@pickerify(HDSettingArrowCell, cellTintColor)
@pickerify(LGMessSettingSwitchCell, cellTintColor)
@interface MSBSettingController ()<UITableViewDelegate, UITableViewDataSource>{
        NSArray  *_datas;
}
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) UIView * footerView;
@end

@implementation MSBSettingController
static NSString *const KEY_TITLE = @"title";
static NSString *const KEY_TAP = @"tap";
static NSString *const KEY_SETTER = @"setter";
static NSString *const KEY_IDENTIFIER = @"identifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xDCDCDC, 0x1c1c1c);
    
    [self refreshDataSource];
    [self.tableView reloadData];
}

- (void)dealloc {
    
    if (_tableView) {
        
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
    }
}


#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.row;
    
    NSDictionary *item = _datas[row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item[KEY_IDENTIFIER]];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//     [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSDictionary *item = _datas[row];
    
    if ([item[KEY_IDENTIFIER] isEqualToString:[HDSettingArrowCell identifier]]) {
      HDSettingArrowCell * arrowCell = (HDSettingArrowCell *)cell;
        //arrowCell.dk_cellTintColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        if (indexPath.row == 1) {
            [arrowCell setArrowTitle:[[NSUserDefaults standardUserDefaults] objectForKey:APP_WEB_FONTNAME]?:@"中"];
        }
    }
    
//    if ([item[KEY_IDENTIFIER] isEqualToString:[LGMessSettingSwitchCell identifier]]) {
//        LGMessSettingSwitchCell * switchCell = (LGMessSettingSwitchCell *)cell;
//        switchCell.dk_cellTintColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
//    }
    
    if ([cell respondsToSelector:@selector(setTitle:)]) {
        [(id)cell setTitle:item[KEY_TITLE]];
    }
    
    if (item[KEY_SETTER]) {
        SEL sel = NSSelectorFromString(item[KEY_SETTER]);
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL, UITableViewCell *) = (void *)imp;
        func(self, sel, cell);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *item = _datas[row];
    
    if (item[KEY_TAP] && cell) {
        
        SEL sel = NSSelectorFromString(item[KEY_TAP]);
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL, UITableViewCell *) = (void *)imp;
        func(self, sel, cell);
    }
}


#pragma mark - Methods
- (void)refreshDataSource {
   
    NSDictionary *personSetting = @{KEY_TITLE:@"个人设置",
                             KEY_TAP:NSStringFromSelector(@selector(setPersonSetting:)),
                             KEY_IDENTIFIER:[HDSettingArrowCell identifier]
                             };
   
    NSDictionary *fontSize = @{
                          KEY_TITLE:@"正文字号",
                          KEY_TAP:NSStringFromSelector(@selector(setFontSize:)),
                          KEY_IDENTIFIER:[HDSettingArrowCell identifier]
                          };
    
    NSDictionary *nightMode = @{
                                KEY_TITLE:@"设置夜间模式",
                                KEY_SETTER:NSStringFromSelector(@selector(setNightMode:)),
                                KEY_IDENTIFIER:[LGMessSettingSwitchCell identifier]
                                };
  
    NSDictionary *accountPassword = @{
                                      KEY_TITLE:@"账号密码安全",
                                      KEY_TAP:NSStringFromSelector(@selector(setPassword:)),
                                      KEY_IDENTIFIER:[HDSettingArrowCell identifier]
                            };
 
    NSDictionary *offlineRead = @{
                                  KEY_TITLE:@"离线阅读",
                                  KEY_TAP:NSStringFromSelector(@selector(setOfflineRead:)),
                                  KEY_IDENTIFIER:[HDSettingArrowCell identifier]
                             };
  
    NSDictionary *photoLoad = @{
                                KEY_TITLE:@"仅Wifi下载图片",
                                KEY_SETTER:NSStringFromSelector(@selector(setPhotoLoad:)),
                                KEY_IDENTIFIER:[LGMessSettingSwitchCell identifier]
                              };
    
//    NSDictionary *helpfeed = @{
//                                KEY_TITLE:@"帮助与反馈",
//                                KEY_TAP:NSStringFromSelector(@selector(setHelpfeed:)),
//                                KEY_IDENTIFIER:[HDSettingArrowCell identifier]
//                                };
    
    NSDictionary *pingfen = @{
                               KEY_TITLE:@"为中国美术报评分",
                               KEY_TAP:NSStringFromSelector(@selector(setPingfen:)),
                               KEY_IDENTIFIER:[HDSettingArrowCell identifier]
                               };
    
    _datas = @[personSetting,fontSize,nightMode,accountPassword,offlineRead,photoLoad,pingfen];
}

-(void)setFontSize:(HDSettingArrowCell *)cell{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"设置字体大小" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = RGBCOLOR(181, 27, 32);
    __block NSString * font;
    __block NSInteger size;
    [alert addAction:[UIAlertAction actionWithTitle:@"小" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        font = @"小";
        size = 0;
        [self saveFontSizeWithFont:font size:size];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        font = @"中";
        size = 1;
        [self saveFontSizeWithFont:font size:size];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"大" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        font = @"大";
        size = 2;
        [self saveFontSizeWithFont:font size:size];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"特大" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        font = @"特大";
        size = 3;
        [self saveFontSizeWithFont:font size:size];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

-(void)saveFontSizeWithFont:(NSString *)font size:(NSInteger)size
{
    [[NSUserDefaults standardUserDefaults] setInteger:size forKey:APP_WEBVIEW_FONTSIZE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    HDSettingArrowCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell setArrowTitle:font];
    
    [[NSUserDefaults standardUserDefaults] setObject:font forKey:APP_WEB_FONTNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setNightMode:(LGMessSettingSwitchCell *)cell{
    [self setSwitchDataWithCell:cell userDefaultKey:APP_NIGHT_MODE type:1];
}

-(void)setOfflineRead:(HDSettingArrowCell *)cell{
//    [self setSwitchDataWithCell:cell userDefaultKey:APP_OFFLINE_MODE type:2];
    
    NSString *filePath = [kDocumentsPath stringByAppendingString:@"/termArr.data"];
    NDLog(@"路径--%@", [kDocumentsPath stringByAppendingString:@"/termArr.data"]);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSArray  *termArr  = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        OfflineListViewController *listVC = [[OfflineListViewController alloc] init];
        listVC.termArr = termArr;
        listVC.settingVC = self;
        [self.navigationController pushViewController:listVC animated:YES];
    }else {
        
        OfflineReadViewController *lineRead = [[OfflineReadViewController alloc] init];
        lineRead.settingVC = self;
        [self.navigationController pushViewController:lineRead animated:YES];
    }
}

-(void)setPhotoLoad:(LGMessSettingSwitchCell *)cell{
    [self setSwitchDataWithCell:cell userDefaultKey:APP_WIFI_PHOTO_MODE type:3];
}

- (void)setSwitchDataWithCell:(LGMessSettingSwitchCell *)cell
               userDefaultKey:(NSString *)key
                         type:(NSInteger)type {
    __weak __block typeof(self) weakSelf = self;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [cell setOn:[userdefaults objectForKey:key] == nil ? NO : [userdefaults boolForKey:key]];
    [cell setChangeBlock:^(BOOL isOn){
        NSString *key = nil;
        switch (type) {
            case 1:
                key = APP_NIGHT_MODE;
                [weakSelf changeNightModel:isOn];
                break;
            case 2:
                key = APP_OFFLINE_MODE;
                break;
            case 3:
                key = APP_WIFI_PHOTO_MODE;
                break;
        }
        [userdefaults setBool:isOn forKey:key];
        [userdefaults synchronize];
    }];
}

- (void)changeNightModel:(BOOL )isOn{
    if (isOn) {
         [self.dk_manager nightFalling];
    }else{
         [self.dk_manager dawnComing];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeColor" object:nil userInfo:@{@"isNight":@(isOn)}];
}

- (void)setPersonSetting:(HDSettingArrowCell *)cell{
    BOOL isLogin =  [MSBJumpLoginVC jumpLoginVC:self];
    if (isLogin) {return;}
    [self.navigationController pushViewController:[MSBInfoSettingController new] animated:YES];
}

-(void)setHelpfeed:(HDSettingArrowCell *)cell{
    [self.navigationController pushViewController:[MSBHelpFeedController new] animated:YES];
}

-(void)setPassword:(HDSettingArrowCell *)cell{
    [self.navigationController pushViewController:[FindPwdViewController new] animated:YES];
}

-(void)setPingfen:(HDSettingArrowCell *)cell{
    
    NSString *URL = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/zhong-guo-mei-shu-bao/id1207766770?mt=8"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
}

#pragma mark - 退出登录
- (void)loginClick{
    [self hudLoding];
    __weak __block typeof(self) weakSelf = self;
    
    [[LLRequestBaseServer shareInstance] requestLoginOutSuccess:^(LLResponse *response, id data) {
        [weakSelf hiddenHudLoding];
        [MSBAccount loginOut];
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINOUT_SUCCESS" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(LLResponse *response) {
        [weakSelf hiddenHudLoding];
        [MSBAccount loginOut];
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINOUT_SUCCESS" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *error) {
        [weakSelf hiddenHudLoding];
        [MSBAccount loginOut];
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINOUT_SUCCESS" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - setter/getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, APP_NAVIGATIONBAR_H, SCREEN_WIDTH, SCREEN_HEIGHT - APP_NAVIGATIONBAR_H) style:UITableViewStyleGrouped];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        //[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.dk_separatorColorPicker = CellLineColor;
//         _tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        [_tableView registerClass:[HDSettingArrowCell class] forCellReuseIdentifier:[HDSettingArrowCell identifier]];
        [_tableView registerClass:[LGMessSettingSwitchCell class] forCellReuseIdentifier:[LGMessSettingSwitchCell identifier]];
        [self.view addSubview:_tableView];

        UILabel * versionLabel = [UILabel new];
        versionLabel.frame = CGRectMake(0, _tableView.height - (isiPhoneX?(20 + iPhoneXBottomHeight):30), _tableView.width, 20);
        versionLabel.dk_textColorPicker = DKColorPickerWithRGB(0x7a7a7a, 0x989898);
        versionLabel.textAlignment = NSTextAlignmentCenter;
        versionLabel.font = [UIFont systemFontOfSize:10];
        versionLabel.backgroundColor = [UIColor clearColor];
        [_tableView addSubview:versionLabel];

        NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        versionLabel.text = [NSString stringWithFormat:@"中国美术报 Version %@",version];
    }
    
    return _tableView;
}

- (UIView *)footerView {

    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        _footerView.backgroundColor = [UIColor clearColor];

        MSBCustomBtn *logoutBtn = [MSBCustomBtn buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(30, 16, _footerView.width - 60, 39.0);
        [_footerView addSubview:logoutBtn];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [logoutBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    BOOL isLogin =  [MSBAccount userLogin];
    if (isLogin) {
        //已登录的时候，才创建退出登录
        self.tableView.tableFooterView = self.footerView;
    }
}

@end
