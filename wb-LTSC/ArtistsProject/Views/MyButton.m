//
//  MyButton.m
//  refresh
//
//  Created by  on 15/8/2.
//  Copyright (c) 2015年 中嘉信诺. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

-(instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag title:(NSString *)title img:(NSString *)img font:(CGFloat)Float :(void (^)(id))block
{
    if (self=[super initWithFrame:frame]) {
        if (tag) {
            self.tag = tag;
        }
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
        if (Float) {
            self.titleLabel.font = [UIFont systemFontOfSize:Float];
        }
        if (img) {
            [self setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }
        self.block = block;

        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(void)btnClick:(UIButton*)send
{
    if (self.block) {
        self.block(send);
    }
    
}

@end
