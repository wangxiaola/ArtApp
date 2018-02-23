//
//  MSBHistoryReadController.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBHistoryReadController.h"
#import "MSBArticleDetailController.h"
#import "GeneralConfigure.h"


#import "HDSettingArrowCell.h"
#import "UITableView+Common.h"

#import "MSBReadHistoryTool.h"
@interface MSBHistoryReadController ()<FSCalendarDelegateAppearance>{
   NSLayoutConstraint *_calendarHeightConstraint;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)  FSCalendar *calendar;
@property(nonatomic,strong) NSMutableArray *datas;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic, weak) UILabel  *tipsLab;
@end

@implementation MSBHistoryReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"阅读历史";
//    [self setTitle:@"阅读历史"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";

    NSString *today = [self.dateFormatter stringFromDate:self.calendar.today];
    
    NSArray *array =  [MSBReadHistoryTool searchDBWithTime:today];
    
    _datas = [NSMutableArray array];
    
    [_datas addObjectsFromArray:array];
    
//    [_datas addObject:@"关注田弘的画，时间不算很短了。能吸引我的主要是她的画里面的气息，没有什么琐碎的和不净的东西，静静的就呆在那里。关注田弘的画，时间不算很短了"];
//    
//    [_datas addObject:@"关注田弘的画，时间不算很短了。"];
//    
//    [_datas addObject:@"关注田弘的画，"];
    
    [self.tableView reloadData];
    
    self.tipsLab.text = @"123";
    
    self.tipsLab.attributedText = [self attributeStringWithNum:_datas.count dateStr:today];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    [self.tipsLab setText:@"123"];
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:[HDSettingArrowCell identifier]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    NSInteger row = indexPath.row;
    MSBHistoryModel *item = _datas[row];
    HDSettingArrowCell *valueCell = (HDSettingArrowCell *)cell;
    [valueCell setHistoryModel:item];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MSBHistoryModel *item = _datas[indexPath.row];
    MSBArticleDetailController *articleDetailVC = [MSBArticleDetailController new];
    articleDetailVC.tid =item.tid;
    [self.navigationController pushViewController:articleDetailVC animated:YES];
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    _calendarHeightConstraint.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
    
    [_datas removeAllObjects];
    NSArray *array =  [MSBReadHistoryTool searchDBWithTime:[self.dateFormatter stringFromDate:date]];
    [_datas addObjectsFromArray:array];
    self.tipsLab.attributedText = [self attributeStringWithNum:_datas.count dateStr:[self.dateFormatter stringFromDate:date]];
    [self.tableView reloadData];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"%s %@", __FUNCTION__, [self.dateFormatter stringFromDate:calendar.currentPage]);
}



#pragma mark - setter/getter
- (FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectZero];
        [_calendar setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_calendar setDelegate:self];
        [_calendar setDataSource:self];
        [_calendar.scopeGesture setEnabled:YES];
        [_calendar setScope:FSCalendarScopeWeek animated:YES];
        _calendar.headerHeight = 30.f;
        [self.view addSubview:_calendar];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_calendar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_calendar)]];
        
        [self.view addConstraints:@[
                                    _calendarHeightConstraint =  [NSLayoutConstraint constraintWithItem:_calendar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:300.f],
                                     [NSLayoutConstraint constraintWithItem:_calendar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:-4.f]
                                    ]];
    }
    return _calendar;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        [self.view addSubview:_tableView];
        [_tableView registerClass:[HDSettingArrowCell class] forCellReuseIdentifier:[HDSettingArrowCell identifier]];
        FSCalendar *calendar = self.calendar;
        
        UILabel *tipsLab = [[UILabel alloc] init];
        tipsLab.textAlignment = NSTextAlignmentCenter;
        [tipsLab setFont:[UIFont systemFontOfSize:12]];
//        [tipsLab setText:@"今天阅读了10条新闻"];
        self.tipsLab = tipsLab;
        tipsLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20.f);
        tipsLab.dk_backgroundColorPicker = DKColorPickerWithRGB(0xdadada, 0xdadada);
        _tableView.tableHeaderView = tipsLab;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[calendar]-0-[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(calendar,_tableView)]];
    }
    
    return _tableView;
}

#pragma mark - Private Method
- (BOOL)isToday:(NSString *)dateStr{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = self.dateFormatter.dateFormat;
    NSString *dateFormatterString = [formatter stringFromDate:date];
    
    if ([dateStr isEqualToString:dateFormatterString]) {
        return true;
    }
    
    return false;
}

- (NSMutableAttributedString  *)attributeStringWithNum:(NSUInteger)num dateStr:(NSString *)dateStr{
    
    NSString *date = nil;
    NSInteger index = 0;
    NSInteger count = (num / 10 + 1);
    if ([self isToday:dateStr]) {
        date = @"今天";
        index = 6;
    }
    else{
        date = [[dateStr substringFromIndex:8] stringByAppendingString:@"号"];
        index = 7;
    }

    NSString *str = [[date stringByAppendingString:@"您阅读了"] stringByAppendingFormat:@"%tu条新闻", num];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    //设置字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, str.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, index)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(index, count)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(index+count, 3)];
    
    return attrStr;
}
@end
