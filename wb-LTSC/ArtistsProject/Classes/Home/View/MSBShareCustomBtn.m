//
//  MSBShareCustomBtn.m
//  meishubao
//
//  Created by T on 16/11/17.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBShareCustomBtn.h"

@implementation MSBShareCustomBtn
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rect = CGRectMake(0, (contentRect.size.height - ICONHEIGHT - TITLEHEIGHT) / 2, contentRect.size.width, ICONHEIGHT);
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectMake(0, (contentRect.size.height - ICONHEIGHT - TITLEHEIGHT) / 2 + ICONHEIGHT, contentRect.size.width, TITLEHEIGHT);
    return rect;
}

@end
