//
//  UIImage+Common.h
//  Following
//
//  Created by maro on 15/1/9.
//  Copyright (c) 2015年 yangliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Common)

- (UIImage *)scaledToSize: (CGSize)targetSize;
- (UIImage *)scaledToSize: (CGSize)targetSize
              highQuality: (BOOL)highQuality;

+ (UIImage *)imageWithColor: (UIColor *)aColor;
+ (UIImage *)imageWithColor: (UIColor *)aColor
                  withFrame: (CGRect)aFrame;
+ (UIImage *)fullResolutionImageFromALAsset: (ALAsset *)asset;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
@end
