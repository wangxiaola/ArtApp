//
//  UIImage+Common.m
//  Following
//
//  Created by maro on 15/1/9.
//  Copyright (c) 2015年 yangliu. All rights reserved.
//

#import "UIImage+Common.h"

@implementation UIImage (Common)

#pragma mark 对图片尺寸进行压缩
- (UIImage *)scaledToSize:(CGSize)targetSize {

    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat scaleFactor = 0.0;
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
    
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        
        if (widthFactor < heightFactor) {
        
            // scale to fit height
            scaleFactor = heightFactor;
        } else {
        
            // scale to fit width
            scaleFactor = widthFactor;
        }
    }
    
    scaleFactor = MIN(scaleFactor, 1.0);
    
    CGFloat targetWidth = scaleFactor * imageSize.width;
    CGFloat targetHeight = scaleFactor * imageSize.height;
    
    targetSize = CGSizeMake(floorf(targetWidth), floorf(targetHeight));
    // will crop
    UIGraphicsBeginImageContext(targetSize);
    [sourceImage drawInRect: CGRectMake(0, 0, ceilf(targetWidth), ceilf(targetHeight))];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        
//        DebugLog(@"could not scale image");
        newImage = sourceImage;
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality {

    if (highQuality) {
    
        targetSize = CGSizeMake(2 * targetSize.width, 2 * targetSize.height);
    }
    
    return [self scaledToSize:targetSize];
}

+ (UIImage *)imageWithColor:(UIColor *)aColor {

    return [self imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame {

    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset {

    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
    
    return img;
}
- (UIImage *) imageWithTintColor:(UIColor *)tintColor{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
@end
