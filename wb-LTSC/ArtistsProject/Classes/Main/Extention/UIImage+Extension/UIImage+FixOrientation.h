//
//  UIImage+FixOrientation.h
//  manager
//
//  Created by yangliu on 15/11/16.
//  Copyright © 2015年 yangliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FixOrientation)

- (UIImage *)fixOrientation;

/*! 已进行转正处理 */
- (UIImage *)croppedImage;

@end
