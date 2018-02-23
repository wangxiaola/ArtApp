//
//  ChooseViewController.m
//  meishubao
//
//  Created by LWR on 2016/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "ChooseViewController.h"
#import "GeneralConfigure.h"
#import "CustomTagView.h"
#import "HDTitleBtn.h"
#import "HDDropDownMenu.h"

#define CURRENT_VIEW_W SCREEN_WIDTH * 0.75

@interface ChooseViewController () <CustomTagViewDelegate, HDDrodownMenuDelegate> {
    
    NSArray  * _timeArr;
    NSArray  * _yearArr;
    NSInteger _update_time;
    NSInteger _manager_time;
}

@property (nonatomic, strong) CustomTagView  * kindView;      // 种类
@property (nonatomic, strong) CustomTagView  * areaView;      // 种类
@property (nonatomic, strong) HDTitleBtn     * updateTimeBtn; // 更新时间
@property (nonatomic, strong) HDTitleBtn     * operateBtn;    // 经营年代
@property (nonatomic, strong) UIButton       * searchBtn;     // 搜索
@property (nonatomic, strong) HDDropDownMenu * drowDownTime;  // 更新时间
@property (nonatomic, strong) HDDropDownMenu * drowDownYear;  // 经营年代

@property (nonatomic, strong) NSMutableArray * kindArr; // 更新时间
@property (nonatomic, strong) NSMutableArray * areaArr;// 经营年代

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self setup];
}

#pragma mark - 初始化
- (void)setup {

    [self.view addSubview:self.updateTimeBtn];
    [self.view addSubview:self.operateBtn];
    
    _timeArr = @[@"一个月内", @"三个月内", @"一年内"];
    _yearArr = @[@"一到三年", @"三到五年", @"五到十年", @"十年以上"];

//    _kindTagArr = @[@"国画", @"油画", @"书法", @"当代", @"水墨", @"雕塑", @"版画", @"摄影", @"多媒体", @"装置", @"影响", @"行为", @"漫画", @"综合材质", @"水彩", @"素描", @"色粉", @"丙烯", @"艺术衍生品", @"其他"];
    
    // 分割线
    CAShapeLayer *line = [CAShapeLayer new];
    line.frame = CGRectMake(CURRENT_VIEW_W * 0.5, 36, 0.5, 20);
    line.backgroundColor = RGBCOLOR(98, 98, 98).CGColor;
    [self.view.layer addSublayer:line];
    
    CAShapeLayer *line2 = [CAShapeLayer new];
    line2.frame = CGRectMake(0, 64, CURRENT_VIEW_W, 0.5);
    line2.backgroundColor = RGBALCOLOR(98, 98, 98, 0.5).CGColor;
    [self.view.layer addSublayer:line2];
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 64.5, CURRENT_VIEW_W, SCREEN_HEIGHT - 64.5 - 70)];
    
    if (isNightMode) {
        
        bottomV.backgroundColor = RGBALCOLOR(0, 0, 0, 0.8);
    }else {
    
        bottomV.backgroundColor = RGBALCOLOR(238, 238, 238, 1);
    }
    
    [self.view addSubview:bottomV];
    
    CAShapeLayer *line3 = [CAShapeLayer new];
    line3.frame = CGRectMake(0, bottomV.height - 0.5, CURRENT_VIEW_W, 0.5);
    line3.backgroundColor = RGBALCOLOR(98, 98, 98, 0.5).CGColor;
    [self.view.layer addSublayer:line3];
    
    [bottomV addSubview:self.kindView];
    [bottomV addSubview:self.areaView];
    [bottomV.layer addSublayer:line3];
    
    [self.view addSubview:self.searchBtn];
}

- (void)dismiss {
    
    if ([self.delegate respondsToSelector:@selector(dismiss)]) {
        [self.delegate dismiss];
    }
}

#pragma mark - HDDrodownMenuDelegate
- (void)dropDownMenuDismiss:(NSInteger)type {

    if (type == HDDropDownMenuTime) { // 时间
        
        if (self.updateTimeBtn.selected) {
            
            self.updateTimeBtn.selected = NO;
        }
        
    }else { // 年代
    
        if (self.operateBtn.selected) {
            
            self.operateBtn.selected = NO;
        }
    }
}

