//
//  ArtTabBarController.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,UISSTransitionType) {
    UISSTransitionFromLeft   = 0,
    UISSTransitionFromRight,
    UISSTransitionFromBottom,
    UISSTransitionFromTop,
};

@interface ArtTabBarController : UITabBarController
//跳到那页
-(void)JumpToControlForIndex:(NSInteger)index TransitionType:(UISSTransitionType)type whichControl:(NSString*)whichControl;
@end
