//
//  HDateTimePicker.h
//  Car
//
//  Created by HeLiulin on 15/9/13.
//  Copyright (c) 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPopVC.h"
#import "NSDate+Extension.h"

@interface HDateTimePicker : HPopVC
typedef void(^didSelectedBlock) (NSDate *date);
typedef void(^didClearBlock) ();
///选择时间
@property(nonatomic,strong) NSDate *selecteDate;
///选择后回调
@property(nonatomic,copy) didSelectedBlock selectedBlock;
///清除回调
@property(nonatomic,copy) didClearBlock clearBlock;

@end
