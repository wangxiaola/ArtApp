//
//  CustomTagView.m
//  meishubao
//
//  Created by LWR on 2017/2/16.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "CustomTagView.h"
#import "GeneralConfigure.h"
#import "YZTagList.h"

@interface CustomTagView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) YZTagList *tagList;

@end

@implementation CustomTagView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        self.titleLab.frame = CGRectMake(12, 0, width, 16);
        [self addSubview:self.titleLab];
        
        CAShapeLayer *line = [CAShapeLayer new];
        line.frame = CGRectMake(12, 23, width - 24, 0.5);
        line.backgroundColor = RGBALCOLOR(98, 98, 98, 0.5).CGColor;
        [self.layer addSublayer:line];
        
        [self addSubview:self.tagList];
        self.tagList.frame = CGRectMake(0, 18, width, height - 20);
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
    
}

- (void)setTagArr:(NSArray *)tagArr {

    _tagArr = tagArr;
    [self.tagList addTags:tagArr];
}

- (void)clearTags {

    for (NSString *title in _tagArr) {
    
        [_tagList deleteTag:title];
    }
}

#pragma mark - getter
- (UILabel *)titleLab {
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14.0];
        _titleLab.textColor = [UIColor colorWithHex:0xB51B20];;
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    
    return _titleLab;
}

- (YZTagList *)tagList {

    if (!_tagList) {
        
        _tagList = [[YZTagList alloc] init];
        _tagList.backgroundColor = [UIColor clearColor];
        
        CGFloat h = 5.0;
        
        if (SCREEN_HEIGHT <= 568) {
            
            h = 2;
        }
        
        _tagList.tagListH = h;
        _tagList.tagFont = [UIFont systemFontOfSize:14.0];
        _tagList.tagButtonMargin = h;
        _tagList.changeBtnH = NO;
        
        __weak __block typeof(self) weakSelf = self;
        _tagList.clickTagBlock = ^(NSString *tag, NSInteger index) {
            
            NSString *title = tag;
            if (weakSelf.delegate) {
                
                UIButton *btn =  weakSelf.tagList.tagButtons[index];
                if (btn.selected) {
                    
                    tag = @"取消";
                }
                
                [weakSelf.delegate tagListViewClick:title andType:weakSelf.type andTag:tag];
            }
        };
    }
    
    return _tagList;
}

@end
