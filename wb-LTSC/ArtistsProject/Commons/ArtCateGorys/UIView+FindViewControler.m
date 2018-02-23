//
//  UIView+FindViewControler.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/7.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "UIView+FindViewControler.h"

@implementation UIView (FindViewControler)
-(UIViewController *)containingViewController{
    UIView * target = self.superview ? self.superview : self;
    return (UIViewController *)[target traverseResponderChainForUIViewController];
}
- (id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    BOOL isViewController = [nextResponder isKindOfClass:[UIViewController class]];
    BOOL isTabBarController = [nextResponder isKindOfClass:[UITabBarController class]];
    if (isViewController && !isTabBarController) {
        return nextResponder;
    } else if(isTabBarController){
        UITabBarController *tabBarController = nextResponder;
        return [tabBarController selectedViewController];
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end
