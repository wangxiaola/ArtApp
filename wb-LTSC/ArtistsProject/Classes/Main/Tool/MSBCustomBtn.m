//
//  MSBCustomBtn.m
//  meishubao
//
//  Created by 胡亚刚 on 2017/8/15.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "MSBCustomBtn.h"
#import "GeneralConfigure.h"

@implementation MSBCustomBtn

- (instancetype)init {

    if (self = [super init]) {
        [self config];
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType {

    MSBCustomBtn * btn = [super buttonWithType:buttonType];
    [btn config];
    return btn;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    [self config];
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (void)config {

    [self dk_setBackgroundImage:DKImagePickerWithImages(NORMAL_BUTTON_IMAGE,NIGHT_BUTTON_IMAGE,NORMAL_BUTTON_IMAGE) forState:UIControlStateNormal];
    [self setBackgroundImage:HIGHLIGHT_BUTTON_IMAGE forState:UIControlStateHighlighted];
    [self dk_setTitleColorPicker:DKColorPickerWithRGB(0xffffff, 0x989898) forState:UIControlStateNormal];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

@end
