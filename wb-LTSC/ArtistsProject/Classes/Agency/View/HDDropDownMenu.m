//
//  HDDropDownMenu.m
//  evtmaster
//
//  Created by sks on 16/8/19.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "HDDropDownMenu.h"
#import "GeneralConfigure.h"

@interface HDDropDownMenu ()

@property (nonatomic, strong) UIView * content;

@end

@implementation HDDropDownMenu

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.2f];
        self.content = [UIView new];
        [self addSubview:self.content];
    }
    return self;
}

- (void)showInView:(UIView *)view andFrom:(UIView *)from {
    // 添加到自己窗口上
    [view addSubview:self];
    
    // 设置尺寸
    CGFloat viewY = CGRectGetMaxY(from.frame) + 9;
    self.frame = CGRectMake(0, viewY, view.frame.size.width, view.frame.size.height - viewY);
    self.content.frame = CGRectMake(from.frame.origin.x + 12, 0, self.fromViewW - 24, 133);
    
    if (isNightMode) {
        
        self.content.backgroundColor = RGBALCOLOR(61, 60, 60, 0.9);
    }else {
        
        self.content.backgroundColor = RGBALCOLOR(255, 255, 255, 0.9);
    }
    // 转换坐标系
//    CGRect newRect = [from convertRect:from.bounds toView:window];
    // 重新设置图片的位置
//    self.content.x = newRect.origin.x;
//    self.content.y = CGRectGetMaxY(from.frame);

//    
//    if ([self.delegate respondsToSelector:@selector(dropDownMenuShow:)]) {
//        [self.delegate dropDownMenuShow:self];
//    }
}

- (void)setTitleArr:(NSArray *)titleArr {

    NSInteger count = titleArr.count;
    for (NSInteger i = 0; i < count; i++) {
        
        CGFloat btnY = i * 34.5;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, btnY, self.fromViewW - 48, 34)];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        
        if (isNightMode) {
            
            [btn setTitleColor:RGBCOLOR(98, 98, 98) forState:UIControlStateNormal];
        }else {
        
            [btn setTitleColor:RGBCOLOR(63, 63, 63) forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.content addSubview:btn];
        
        if (i != count - 1) {
            
            CAShapeLayer *line = [CAShapeLayer new];
            line.frame = CGRectMake(12, (i + 1) * 34 + i * 0.5, self.fromViewW - 48, 0.5);
            line.backgroundColor = RGBALCOLOR(98, 98, 98, 0.5).CGColor;
            [self.content.layer addSublayer:line];
        }
    }
}

- (void)choiceClick:(UIButton *)btn {

    if ([self.delegate respondsToSelector:@selector(dropDownMenuBtnClick:andType:)]) {
        
        [self.delegate dropDownMenuBtnClick:btn.tag andType:self.type];
    }
}

// 销毁
- (void)dismiss {
    
    [self removeFromSuperview];
    // 销毁
    if ([self.delegate respondsToSelector:@selector(dropDownMenuDismiss:)]) {
        
        [self.delegate dropDownMenuDismiss:self.type];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismiss];
}

@end
