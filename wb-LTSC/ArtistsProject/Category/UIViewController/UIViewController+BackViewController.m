//
//  UIViewController+BackViewController.m
//  YunLianMeiGou
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 namei. All rights reserved.
//

#import "UIViewController+BackViewController.h"

@implementation UIViewController (BackViewController)

-(UIViewController *)findViewControllerByViewControllerNamed:(NSString *)viewControllerNamed
                                    navigationViewController:(UINavigationController *)navigationController{
    
    UIViewController *viewController = nil;
    
    for (UIViewController *subViewController in navigationController.viewControllers) {
        
        if ([subViewController  isKindOfClass:NSClassFromString(viewControllerNamed)]) {
            viewController = subViewController;
            break;
        }else if ([subViewController isKindOfClass:[UITabBarController class]]){
            UITabBarController *tabBar = (UITabBarController *)subViewController;
            viewController =  [self findViewControllerByViewControllerNamed:viewControllerNamed
                                                   navigationViewController:tabBar.selectedViewController];
            break;
        }
        
    }
    return viewController;
}


@end
