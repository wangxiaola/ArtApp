//
//  ZJBLStoreShopTypeAlert.m
//  ZJBL-SJ
//
//  Created by 郭军 on 2017/4/20.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "ZJBLStoreShopTypeAlert.h"
#import "UIColor+Hex.h"

#define kAlertHeight   300
@interface SelectAlertCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
// botview
@property (nonatomic, strong) UIView *botview;
@end

@implementation SelectAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        _botview = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.contentView.frame.size.width, 1)];
        _botview.backgroundColor = BACK_VIEW_COLOR;
        [self.contentView addSubview:_botview];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor hexChangeFloat:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(15, 0, self.contentView.frame.size.width, 49);
}

@end


@interface ZJBLStoreShopTypeAlert () {
    float alertHeight;//弹框整体高度，默认300
    float buttonHeight;//按钮高度，默认40
}


@property (nonatomic, assign) BOOL showCloseButton;//是否显示关闭按钮
@property (nonatomic, strong) UIView *alertView;//弹框视图
@property (nonatomic, strong) UITableView *selectTableView;//选择列表

@end


@implementation ZJBLStoreShopTypeAlert

+ (ZJBLStoreShopTypeAlert *)showWithTitle:(NSString *)title
                        titles:(NSArray *)titles
                   selectIndex:(SelectIndex)selectIndex
                   selectValue:(SelectValue)selectValue
               showCloseButton:(BOOL)showCloseButton {
    ZJBLStoreShopTypeAlert *alert = [[ZJBLStoreShopTypeAlert alloc] initWithTitle:title titles:titles selectIndex:selectIndex selectValue:selectValue showCloseButton:showCloseButton];
    return alert;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 8;
        _alertView.layer.masksToBounds = YES;
    }
    return _alertView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor colorWithRed:0 green:127/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _selectTableView;
}

- (instancetype)initWithTitle:(NSString *)title titles:(NSArray *)titles selectIndex:(SelectIndex)selectIndex selectValue:(SelectValue)selectValue showCloseButton:(BOOL)showCloseButton {
    if (self = [super init]){
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10000, 10000)];
        backview.backgroundColor = [UIColor lightGrayColor];
        backview.alpha = 0.6;
        [self addSubview:backview];
        alertHeight = titles.count * 50>kAlertHeight?kAlertHeight:titles.count*50;
        buttonHeight = 40;
        
        self.titleLabel.text = title;
        _titles = titles;
        _selectIndex = [selectIndex copy];
        _selectValue = [selectValue copy];
        _showCloseButton = showCloseButton;
        [self addSubview:self.alertView];
        if (title != nil && ![title isEqualToString:@""]) {
            [self.alertView addSubview:self.titleLabel];
        }
        [self.alertView addSubview:self.selectTableView];
        if (_showCloseButton) {
            [self.alertView addSubview:self.closeButton];
        }
        [self initUI];
        
        [self show];
    }
    return self;
}

- (void)show {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{
        self.alertView.alpha = 1;
    }];
}

- (void)initUI {
    self.alertView.frame = CGRectMake(20, ([UIScreen mainScreen].bounds.size.height-alertHeight)/2.0, [UIScreen mainScreen].bounds.size.width-40, alertHeight);
    self.titleLabel.frame = CGRectMake(0, 0, _alertView.frame.size.width, buttonHeight);
    float reduceHeight = buttonHeight;
    if (_showCloseButton) {
        self.closeButton.frame = CGRectMake(0, _alertView.frame.size.height - buttonHeight, _alertView.frame.size.width, buttonHeight);
        reduceHeight = buttonHeight*2;
    }
    self.selectTableView.frame = CGRectMake(0, 0, _alertView.frame.size.width, alertHeight);
}


#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectcell"];
    if (!cell) {
        cell = [[SelectAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectcell"];
    }
    cell.titleLabel.text = _titles[indexPath.row];
    if (indexPath.row == _titles.count - 1) {
        cell.botview.hidden = YES;
    }else{
        cell.botview.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectIndex) {
        self.selectIndex(indexPath.row);
    }
    if (self.selectValue) {
        self.selectValue(_titles[indexPath.row]);
    }
    
    [self closeAction];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (!CGRectContainsPoint([self.alertView frame], pt) && !_showCloseButton) {
        [self closeAction];
    }
}

- (void)closeAction {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    //    NSLog(@"SelectAlert被销毁了");
}


@end
