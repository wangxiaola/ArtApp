//
//  WJTextFieldWithTitle.h
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJTextFieldWithTitle : UIView
//顶部横线的起始位置
@property (nonatomic, readwrite) CGFloat headLineWidth;
//头部图像名称
@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) UIColor *titleColor;

@property (assign, nonatomic) BOOL isMutable;

@property (assign, nonatomic) BOOL isMutableChage;

@property (assign, nonatomic) BOOL isMutableChageShow;

@property (assign, nonatomic) CGFloat HeightMutableChageShow;

@property (strong, nonatomic) NSString *submit;

@property (strong, nonatomic) UIFont *submitFont;

@property (strong, nonatomic) UIColor *submitColor;

@property (assign, nonatomic) NSTextAlignment submitAligent;

@property (copy, nonatomic) void (^didTapBlock)();

//箭头是否向下
@property (readwrite, nonatomic) BOOL isBottom;

//箭头是否隐藏
@property (readwrite, nonatomic) BOOL isHideArrow;

@property (strong, nonatomic) NSString *strTag;


@end
