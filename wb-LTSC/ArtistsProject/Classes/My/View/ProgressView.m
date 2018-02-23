//
//  ProgressView.m
//  meishubao
//
//  Created by LWR on 2017/3/1.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "ProgressView.h"
#import "GeneralConfigure.h"

@interface ProgressView () {

    CGFloat _viewW;
    CGFloat _viewH;
    NSString *_iamgeStr;
    NSString *_cancelStr;
}

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) UIImageView  *clearImage;
@property (nonatomic, strong) UIImageView  *downloadImage;
@property (nonatomic, strong) UILabel      *percentLab;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        _viewW = frame.size.width;
        _viewH = frame.size.height;
        
        self.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xe9e9e9, 0x6c6c6c);
        self.layer.cornerRadius  = 5.0;
        self.layer.masksToBounds = YES;
        
        self.bgLayer                 = [[CAShapeLayer alloc] init];
        self.bgLayer.frame           = CGRectMake(0, 0, 0, _viewH);
        self.bgLayer.backgroundColor = RGBCOLOR(229, 40, 46).CGColor;
        [self.layer addSublayer:self.bgLayer];
        
        [self addSubview:self.percentLab];
        [self addSubview:self.downloadImage];
        [self addSubview:self.clearImage];
    }
    return self;
}

- (void)settingProgerssWithSub:(NSInteger)sub all:(NSInteger)all {

    CGFloat s = sub + 0.0;
    CGFloat a = all + 0.0;
    
    if (all == 0) {
        
        self.percentLab.text = @"";
        self.bgLayer.frame = CGRectMake(0, 0, _viewW, _viewH);
    }else {
    
        self.bgLayer.frame = CGRectMake(0, 0, (s / a) * _viewW, _viewH);
        if (sub == all) {
            
            self.percentLab.text = @"下载完成";
        }else {
        
            self.percentLab.text = [NSString stringWithFormat:@"正在下载: %ld / %ld", sub, all];
        }
    }
}

- (void)settingDownImageShow:(BOOL)show loading:(BOOL)load {
    
    if (show) {
        
        if (load) {
            
            self.downloadImage.image    = [UIImage imageNamed:@"offline_download_dark"];
            self.bgLayer.frame = CGRectMake(0, 0, 0, _viewH);
            self.downloadImage.hidden   = NO;
            self.percentLab.text = @"";
            self.clearImage.hidden      = YES;
            self.userInteractionEnabled = YES;
        }else {
        
            self.downloadImage.image    = [UIImage imageNamed:_iamgeStr];
            self.bgLayer.frame = CGRectMake(0, 0, 0, _viewH);
            self.downloadImage.hidden   = NO;
            self.percentLab.text = @"";
            self.clearImage.hidden      = YES;
            self.userInteractionEnabled = NO;
        }
    }else {
    
        self.downloadImage.image    = [UIImage imageNamed:_iamgeStr];
        self.downloadImage.hidden   = YES;
        self.clearImage.hidden      = NO;
        self.userInteractionEnabled = YES;
    }
}

#pragma mark - 懒加载
- (UILabel *)percentLab {

    if (!_percentLab) {
        
        _percentLab               = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _viewW - 10, _viewH)];
        _percentLab.textAlignment = NSTextAlignmentCenter;
        _percentLab.textColor     = [UIColor whiteColor];
        _percentLab.font          = [UIFont systemFontOfSize:12.0];
    }
    return _percentLab;
}

- (UIImageView *)downloadImage {

    if (!_downloadImage) {
        
        if (isNightMode) {
            
            _iamgeStr = @"offline_download_gray";
        }else {
        
            _iamgeStr = @"offline_download";
        }
        
        UIImage *image        = [UIImage imageNamed:_iamgeStr];
        _downloadImage        = [[UIImageView alloc] initWithFrame:CGRectMake((_viewW - image.size.width) / 2.0, 0, image.size.width, _viewH)];
        _downloadImage.image  = image;
        _downloadImage.contentMode = UIViewContentModeCenter;
    }
    return _downloadImage;
}

- (UIImageView *)clearImage {

    if (!_clearImage) {
        
        if (isNightMode) {
            
            _cancelStr = @"cancel_dark";
        }else {
            
            _cancelStr = @"cancel";
        }
        
        UIImage *image      = [UIImage imageNamed:_cancelStr];
        _clearImage         = [[UIImageView alloc] initWithFrame:CGRectMake(_viewW - image.size.width - 12, 0, image.size.width, _viewH)];
        _clearImage.image   = image;
        _clearImage.contentMode = UIViewContentModeCenter;
        _clearImage.hidden  = YES;
    }
    return _clearImage;
}

@end
