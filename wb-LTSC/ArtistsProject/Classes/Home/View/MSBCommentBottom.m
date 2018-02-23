//
//  MSBCommentBottom.m
//  meishubao
//
//  Created by T on 16/12/14.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBCommentBottom.h"
#import "GeneralConfigure.h"

static const CGFloat kCommentTextFiledH = 30.f;

@interface MSBCommentBottom ()
@property (nonatomic, weak) CAShapeLayer  *topLine;

@property (nonatomic, weak) UIView  *commentView;
@property (nonatomic, weak) UIView  *textfieldView;
@property (nonatomic, weak) UILabel  *commentLab;
@end

@implementation MSBCommentBottom
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        
        CAShapeLayer *topLine = [CAShapeLayer layer];
        topLine.dk_backgroundColorPicker = DKColorPickerWithRGB(0xaaaaaa, 0x282828);
        self.topLine = topLine;
        [self.layer addSublayer:topLine];
        
        UIView *commentView = [UIView new];
        [commentView setBackgroundColor:[UIColor clearColor]];
        self.commentView = commentView;
        [self addSubview:commentView];
        
        UIView *textfieldView = [UIView new];
        [textfieldView setBackgroundColor:[UIColor whiteColor]];
        [textfieldView.layer setCornerRadius:5.f];
        textfieldView.layer.dk_borderColorPicker = DKColorPickerWithRGB(0xbfbfbf, 0x282828);
        textfieldView.dk_backgroundColorPicker =DKColorPickerWithKey(BG);
        [textfieldView.layer setBorderWidth:1.f];
        [textfieldView setClipsToBounds:YES];
        self.textfieldView = textfieldView;
        [commentView addSubview:textfieldView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentClick)];
        [textfieldView addGestureRecognizer:tap];
        
        UILabel *commentLab = [UILabel new];
        [commentLab setText:@"写评论..."];
        [commentLab setUserInteractionEnabled:YES];
        [commentLab setFont:[UIFont systemFontOfSize:14.f]];
        commentLab.dk_textColorPicker = DKColorPickerWithRGB(0x949494, 0x989898);
        self.commentLab = commentLab;
        [textfieldView addSubview:commentLab];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.topLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5f);
    
    self.commentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49.f);
    self.textfieldView.frame = CGRectMake(14.f, (49.f - kCommentTextFiledH) * 0.5, SCREEN_WIDTH - 28.f, kCommentTextFiledH);
    self.commentLab.frame = CGRectMake(5.f, 0,self.textfieldView.frame.size.width, kCommentTextFiledH);
}

- (void)commentClick{
    if (self.commentBlock) {
        self.commentBlock();
    }
}

- (void)dealloc{
    if (self.commentBlock) {
        self.commentBlock = nil;
    }
}
@end