- (void)dropDownMenuBtnClick:(NSInteger)tag andType:(NSInteger)type {

    if (type == HDDropDownMenuTime) { // 时间
        
        _update_time = tag;
        self.updateTimeBtn.title = _timeArr[tag - 1];
        [self.drowDownTime dismiss];
        
    }else { // 年代
        
        _manager_time = tag;
        self.operateBtn.title = _yearArr[tag - 1];
        [self.drowDownYear dismiss];
    }
}

#pragma mark - CustomTagViewDelegate
- (void)tagListViewClick:(NSString *)title andType:(NSInteger)type andTag:(NSString *)tag {

    if (type == CustomTagViewTypeKind) { // 种类
        
        if ([tag isEqualToString:@"取消"]) {
            
            NDLog(@"取消");
            [self.kindArr removeObject:title];
            return;
        }
        [self.kindArr addObject:title];
        NDLog(@"---%@", title);
    }else { // 地区
    
        if ([tag isEqualToString:@"取消"]) {
            
            NDLog(@"取消");
            [self.areaArr removeObject:title];
            return;
        }
        [self.areaArr addObject:title];
        NDLog(@"+++%@", title);
    }
}

#pragma mark - 搜索
- (void)toSearchClick {
    
    NDLog(@"搜索 time--%ld  year--%ld kind--%@  area--%@", _update_time, _manager_time, self.kindArr, self.areaArr);
    NSMutableString *kindStr = [[NSMutableString alloc] init];
    NSInteger kindCount = self.kindArr.count;
    for (NSInteger i = 0; i < kindCount; i++) {
        
        [kindStr appendString:self.kindArr[i]];
        if (i != kindCount - 1) {
            
            [kindStr appendString:@","];
        }
    }
    
    NSMutableString *areaStr = [[NSMutableString alloc] init];
    NSInteger areaCount = self.areaArr.count;
    for (NSInteger i = 0; i < areaCount; i++) {
        
        [areaStr appendString:self.areaArr[i]];
        if (i != areaCount - 1) {
            
            [areaStr appendString:@","];
        }
    }
    
    NSDictionary *dic = @{
                          @"update_time"  : @(_update_time),
                          @"manager_time" : @(_manager_time),
                          @"art_cate"     : kindStr,
                          @"zone"         : areaStr,
                          };
    if (self.searchBlock) {
        
        self.searchBlock(dic);
    }
}

#pragma mark - 更新时间
- (void)timeClick {

    if (self.updateTimeBtn.selected) {
        
        [self.drowDownTime dismiss];
        self.updateTimeBtn.selected = NO;
    }else {
        [self.drowDownTime showInView:self.view andFrom:self.updateTimeBtn];
        self.updateTimeBtn.selected = YES;
        
        if (self.operateBtn.selected) {
            
            [self.drowDownYear dismiss];
            self.operateBtn.selected = NO;
        }
    }
}

- (void)yearClick {
    
    if (self.operateBtn.selected) {
        
        [self.drowDownYear dismiss];
        self.operateBtn.selected = NO;
    }else {
        [self.drowDownYear showInView:self.view andFrom:self.operateBtn];
        self.operateBtn.selected = YES;
        
        if (self.updateTimeBtn.selected) {
            
            [self.drowDownTime dismiss];
            self.updateTimeBtn.selected = NO;
        }
    }
}

- (void)reset {

    _updateTimeBtn.title = @"更新时间";
    _operateBtn.title    = @"经营年代";
    _update_time         = 0;
    _manager_time        = 0;
    [_kindArr removeAllObjects];
    [_areaArr removeAllObjects];
    
    [_kindView clearTags];
    _kindView.tagArr     = _kindTagArr;
    
    [_areaView clearTags];
    _areaView.tagArr     = _areaTagArr;
}

