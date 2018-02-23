//
//  HTextView.h
//  HUIKitLib
//
//  Created by HeLiulin on 15/11/5.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBorderDraw.h"

@interface HTextView : UITextView
///边框线大小
@property(nonatomic) HViewBorderWidth borderWidth;
///边框线颜色
@property(nonatomic,strong) UIColor *borderColor;
///占位符文字
@property (nonatomic, strong) NSString *placeholder;
///占位符属性
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;

- (CGRect)placeholderRectForBounds:(CGRect)bounds;

@end
