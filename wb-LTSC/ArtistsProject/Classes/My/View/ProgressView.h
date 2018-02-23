//
//  ProgressView.h
//  meishubao
//
//  Created by LWR on 2017/3/1.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

- (void)settingProgerssWithSub:(NSInteger)sub all:(NSInteger)all;

- (void)settingDownImageShow:(BOOL)show loading:(BOOL)load;

@end
