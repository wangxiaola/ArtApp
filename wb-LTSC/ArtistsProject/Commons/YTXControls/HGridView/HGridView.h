//
//  HGridView.h
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/2.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HView.h"
#import "HGridItemView.h"

@interface HGridView : HView
typedef void (^didSelectedCellBlock)(HKeyValuePair* item);
- (void)setItems:(NSArray*)items
     andColumnNum:(NSInteger)column
    andCellHeigth:(CGFloat)cellHeight
andDidSelectedCellBlock:(didSelectedCellBlock)block;
@property(nonatomic,readwrite) BOOL allowMultiSelect;
@property(nonatomic,readonly) NSArray<HKeyValuePair*> *selectedItems;
@property(nonatomic,strong) NSMutableArray<NSString*> *selectedValues;
@property(nonatomic,strong) UIColor *titleColor;
@property(nonatomic,readwrite) BOOL hideItemsBorder;
@property(nonatomic,readwrite) BOOL allowUnSelect;
@property(nonatomic,readwrite) NSTextAlignment itemTitleAlignment;
@end
