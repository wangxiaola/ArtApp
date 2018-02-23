//
//  HCheckBox.m
//  Hospital
//
//  Created by 安信 on 15/5/22.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//  shanghaixianghuiwangluojishuyouxiangongsi


#import "HCheckBox.h"

#define H_CHECK_ICON_WH         (15.0)
#define H_ICON_TITLE_MARGIN     (5.0)

@implementation HCheckBox

@synthesize checked = _checked;
@synthesize userInfo = _userInfo;

- (id)init{
    if (self= [super init]) {
        self.exclusiveTouch = YES;
        [self setImage:[UIImage imageNamed:@"icon_Default_unSelected"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_Default_selected"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (self.didCheckStatusChangedBlock){
        self.didCheckStatusChangedBlock(self.selected);
    }
}

- (void)checkboxBtnChecked {
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (self.didCheckStatusChangedBlock){
        self.didCheckStatusChangedBlock(self.selected);
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(H_ICON_TITLE_MARGIN,
                      (CGRectGetHeight(contentRect) - H_CHECK_ICON_WH)/2.0,
                      H_CHECK_ICON_WH,
                      H_CHECK_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(H_CHECK_ICON_WH + H_ICON_TITLE_MARGIN*2,
                      CGRectGetHeight(self.frame)/2-CGRectGetHeight(contentRect)/2,
                      CGRectGetWidth(contentRect) - H_CHECK_ICON_WH - H_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}
@end

