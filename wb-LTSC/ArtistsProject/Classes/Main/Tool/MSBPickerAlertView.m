//
//  MSBPickerAlertView.m
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBPickerAlertView.h"
#import "NSString+ToString.h"
#import "GeneralConfigure.h"

static CGFloat const MAIN_WIDTH = 270.f;
@interface MSBPickerAlertView ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    BOOL _isShow;
    UITapGestureRecognizer *_tapGesture;
    MSBPickerAlertViewBlock _configBlock;
    MSBPickerAlertViewBlock _cancelBlock;
    NSArray *_datas;
    NSInteger _selectedIndex;
    NSInteger _index;
    BOOL _isRoll;
}
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property(nonatomic,strong) UIPickerView *pickerView;
@end

@implementation MSBPickerAlertView

- (instancetype)init {
    if (self = [super init]) {
        _isShow = NO;
    }
    return self;
}

- (void)dealloc {
    
    if (_confirmBtn) {
        
        [_confirmBtn removeTarget:self action:@selector(tapConfig) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_cancelBtn) {
        
        [_cancelBtn removeTarget:self action:@selector(tapCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_tapGesture && _backgroundView) {
        
        [_backgroundView removeGestureRecognizer:_tapGesture];
    }
    
    [self removeFromSuperview];
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        [_backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_backgroundView setBackgroundColor:RGBALCOLOR(0, 0, 0, .4f)];
        [self addSubview:_backgroundView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
        
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        [_tapGesture setNumberOfTapsRequired:1];
        [_tapGesture setNumberOfTouchesRequired:1];
        [_tapGesture addTarget:self action:@selector(tapCancel)];
    }
    
    return _backgroundView;
}

- (UIView *)mainView {
    
    if (_mainView == nil) {
        
        _mainView = [[UIView alloc] init];
        [_mainView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_mainView setClipsToBounds:YES];
        [_mainView.layer setCornerRadius:5.f];
        _mainView.backgroundColor = RGBCOLOR(242, 242, 242);
        [self insertSubview:_mainView aboveSubview:self.backgroundView];
        
//        _mainHeight = [NSLayoutConstraint constraintWithItem:_mainView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:326];
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:_mainView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:MAIN_WIDTH],
                               [NSLayoutConstraint constraintWithItem:_mainView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:_mainView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:_mainView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:326]
                               ]];
    }
    
    return _mainView;
}

- (UIButton *)confirmBtn {
    
    if (_confirmBtn == nil) {
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.f]];
        [_confirmBtn setTitleColor:RGBCOLOR(55, 117, 216) forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [self.mainView addSubview:_confirmBtn];
        
        UIButton *cancel = self.cancelBtn;
        
        [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_confirmBtn]-0-[cancel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmBtn, cancel)]];
        [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_confirmBtn(47)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmBtn)]];
        
        UIView *line = [[UIView alloc] init];
        [line setTranslatesAutoresizingMaskIntoConstraints:NO];
        [line setBackgroundColor:RGBCOLOR(200, 200, 200)];
        [self.mainView addSubview:line];
        [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[line]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
        [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(0.5)]-47-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
    }
    
    return _confirmBtn;
}

- (UIButton *)cancelBtn {
    
    if (_cancelBtn == nil) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
        [_cancelBtn setTitleColor:RGBCOLOR(55, 117, 216) forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.mainView addSubview:_cancelBtn];
        
//        _cancelWidth = [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0];
        
        [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cancelBtn(47)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelBtn)]];
        [self.mainView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0],
                                        [NSLayoutConstraint constraintWithItem:_cancelBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]
                                        ]];
        
        UIView *line = [[UIView alloc] init];
        [line setTranslatesAutoresizingMaskIntoConstraints:NO];
        [line setBackgroundColor:RGBCOLOR(200, 200, 200)];
        [_cancelBtn addSubview:line];
        [_cancelBtn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[line]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
        [_cancelBtn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[line(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line, _cancelBtn)]];
    }
    
    return _cancelBtn;
}

- (UILabel *)titleLab {
    
    if (_titleLab == nil) {
        
        _titleLab = [[UILabel alloc] init];
        [_titleLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_titleLab setFont:[UIFont boldSystemFontOfSize:17.f]];
        [_titleLab setTextColor:RGBCOLOR(41, 41, 41)];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [self.mainView addSubview:_titleLab];
        
//        _titleTop = [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeTop multiplier:1 constant:25];
        
        [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLab]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLab)]];
        [self.mainView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeTop multiplier:1 constant:25],
                                        [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:17]]];
    }
    
    return _titleLab;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc ] init];
         [_pickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [self.mainView insertSubview:_pickerView belowSubview:self.confirmBtn];
        UILabel *title = self.titleLab;
        [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pickerView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pickerView)]];
        [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-13.5-[_pickerView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pickerView, title)]];
    }
    return _pickerView;
}

- (void)close {
    
    if (!_isShow) {
        
        return;
    }
    _isRoll = NO;
    [self.confirmBtn removeTarget:self action:@selector(tapConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn removeTarget:self action:@selector(tapCancel) forControlEvents:UIControlEventTouchUpInside];
    
    if (_tapGesture && _backgroundView) {
        
        [self.backgroundView removeGestureRecognizer:_tapGesture];
    }
    _isShow = NO;
    [self removeFromSuperview];
}

- (BOOL)isShow {
    
    return _isShow;
}

- (void)tapConfig {
    
    if (_configBlock) {
        if (_isRoll) {
            _configBlock(_selectedIndex);
        }else{
            _configBlock(_index);
        }
    }
    
    [self close];
}

- (void)tapCancel {
    
    if (_cancelBlock) {
        
        _cancelBlock(nil);
    }
    
    [self close];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _datas.count;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return _datas[row];
//}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view  {
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:20]];
    [label setTextColor:[UIColor colorWithHex:0x141414]];
    [label setText:_datas[row]];
    [self changeSpearatorLineColor];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _isRoll = YES;
    _selectedIndex = row;
}

- (void)changeSpearatorLineColor{
    for(UIView *speartorView in self.pickerView.subviews){
        if (speartorView.frame.size.height < 1){
            speartorView.backgroundColor = [UIColor lightGrayColor];//隐藏分割线
        }
    }
}


- (void)showWithTitle:(NSString *)title
              content:(NSArray *)content
              index:(NSInteger)index
              ok:(MSBPickerAlertViewBlock)ok
             cancel:(MSBPickerAlertViewBlock)cancel{
    if (_isShow) {
        
        return;
    }
    
    _cancelBlock = cancel;
    _configBlock = ok;
    
    _datas = content;
    
    self.titleLab.text = [NSString notNilString:title];
    
    if (_tapGesture) {
        
        [self.backgroundView addGestureRecognizer:_tapGesture];
    }
    
    
    self.mainView.transform = CGAffineTransformMakeScale(0, 0);
    self.frame = [UIScreen mainScreen].bounds;
    [self.confirmBtn addTarget:self action:@selector(tapConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(tapCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:index inComponent:0 animated:YES];
    _index = index;
    
    NSEnumerator *fontToBackWindows = [[UIApplication sharedApplication] windows].reverseObjectEnumerator;
    
    for (UIWindow *window in fontToBackWindows) {
        
        if (window.windowLevel == UIWindowLevelNormal) {
            
            _isShow = YES;
            
            [window addSubview:self];
            
            [UIView animateWithDuration:.2f animations:^{
                
                self.mainView.transform = CGAffineTransformMakeScale(1, 1);
            }];
            
            break;
        }
    }

}
@end