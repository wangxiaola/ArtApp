//
//  UIView+DefaultImage.m
//  YunLianMeiGou
//
//  Created by 牛中磊 on 2017/10/13.
//  Copyright © 2017年 namei. All rights reserved.
//

#import "UIView+DefaultImage.h"

#define kSetDefaultTagNothingImg 111
#define kSetDefaultTagNothingLabel 222


@implementation UIView (DefaultImage)


-(void)setNothingWithDefaultImage:(NSString *)imageStr titleStr:(NSString *)titleStr{

    self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    
    UIImageView *img = [self viewWithTag:kSetDefaultTagNothingImg];
    if (img) {
        return;
    }
    [self clearsetDefaultIamge];
    
    img = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-88)/2, (self.height-100-42-49-64)/2, 88, 100)];
    img.image = [UIImage imageNamed:imageStr];
    img.tag = kSetDefaultTagNothingImg;
    [self addSubview:img];
    
    
    UILabel *titleLabel = [self viewWithTag:kSetDefaultTagNothingLabel];
    if (titleLabel) {
        return;
    }
    [self clearsetDefaultIamge];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(img.frame) +22, self.width-20, 20)];
    titleLabel.text = titleStr;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0  blue:153/255.0  alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.tag = kSetDefaultTagNothingLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
}
-(void)clearsetDefaultIamge{
    UIView *nothingView = [self viewWithTag:kSetDefaultTagNothingImg];
    [nothingView removeFromSuperview];
    nothingView = [self viewWithTag:kSetDefaultTagNothingLabel];
    [nothingView removeFromSuperview];
}
@end
