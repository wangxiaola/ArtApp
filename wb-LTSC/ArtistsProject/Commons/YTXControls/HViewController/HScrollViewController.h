//
//  HScrollViewController.h
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/17.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import <UIKit/UIKit.h>

@interface HScrollViewController : HViewController<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property(nonatomic,strong) UIView *viewContent;
@property(nonatomic,strong) UIScrollView *scrollView;
- (void) createView:(UIView*)contentView;
- (void)addCreateView:(UIScrollView*)contentView;
@end
