//
//  UIViewController+WtPrestent.m
//  Railplus
//
//  Created by dzmmac on 15/7/17.
//  Copyright (c) 2015年 hopozone. All rights reserved.
//

#import "UIViewController+WtPrestent.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

@implementation UIViewController (WtPrestent)

static NSString const *WtPrestentKey = @"WtPrestentKey";
static NSString const *WtPrestentCoverKey = @"WtPrestentCoverKey";



-(void)presentWtViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    CGFloat timeDuration = animated ? 0.25 : 0;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    objc_setAssociatedObject(app,&WtPrestentKey, viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIImageView *coverImg = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0 , Screen_Width, Screen_Height)];
    coverImg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    coverImg.alpha = 0;
    coverImg.userInteractionEnabled = YES;
    
    [app.window addSubview:coverImg];
    objc_setAssociatedObject(app,&WtPrestentCoverKey, coverImg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    viewController.view.userInteractionEnabled = YES;
    viewController.view.frame = CGRectMake(0, Screen_Height , Screen_Width, Screen_Height);
    [app.window addSubview:viewController.view];
    __weak UIViewController *weakSelf = viewController;
    
   dispatch_async(dispatch_get_main_queue(), ^{
       [UIView animateWithDuration:timeDuration animations:^{
           weakSelf.view.frame = CGRectMake(0, 0 , Screen_Width, weakSelf.view.frame.size.height);
           coverImg.alpha = 1;
       }];
   });
}

-(void)dismissWtViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion {
     AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGFloat timeDuration = animated ? 0.25 : 0;
    UIViewController *wtPresentVc = objc_getAssociatedObject(app, &WtPrestentKey);
    __weak UIViewController *weakSelf = wtPresentVc;
    
    UIImageView *cover = objc_getAssociatedObject(app, &WtPrestentCoverKey);
    
    
    [UIView animateWithDuration:timeDuration animations:^{
        weakSelf.view.frame = CGRectMake(0, Screen_Height, Screen_Width, weakSelf.view.frame.size.height);
        cover.alpha = 0;
      
    } completion:^(BOOL finished) {
        
        completion(finished);
        
        [weakSelf.view removeFromSuperview];
        [cover removeFromSuperview];
         objc_setAssociatedObject(app,&WtPrestentKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }];
   
}
@end
