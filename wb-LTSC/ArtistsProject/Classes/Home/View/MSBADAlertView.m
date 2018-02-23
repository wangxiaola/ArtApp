//
//  MSBADAlertView.m
//  meishubao
//
//  Created by benbun－mac on 17/1/18.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "MSBADAlertView.h"
#import "UITapImageView.h"
#import "OpenAdModel.h"
#import "MSBWebBaseController.h"
#define cancleBtnWidth 40
#define cancleBtnBottom 100
#define alertViewHeight self.bounds.size.height-cancleBtnBottom-cancleBtnWidth-50-100
@interface MSBADAlertView ()
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIView * alertView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIButton * cancleBtn;
@end

@implementation MSBADAlertView

-(instancetype)init
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self layout];
    }
    return self;
}

-(void)layout
{
    self.contentView.frame = self.bounds;
    self.alertView.frame = CGRectMake(50, 0, self.bounds.size.width-100, alertViewHeight);
    self.scrollView.frame = self.alertView.bounds;
    self.cancleBtn.frame = CGRectMake(self.contentView.frame.size.width/2-cancleBtnWidth/2, self.contentView.frame.size.height-cancleBtnBottom-cancleBtnWidth, cancleBtnWidth, cancleBtnWidth);
    self.alertView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y-40);
    self.alertView.layer.cornerRadius = 5;
    self.alertView.layer.masksToBounds = YES;
}

-(void)show
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.alertView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    //设置弹性动画
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.alpha = 1;
        self.alertView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setImageDatas:(NSArray *)imageDatas
{
    _imageDatas = imageDatas;
    if (imageDatas.count == 0) return;
    CGFloat imageWidth = self.scrollView.frame.size.width;
    CGFloat imageHeight = self.scrollView.frame.size.height;
    for (int i =0; i<imageDatas.count; i++) {
        UITapImageView * imageView = [UITapImageView new];
        
        CGFloat imageViewX = i*imageWidth;
        imageView.frame = CGRectMake(imageViewX, 0, imageWidth, imageHeight);
        [self.scrollView addSubview:imageView];
        
        OpenAdModel * imageModel = imageDatas[i];
        [imageView setImageWithUrl:[NSURL URLWithString:imageModel.ad_image] placeholderImage:nil tapBlock:^(id obj) {
            [self cancle];
            //NSLog(@"链接地址：%@",imageModel.ad_url);
            MSBWebBaseController * adVc = [MSBWebBaseController new];
            adVc.webUrl = imageModel.ad_url;
            adVc.isWeb = YES;
            [[self currentNavController] pushViewController:adVc animated:YES];
        }];
    }
    self.scrollView.contentSize = CGSizeMake(imageWidth*imageDatas.count, 0);
}

-(UINavigationController *)currentNavController
{
    UITabBarController *tabBarControler = (id)UIApplication.sharedApplication.delegate.window.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    return navigationController;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        _contentView.alpha = 0;
        [self addSubview:_contentView];
    }
    return _contentView;
}

-(UIView *)alertView
{
    if (!_alertView) {
        _alertView = [UIView new];
        _alertView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_alertView];
    }
    return _alertView;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [self.alertView addSubview:_scrollView];
    }
    return _scrollView;
}

-(UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setImage:[UIImage imageNamed:@"椭圆-3"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancleBtn];
    }
    return _cancleBtn;
}

-(void)cancle
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.alpha = 0;
        self.alertView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.contentView = nil;
        self.alertView = nil;
        self.scrollView = nil;
        self.cancleBtn = nil;
    }];
}


@end
