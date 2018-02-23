//
//  HDTitleBtn.m
//  evtmaster
//
//  Created by sks on 16/8/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "HDTitleBtn.h"
#import "GeneralConfigure.h"

@implementation HDTitleBtn
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSString *imageName = @"arrow_up_black";
        if (isNightMode) {
            
            imageName = @"arrow_up_red";
        }
        [self setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:RGBCOLOR(98, 98, 98) forState:UIControlStateNormal];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1 计算文字
    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    self.titleLabel.x = (self.width - (textSize.width + 18)) / 2.f;
    
    // 2 计算imageView 的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 6;
}

- (void)setTitle:(NSString *)title {
    
    [super setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    // 按钮根据内容的大小自适应
//    [self sizeToFit];
}

@end
