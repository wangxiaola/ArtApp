//
//  HLable.h
//  HUIKitLib
//
//  Created by HeLiulin on 15/11/5.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBorderDraw.h"
//垂直对齐方式
typedef enum {
    HLabelVerticalTextAlignmentTop = UIControlContentVerticalAlignmentTop,
    HLabelVerticalTextAlignmentMiddle = UIControlContentVerticalAlignmentCenter,
    HLabelVerticalTextAlignmentBottom = UIControlContentVerticalAlignmentBottom
} HLabelVerticalTextAlignment;

@interface HLabel : UILabel
@property (nonatomic, assign) HLabelVerticalTextAlignment verticalTextAlignment;
@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;
@property (nonatomic) HViewBorderWidth borderWidth;
@property (nonatomic, strong) UIColor* borderColor;
@property (nonatomic, readwrite) BOOL showBreakLine;
@end
