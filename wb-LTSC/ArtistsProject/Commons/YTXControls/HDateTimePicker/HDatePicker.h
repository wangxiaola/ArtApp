//
//  HDatePicker.h
//  logistics
//
//  Created by HeLiulin on 15/12/26.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import "HPopVC.h"

@interface HDatePicker : HPopVC
///选择完成回调
@property (nonatomic, copy) void(^finishSelectedBlock)(NSArray<HKeyValuePair*> *selectedItems);
///取消回调
@property (nonatomic, copy) void(^didClickedCancelButtonBlock)();
///清空回调
@property (nonatomic, copy) void(^didClickedClearButtonBlock)();

@end
