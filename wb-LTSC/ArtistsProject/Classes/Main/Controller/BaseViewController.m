//
//  BaseViewController.m
//  meishubao
//
//  Created by LWR on 2016/11/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "BaseViewController.h"
//#import "MBProgressHUD.h"
#import "UIView+MBProgressHUD.h"
#import "GeneralConfigure.h"

@interface BaseViewController (){
    //MBProgressHUD *_hud;
    //NSInteger _showTimes;
    BOOL _isLoading;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    // commitInitNightMode
    [self commitInitNightMode];
    
    _isLoading = YES;
    
}

- (void)setLogoTitle{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meishubao_logo"]];
    self.navigationItem.titleView = imageView;
}

- (void)commitInitNightMode{
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xB51B20, 0x6f141a);
}

- (void)hudLoding{

    [self.view showLoadMessageAtCenter:@"" yOffset:-20];
}

- (void)hudTip:(NSString *)tip{

    [self.view showTitle:tip];
}

- (void)showSuccess:(NSString *)tip {

    [self.view showSuccess:tip];
}

- (void)showError:(NSString *)tip {

    [self.view showError:tip];
}

- (void)hudLoading:(NSString *)tip {

    [self.view showLoadMessageAtCenter:tip yOffset:-20];
}

- (void)hiddenHudLoding{

    [self.view hide];
}

- (void)webLoadView:(UIView *)view{
    if (_isLoading == NO) {
        return;
    }else{
        [[MSBWebLoading defaultLoading] startLoading:view];
    }
}

- (void)endLoading{
     [[MSBWebLoading defaultLoading] endLoading];
}

-(UIColor *)defaultBgColor
{
    if (!_defaultBgColor) {
        _defaultBgColor = RGBCOLOR(238, 238, 238);
    }
    return _defaultBgColor;
}

@end
