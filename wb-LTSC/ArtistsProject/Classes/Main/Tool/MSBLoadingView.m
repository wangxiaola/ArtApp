//
//  MSBLoadingView.m
//  meishubao
//
//  Created by T on 16/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBLoadingView.h"
#import "CKShimmerLabel.h"
#import "GeneralConfigure.h"

static const CGFloat kMSBLoadingViewLabH = 35.f;
static const CGFloat kMSBLoadingViewLabW = 100.f;

@interface MSBLoadingView ()
@property(nonatomic,strong) CKShimmerLabel *label;
@property(nonatomic,strong) UIView *contentView;

@end

@implementation MSBLoadingView
- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self commitInit];
    }
    return self;
}

-(CKShimmerLabel *)label{
    if (!_label) {
        _label = [[CKShimmerLabel alloc] init];
        [_label setText:@"美术报"];
//        [_label setTextColor:[UIColor grayColor]];
//        _label.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        [_label setFont:[UIFont systemFontOfSize:25.f]];
    }
    return _label;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
//        [_contentView setBackgroundColor:RGBCOLOR(238, 238, 238)];
        _contentView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
    }
    return _contentView;
}

- (void)show:(UIView *)view{
    self.contentView.frame = view.bounds;
    [self.contentView addSubview:self.label];
    CGFloat y = (view.height - kMSBLoadingViewLabH) * 0.5;
    CGFloat x = (view.width - kMSBLoadingViewLabW) * 0.5;
    self.label.frame = CGRectMake(x, y, kMSBLoadingViewLabW, kMSBLoadingViewLabH);
    
    [view addSubview:self.contentView];
    [UIView animateWithDuration:0.25 animations:^{
        [self.label startShimmer];
    }];
}


- (void)hidden{
    [UIView animateWithDuration:0.25 animations:^{
        [self.label removeFromSuperview];
        [self.contentView removeFromSuperview];
        self.label = nil;
        self.contentView = nil;
    }];
}
@end
