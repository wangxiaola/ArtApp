//
//  YTXCustomTypeInputViewController.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/19.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "HViewController.h"

@interface YTXCustomTypeInputViewController : HViewController

@property (nonatomic, copy) NSString *editString;

@property (nonatomic, assign) BOOL isFullScreenInput;

@property (nonatomic, copy) void(^resultBlock)(NSString *result);

@end

