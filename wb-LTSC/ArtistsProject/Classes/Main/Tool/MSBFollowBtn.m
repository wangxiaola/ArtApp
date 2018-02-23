//
//  MSBFollowBtn.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBFollowBtn.h"
#define KSCALE 0.62
@implementation MSBFollowBtn
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageX = 0;
    CGFloat imageY = 1.5;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * KSCALE;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * KSCALE;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height * (1 - KSCALE);
    return CGRectMake(titleX, titleY-1, titleW, titleH);
}

@end
