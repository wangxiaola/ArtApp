//
//  UIImage+Extension.h
//  MimiLife_User
//
//  Created by HeLiulin on 15/12/17.
//  Copyright © 2015年 上海翔汇网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *) imageCompressForWidth:(CGFloat)defineWidth;
- (UIImage *)fixOrientation;
@end
