//
//  UIViewController+IsLogon.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/7.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,UISSAnimationType) {
    UISSAnimationFromLeft   = 0,
    UISSAnimationFromRight ,
    UISSAnimationFromBottom,
    UISSAnimationFromTop
};

@interface UIViewController (IsLogon)


//设置tab选中的selectedViewController
-(void)JumpToControlIndex:(NSInteger)index TransitionType:(UISSAnimationType)type whichContol:(NSString*)whichControl;
- (BOOL)isFinishLogin;

@end
