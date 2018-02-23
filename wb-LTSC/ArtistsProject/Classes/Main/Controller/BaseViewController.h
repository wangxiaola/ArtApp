//
//  BaseViewController.h
//  meishubao
//
//  Created by LWR on 2016/11/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, assign) BOOL enablePanGesture;//是否支持自定义拖动pop手势，默认yes,支持手势
@property (nonatomic, strong) UIColor * defaultBgColor;

- (void)setLogoTitle;

- (void)hudLoding;
- (void)hudLoading:(NSString *)tip;
- (void)hiddenHudLoding;

- (void)showSuccess:(NSString *)tip;
- (void)showError:(NSString *)tip;
- (void)hudTip:(NSString *)tip;

- (void)webLoadView:(UIView *)view;
- (void)endLoading;


@end
