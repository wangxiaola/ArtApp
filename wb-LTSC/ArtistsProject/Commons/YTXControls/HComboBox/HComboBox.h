//
//  HComboBox.h
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/18.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HView.h"
#import "HKeyValuePair.h"

@class HComboBox;
@interface HComboBox : HView
typedef void(^didTapBlock)(HComboBox *comboBox);
typedef void(^didSelectionChangedBlock)(HComboBox *comboBox);
@property (nonatomic, readwrite) CGFloat titleWidth;
@property (nonatomic, readwrite) NSTextAlignment titleAlignment;
@property (nonatomic, readwrite) NSTextAlignment contentAlignment;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, strong) UIFont* titleFont;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, strong) UIColor* contentColor;
@property (nonatomic, strong) UIFont* contentFont;
@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, strong) NSMutableArray *selectedValues;
@property (nonatomic, strong) NSMutableArray *selectedDisplayTexts;
@property (nonatomic, strong) NSMutableArray<HKeyValuePair*> *items;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, readwrite) BOOL allowMultiChoice;
@property (nonatomic, readwrite) int numberOfColumns;
@property (nonatomic, readwrite) BOOL isNecessary;
@property (nonatomic, copy) didTapBlock tapBlock;
@property (nonatomic, copy) didSelectionChangedBlock selectionChangedBlock;
@property (nonatomic, readwrite) BOOL isBlank;
@property (nonatomic, readwrite) BOOL hiddenContent;
@end
