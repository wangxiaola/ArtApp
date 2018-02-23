//
//  TestClass.h
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/10/20.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
//#import "HControls.h"

struct HViewBorderWidth{
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
};
typedef struct HViewBorderWidth HViewBorderWidth;

CG_INLINE HViewBorderWidth
HViewBorderWidthMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    HViewBorderWidth borderWidth;
    borderWidth.top = top;
    borderWidth.right = right;
    borderWidth.bottom = bottom;
    borderWidth.left = left;
    return borderWidth;
}

@interface HBorderDraw : NSObject
@property (nonatomic, readwrite) UIEdgeInsets topBorderEdgeInsets,
    bottomBorderEdgeInsets,
    leftBorderEdgeInsets,
    rightBorderEdgeInsets;
- (void) drawBorder:(CGRect)rect
 andViewBorderWidth:(HViewBorderWidth)borderWidth
 andViewBorderColor:(UIColor*)borderColor;
@end
