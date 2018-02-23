//
//  ArtTextViewController.h
//  ShesheDa
//
//  Created by HELLO WORLD on 2017/3/23.
//  Copyright © 2017年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HViewController.h"
#import "DDHTextView.h"


@interface ArtTextViewController : HViewController<UITextFieldDelegate,UITextViewDelegate>


@property (strong, nonatomic)HTextField *txtFieldName;
@property(strong,nonatomic)NSString *SortName;
@property(strong,nonatomic)NSString *moduleName;
@property(strong,nonatomic)NSString *actionName;

@property(strong,nonatomic)NSString *fieldName;//数据库对应的字段
@property(strong,nonatomic)NSString *fieldValue;//字段所对应的值
@property(readwrite,nonatomic)NSInteger classid;
@property(readwrite,nonatomic)NSInteger checkType;
@property(strong,nonatomic)NSString *saveTips;
@property(strong,nonatomic)NSString *checkTips;
@property(strong,nonatomic)NSString *placeholder;
@property(strong,nonatomic)NSString *navTitle;
@property(readwrite,nonatomic)NSInteger maxLength;
@property(nonatomic) UIKeyboardType keyboardType;
@property(readwrite,nonatomic)BOOL isBack;
@property(readwrite,nonatomic)BOOL isMultiLine;
@property(strong,nonatomic)NSString *tableID;

@property (strong, nonatomic)  DDHTextView *txtView;
@property (strong, nonatomic)  UIButton *btnCommit;
@property (strong,nonatomic)   UILabel *lblTip;

@property (nonatomic, copy) void(^saveBtnCilck)(NSString *backValue);
@property(readwrite,nonatomic)NSInteger txtHeight;
@property(nonatomic,copy)NSString* titleContent;
@end
