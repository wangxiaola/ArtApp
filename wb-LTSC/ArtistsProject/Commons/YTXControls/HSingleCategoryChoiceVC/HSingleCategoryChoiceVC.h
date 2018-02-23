//
//  HSingleCategoryChoiceVC
//  logistics
//
//  Created by HeLiulin on 15/11/26.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import "HPopVC.h"
#import "HGridView.h"

@interface HSingleCategoryChoiceVC : HPopVC
typedef void(^didClickedClearButtonBlock)();
typedef void(^didClickedCancelButtonBlock)();

///是否允许多选
@property (nonatomic, readwrite) BOOL allowMultiChoice;
///是否禁用清空按钮
@property (nonatomic, readwrite) BOOL disabledClear;
///标题
@property (nonatomic, strong) NSString* navTitle;
///选项
@property (nonatomic, strong) NSMutableArray<HKeyValuePair*> *items;
///选中选项
@property (nonatomic, strong) NSMutableArray *selectedValues;
///列数
@property (nonatomic, readwrite) int numberOfColumns;
///选择完成回调
@property (nonatomic, copy) void(^finishSelectedBlock)(NSArray *selectedItems);
///取消回调
@property (nonatomic, copy) didClickedCancelButtonBlock clickedCancelButtonBlock;
///清空回调
@property (nonatomic, copy) didClickedClearButtonBlock clickedClearButtonBlock;
@end
