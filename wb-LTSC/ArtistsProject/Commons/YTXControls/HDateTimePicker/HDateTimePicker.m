//
//  HDateTimePicker.m
//  Car
//
//  Created by HeLiulin on 15/9/13.
//  Copyright (c) 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HDateTimePicker.h"

@interface HDateTimePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong) NSMutableArray *lstDay;
@property(nonatomic,strong) NSMutableArray *lstHour;
@property(nonatomic,strong) NSMutableArray *lstMin;
@property(nonatomic,strong) UIPickerView *pickerView;
@end

@implementation HDateTimePicker
@synthesize pickerView;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self customInit];
}

- (void) customInit
{
    [self.view setFrame:CGRectMake(0, 0, kScreenW, 200)];
    self.navItem.title=@"时间选择";
    // 选择框
    pickerView = [UIPickerView new];
    [self.viewContent addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.equalTo(self.viewContent);
        make.width.mas_equalTo(kScreenW);
    }];
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [self.viewContent mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.viewContent.subviews.lastObject);
    }];
    
    
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    UIBarButtonItem *btn2=[[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    self.navItem.leftBarButtonItems=@[btn1,btn2];
    
    UIBarButtonItem *btn3=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
    [btn3 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
    self.navItem.rightBarButtonItems=@[btn3];
    
    //设置导航栏左右按钮字体和颜色
    [btn1 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
    [btn2 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
    
    _lstDay=[[NSMutableArray alloc] initWithCapacity:0];
    _lstHour=[[NSMutableArray alloc] initWithCapacity:0];
    _lstMin=[[NSMutableArray alloc] initWithCapacity:0];
    
    NSCalendar *gregorian=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    NSDate *today= [gregorian dateFromComponents:components];

    for (int i=0; i < 30; i++){
        switch (i) {
            case 0:
                [_lstDay addObject:@"今天"];
                break;
            case 1:
                [_lstDay addObject:@"明天"];
                break;
            default:{
                NSDate  *date= [today dateByAddingTimeInterval:i * 86400];
                [_lstDay addObject:[date formatWithString:@"MM月dd日"]];
                break;
            }
        }

    }
    for (int i=0; i<24; i++) {
        [_lstHour addObject:[NSString stringWithFormat:@"%@时",@(i)]];
    }
    for (int i=0; i<60; i+=10) {
        if (i==0){
            [_lstMin addObject:@"00分"];
        }else{
            [_lstMin addObject:[NSString stringWithFormat:@"%@分",@(i)]];
        }
    }
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0){
        return _lstDay.count;
    }
    if (component == 1) {
        return _lstHour.count;
    }
    
    return _lstMin.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component==0){
        return (kScreenW-20)/3;
    }
    return (kScreenW-20)/3;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
//        _proNameStr = [_proTitleList objectAtIndex:row];
    } else {
//        _proTimeStr = [_proTimeList objectAtIndex:row];
    }
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_lstDay objectAtIndex:row];
    } if (component == 1){
        return [_lstHour objectAtIndex:row];
    } else {
        return [_lstMin objectAtIndex:row];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
//        pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:self.pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (NSDate*) selecteDate
{
    NSInteger dayIndex=[pickerView selectedRowInComponent:0];
    NSInteger hour=[pickerView selectedRowInComponent:1];
    NSInteger min=[pickerView selectedRowInComponent:2];
    
    NSCalendar *gregorian=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    components.hour=hour;
    components.minute=min*10;
    NSDate *today= [gregorian dateFromComponents:components];
    return [today dateByAddingTimeInterval:dayIndex * 86400];
}
- (void) setSelecteDate:(NSDate *)selecteDate
{
    [pickerView selectRow:[[selecteDate formatWithString:@"HH"] integerValue] inComponent:1 animated:YES];
    [pickerView selectRow:[[selecteDate formatWithString:@"mm"] integerValue]/10 inComponent:2 animated:YES];
}

- (void) clear
{
    if (self.clearBlock){
        self.clearBlock();
        [self dismiss];
    }
}

- (void) ok
{
    NSInteger dayIndex = [pickerView selectedRowInComponent:0];
    NSInteger hour = [pickerView selectedRowInComponent:1];
    NSInteger min = [pickerView selectedRowInComponent:2];

    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components = [gregorian components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    components.hour = hour;
    components.minute = min * 10;
    NSDate* today = [gregorian dateFromComponents:components];
    NSDate* selectDate = [today dateByAddingTimeInterval:dayIndex * 86400];

    if (self.selectedBlock) {
        self.selectedBlock(selectDate);
        [self dismiss];
    }
}

@end
