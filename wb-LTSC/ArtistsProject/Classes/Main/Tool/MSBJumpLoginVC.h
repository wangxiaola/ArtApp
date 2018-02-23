//
//  MSBJumpLoginVC.h
//  meishubao
//
//  Created by T on 16/12/20.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSBJumpLoginVC : NSObject
+ (BOOL)showLoginAlert:(UIViewController *)vc;
+ (BOOL)jumpLoginVC:(UIViewController *)vc;
@end
