//
//  UIViewController+NavigationBarBtn.h
//  YunLianMeiGou
//
//  Created by 牛中磊 on 2017/5/18.
//  Copyright © 2017年 namei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBarBtn)


-(void)addRightBtn:(NSString *)string;

-(void)addRightBtnByImageNamed:(NSString *)imageNamed;

-(UIBarButtonItem *)addLeftBtnByImageNamed:(NSString *)imageNamed;

-(void)addLeftBtnByTitle:(NSString *)title;
-(void)addLeftBtnByTitle:(NSString *)title color:(UIColor *)color;


-(void)addRightLoading;

// 其他导航定位
-(UIButton *)addLocationBtn:(NSString *)cityName;


// 其他导航定位
-(void)addIndexNaivgationLeftItem:(NSString *)cityName;

// 首页定位
-(void)addLocationNaivgationLeftItem:(NSString *)cityName;


-(void)addRightBarItemBtn:(NSString *)string;

-(void)addRightBarItemBtn:(NSString *)string titleColor:(UIColor *)titleColor;

@end
