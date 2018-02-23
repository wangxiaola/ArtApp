//
//  AtlasImageView.m
//  meishubao
//
//  Created by 胡亚刚 on 2017/8/14.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "AtlasImageView.h"
#import "GeneralConfigure.h"

@interface AtlasImageView ()
@property (nonatomic,strong) UIActivityIndicatorView * loadView;
@property (nonatomic,strong) UIButton * refreshBtn;
@property (nonatomic,strong) NSURL * url;
@property (nonatomic,assign,getter=isFinish) BOOL finish;
@end

@implementation AtlasImageView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.finish = NO;
    }
    return self;
}

- (UIActivityIndicatorView *)loadView {

    if (!_loadView) {
        _loadView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _loadView.center = self.center;
        _loadView.tintColor = [UIColor colorWithWhite:0.7 alpha:0.9];
        [self addSubview:_loadView];
    }
    return _loadView;
}

- (UIButton *)refreshBtn {

    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.frame = CGRectMake(0, 0, 120, 44);
        [_refreshBtn setTitle:@"加载失败，点击刷新" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _refreshBtn.center = self.center;
        [_refreshBtn addTarget:self action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_refreshBtn];
    }
    return _refreshBtn;
}

- (void)setImageWithUrl:(NSURL *)url {
    if (!url) {
        url = [NSURL URLWithString:@""];
    }
    _url = url;
    if (!self.image) {
        if (self.isFinish) {
            return;
        }
        [self.loadView startAnimating];
        if (self.refreshBtn.hidden == NO) {
            self.refreshBtn.hidden = YES;
        }
        __weak typeof(self) weakSelf  = self;
        [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.finish = YES;
                [weakSelf.loadView stopAnimating];
                if (!image) {
                    self.refreshBtn.hidden = NO;
                }else {
                    self.refreshBtn.hidden = YES;
                }
            });
        }];
    }
}

- (void)reloadImage {
    self.finish = NO;
    self.refreshBtn.hidden = YES;
    [self setImageWithUrl:_url];
}

@end
