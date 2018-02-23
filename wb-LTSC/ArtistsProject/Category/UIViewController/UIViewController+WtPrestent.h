//
//  UIViewController+WtPrestent.h
//  Railplus
//
//  Created by dzmmac on 15/7/17.
//  Copyright (c) 2015年 hopozone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WtPrestent)

-(void)presentWtViewController:(UIViewController *_Nullable)viewController animated:(BOOL)animated;

-(void)dismissWtViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion;

@end
