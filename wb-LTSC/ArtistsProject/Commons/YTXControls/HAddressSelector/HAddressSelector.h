//
//  HAddressSelector.h
//  logistics
//
//  Created by HeLiulin on 15/10/29.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPopVC.h"

@interface HAddressSelector : HPopVC
typedef void(^didClickedClearButtonBlock)();
typedef void(^didClickedCancelButtonBlock)();
typedef void(^didFinishSelectedBlock)(NSArray *IDs,NSArray *Names);
- (id) initWithFinishSelectedBlock:(didFinishSelectedBlock)finishSelectedBlock
       andClickedCancelButtonBlock:(didClickedCancelButtonBlock)clickedCancelButtonBlock
        andClickedClearButtonBlock:(didClickedClearButtonBlock)clickedClearButtonBlock;
@property(nonatomic,readwrite) int mustSelectLevel;
@property(nonatomic,readwrite) BOOL allowMultiSelectOnLastLevel;
@end