#pragma mark - 懒加载
- (HDTitleBtn *)updateTimeBtn {

    if (!_updateTimeBtn) {
        
        _updateTimeBtn = [[HDTitleBtn alloc] initWithFrame:CGRectMake(0, 37, CURRENT_VIEW_W * 0.5, 18)];
        _updateTimeBtn.title = @"更新时间";
        [_updateTimeBtn addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _updateTimeBtn;
}

- (HDTitleBtn *)operateBtn {
    
    if (!_operateBtn) {
        
        _operateBtn = [[HDTitleBtn alloc] initWithFrame:CGRectMake(CURRENT_VIEW_W * 0.5, 37, CURRENT_VIEW_W * 0.5, 18)];
        _operateBtn.title = @"经营年代";
        [_operateBtn addTarget:self action:@selector(yearClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _operateBtn;
}

- (UIButton *)searchBtn {
    
    if (!_searchBtn) {
        
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, CURRENT_VIEW_W, 70)];
        [_searchBtn setImage:[UIImage imageNamed:@"serch-red"] forState:UIControlStateNormal];
        _searchBtn.backgroundColor = [UIColor clearColor];
        [_searchBtn addTarget:self action:@selector(toSearchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _searchBtn;
}

- (CustomTagView *)kindView {

    if (!_kindView) {
        
        CGFloat h = 210.0;
        
        if (SCREEN_HEIGHT <= 568) {
            
            h = 170.0;
        }
        
        _kindView = [[CustomTagView alloc] initWithFrame:CGRectMake(0, 20.0, CURRENT_VIEW_W, h)];
        _kindView.title = @"艺术种类";
        _kindView.type = CustomTagViewTypeKind;
        _kindView.delegate = self;
        _kindView.tagArr = _kindTagArr;
    }
    
    return _kindView;
}

- (CustomTagView *)areaView {
    
    if (!_areaView) {
        
        CGFloat h = 275.0;
        CGFloat y = 240.0;
        
        if (SCREEN_HEIGHT <= 568) {
            
            h = 235.0;
            y = 200.0;
        }
        
        _areaView = [[CustomTagView alloc] initWithFrame:CGRectMake(0, y, CURRENT_VIEW_W, h)];
        _areaView.title = @"地区";
        _areaView.type = CustomTagViewTypeArea;
        _areaView.delegate = self;
        _areaView.tagArr = _areaTagArr;
    }
    
    return _areaView;
}

- (HDDropDownMenu *)drowDownTime {
    
    if (!_drowDownTime) {
        
        _drowDownTime = [[HDDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, CURRENT_VIEW_W, SCREEN_HEIGHT)];
        _drowDownTime.type = HDDropDownMenuTime;
        _drowDownTime.delegate = self;
        _drowDownTime.fromViewW = self.updateTimeBtn.width;
        _drowDownTime.titleArr = _timeArr;
    }
    return _drowDownTime;
}

- (HDDropDownMenu *)drowDownYear {
    
    if (!_drowDownYear) {
        
        _drowDownYear = [[HDDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, CURRENT_VIEW_W, SCREEN_HEIGHT)];
        _drowDownYear.type = HDDropDownMenuYear;
        _drowDownYear.delegate = self;
        _drowDownYear.fromViewW = self.operateBtn.width;
        _drowDownYear.titleArr = _yearArr;
    }
    return _drowDownYear;
}

- (NSMutableArray *)kindArr {

    if (!_kindArr) {
        
        _kindArr = [[NSMutableArray alloc] init];
    }
    return _kindArr;
}

- (NSMutableArray *)areaArr {
    
    if (!_areaArr) {
        
        _areaArr = [[NSMutableArray alloc] init];
    }
    return _areaArr;
}

- (void)dealloc {

    if (_areaView.delegate) {
        
        _areaView.delegate = nil;
    }
    
    if (_kindView.delegate) {
        
        _kindView.delegate = nil;
    }
    
    if (_drowDownTime.delegate) {
        
        _drowDownTime.delegate = nil;
    }
    
    if (_drowDownYear.delegate) {
        
        _drowDownYear.delegate = nil;
    }
}

@end
