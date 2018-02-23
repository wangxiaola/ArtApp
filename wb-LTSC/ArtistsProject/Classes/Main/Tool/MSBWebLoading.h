//
//  MSBWebLoading.h
//  meishubao
//
//  Created by T on 16/12/15.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSBWebLoading : UIView
+ (instancetype)defaultLoading;
- (void)startLoading:(UIView *)view;
- (void)endLoading;
@end
