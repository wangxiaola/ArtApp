//
//  MSBAdView.m
//  meishubao
//
//  Created by T on 16/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBAdView.h"
#import "GeneralConfigure.h"
typedef void(^MSBAdViewBlock)();
@interface MSBAdView ()
@property (strong, nonatomic) UIImageView *adImg;
@property (strong, nonatomic) UIButton *skipBtn;
@property (strong, nonatomic) UILabel *skipLab;
@property (strong, nonatomic) UIButton *nextBtn;
@end

@implementation MSBAdView{
    MSBAdViewBlock _completeBlock;
    NSTimer *_timer;
    NSInteger _count;
    UITapGestureRecognizer *_tapGesture;
    UISwipeGestureRecognizer *_swipeGesture;
}

- (void)dealloc {
    
    _completeBlock = nil;
    
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_skipBtn) {
        
        [_skipBtn removeTarget:self action:@selector(tapSkip) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.nextBtn) {
        [_nextBtn removeTarget:self action:@selector(tapSkip) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UIButton *)skipBtn {
    
    if (_skipBtn == nil) {
        
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_skipBtn];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_skipBtn(83)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_skipBtn)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_skipBtn(69)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_skipBtn)]];
    }
    
    return _skipBtn;
}

- (UILabel *)skipLab {
    
    if (_skipLab == nil) {
        
        _skipLab = [[UILabel alloc] init];
        [_skipLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_skipLab setTextAlignment:NSTextAlignmentCenter];
        [_skipLab setFont:[UIFont systemFontOfSize:11.f]];
        [_skipLab setTextColor:RGBCOLOR(242.f, 242.f, 242.f)];
        [_skipLab setBackgroundColor:RGBALCOLOR(0, 0, 0, .3f)];
        [_skipLab setClipsToBounds:YES];
        [_skipLab.layer setCornerRadius:3.f];
        [self insertSubview:_skipLab belowSubview:self.skipBtn];
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:_skipLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.skipBtn attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f],
                               [NSLayoutConstraint constraintWithItem:_skipLab attribute:NSLayoutAttributeTrailing   relatedBy:NSLayoutRelationEqual toItem:self.skipBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15.f],
                               [NSLayoutConstraint constraintWithItem:_skipLab attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.skipBtn attribute:NSLayoutAttributeBottom multiplier:1 constant:-15.f],
                               [NSLayoutConstraint constraintWithItem:_skipLab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:24.f]]];
    }
    
    return _skipLab;
}

- (UIImageView *)adImg {
    
    if (_adImg == nil) {
        
        _adImg = [[UIImageView alloc] init];
        [_adImg setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_adImg setContentMode:UIViewContentModeScaleAspectFill];
        [self insertSubview:_adImg belowSubview:self.skipLab];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_adImg]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_adImg)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_adImg]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_adImg)]];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAd)];
        [_tapGesture setNumberOfTapsRequired:1];
        [_tapGesture setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:_tapGesture];
        
        _swipeGesture =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tapSkip)];
        _swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:_swipeGesture];
    }
    
    return _adImg;
}

- (UIButton *)nextBtn{
    if (_nextBtn==nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_nextBtn setTitle:@"进入美术报" forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:RGBCOLOR(40, 40, 40)];
        [self addSubview:_nextBtn];
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:_nextBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:(SCREEN_WIDTH - 80)*0.5],
                               [NSLayoutConstraint constraintWithItem:_nextBtn attribute:NSLayoutAttributeWidth   relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:80.f],
                               [NSLayoutConstraint constraintWithItem:_nextBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-50.f],
                               [NSLayoutConstraint constraintWithItem:_nextBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30.f]]];
    }
    return _nextBtn;
}

- (void)tapAd{
    NDLog(@"tapAd");
}

- (void)tapSkip {

    [UIView animateWithDuration:2.5 animations:^{
        self.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [self close];
    }];
}

- (void)close {
    if (_completeBlock) {
        
        _completeBlock();
    }
    
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
    
    [self.skipBtn removeTarget:self action:@selector(tapSkip) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn removeTarget:self action:@selector(tapSkip) forControlEvents:UIControlEventTouchUpInside];
}

- (void)timerUpdate {
    
    _count --;
    
    if (_count == 0) {
        
        [self close];
        return;
    }
    
    self.skipLab.text = [NSString stringWithFormat:@"跳过 %i", (int)_count];
}


- (void)start:(NSData *)binaryData duration:(NSInteger)duration complete:(void (^)())complete {
    _count = (duration <= 0 || duration == NSNotFound || duration > 10 ? 3 : duration) + 1;
    _completeBlock = complete;
    [self.skipBtn addTarget:self action:@selector(tapSkip) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(tapSkip) forControlEvents:UIControlEventTouchUpInside];
    self.skipLab.text = [NSString stringWithFormat:@"跳过 %i", (int)_count - 1];
    [self.adImg setImage:[UIImage imageWithData:binaryData]];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
}

@end
