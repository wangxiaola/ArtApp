//
//  UIViewController+BackViewController.h
//  YunLianMeiGou
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 namei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BackViewController)


-(UIViewController *)findViewControllerByViewControllerNamed:(NSString *)viewControllerNamed navigationViewController:(UINavigationController *)navigationController;

@end
