//
//  HPopVC.h
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/11.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HViewController.h"

@interface HPopVC : HViewController
@property (nonatomic, strong) UINavigationBar* navBar;
@property (nonatomic, strong) UINavigationItem* navItem;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* viewContent;
@property (nonatomic,strong) NSDictionary *dicBarItemAttr;
@property (nonatomic,strong) UIBarButtonItem *btnSpace;
- (void) dismiss;
@end
