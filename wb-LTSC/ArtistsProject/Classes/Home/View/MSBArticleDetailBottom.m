//
//  MSBArticleDetailBottom.m
//  meishubao
//
//  Created by T on 16/11/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBArticleDetailBottom.h"
#import "GeneralConfigure.h"
#import "JSBadgeView.h"

static const CGFloat kCommentTextFiledH = 30.f;

@interface MSBArticleDetailBottom ()
@property (nonatomic, weak) UIView  *commentView;
@property (nonatomic, weak) UIView  *textfieldView;
@property (nonatomic, weak) UILabel  *commentLab;

@property (nonatomic, weak) UIView  *messageView;
@property (nonatomic, weak) UIButton  *messageBtn;

@property (nonatomic, weak) UIView  *shareView;
@property (nonatomic, weak) UIButton  *shareBtn;

@property (nonatomic, weak) UIView  *storeView;
@property (nonatomic, weak) UIButton  *storeBtn;

@property (nonatomic, weak) JSBadgeView *badgeView;

@property (nonatomic, weak) CAShapeLayer  *topLine;
@end

@implementation MSBArticleDetailBottom
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
        
        UIView *messageView = [UIView new];
        [messageView setBackgroundColor:[UIColor clearColor]];
        self.messageView = messageView;
        [self addSubview:messageView];
        // immerse_comment_mark
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *messageImage = [UIImage imageNamed:@"immerse_comment_mark"];
        UIImage *shareImage = [UIImage imageNamed:@"contenttoolbar_hd_share"];
        UIImage *storeNormalImage = [UIImage imageNamed:@"contenttoolbar_hd_fav_normal"];
        UIImage *storeSelectedImage = [UIImage imageNamed:@"contenttoolbar_hd_fav_selected"];
        if (THEME_NORMAL) {
            messageImage =  [messageImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
            shareImage = [shareImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
            storeNormalImage = [storeNormalImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
            storeSelectedImage = [storeSelectedImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
        }else{
            messageImage =  [messageImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
            shareImage = [shareImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
            storeNormalImage = [storeNormalImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
            storeSelectedImage = [storeSelectedImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        }
        
        [messageBtn setImage:messageImage forState:UIControlStateNormal];
        [messageBtn.imageView setContentMode:UIViewContentModeCenter];
        [messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.messageBtn = messageBtn;
        [messageView addSubview:messageBtn];
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:messageBtn alignment:JSBadgeViewAlignmentTopRight];
        self.badgeView = badgeView;
        badgeView.type = 2;
        badgeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageBtnClick)];
        [badgeView addGestureRecognizer:tapGes];
        badgeView.badgeBackgroundColor = RGBCOLOR(248, 87, 94);
        badgeView.badgeTextFont = [UIFont systemFontOfSize:9];
        badgeView.badgeText = @"0";
        
        
        UIView *shareView = [UIView new];
        [shareView setBackgroundColor:[UIColor clearColor]];
        self.shareView = shareView;
        [self addSubview:shareView];
        //contenttoolbar_hd_fav_selected  shareBtn
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:shareImage forState:UIControlStateNormal];
        [shareBtn.imageView setContentMode:UIViewContentModeCenter];
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.shareBtn = shareBtn;
        [shareView addSubview:shareBtn];
        
        UIView *storeView = [UIView new];
        [storeView setBackgroundColor:[UIColor clearColor]];
        self.storeView = storeView;
        [self addSubview:storeView];
        //  storeBtn
        UIButton *storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [storeBtn setImage:storeNormalImage forState:UIControlStateNormal];
        [storeBtn setImage:storeSelectedImage forState:UIControlStateSelected];
        [storeBtn.imageView setContentMode:UIViewContentModeCenter];
        [storeBtn addTarget:self action:@selector(storeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.storeBtn = storeBtn;
        [storeView addSubview:storeBtn];

    }
    return self;
}

-(void)setIsImageMode:(BOOL)isImageMode
{
    _isImageMode = isImageMode;
    if (isImageMode && THEME_NORMAL) {
        //设置背景色为夜间模式
        self.backgroundColor = [UIColor colorWithHex:0x1c1c1c];
        self.topLine.backgroundColor = [UIColor colorWithHex:0x282828].CGColor;
        self.textfieldView.layer.backgroundColor = [UIColor colorWithHex:0x282828].CGColor;
        self.textfieldView.backgroundColor = [UIColor colorWithHex:0x1c1c1c];
        self.commentLab.textColor = [UIColor colorWithHex:0x989898];
        
        UIImage *messageImage = [UIImage imageNamed:@"immerse_comment_mark"];
        UIImage *shareImage = [UIImage imageNamed:@"contenttoolbar_hd_share"];
        UIImage *storeNormalImage = [UIImage imageNamed:@"contenttoolbar_hd_fav_normal"];
        UIImage *storeSelectedImage = [UIImage imageNamed:@"contenttoolbar_hd_fav_selected"];
        messageImage =  [messageImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        shareImage = [shareImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        storeNormalImage = [storeNormalImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        storeSelectedImage = [storeSelectedImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        
        [self.shareBtn setImage:shareImage forState:UIControlStateNormal];
        [self.messageBtn setImage:messageImage forState:UIControlStateNormal];
        [self.storeBtn setImage:storeNormalImage forState:UIControlStateNormal];
        [self.storeBtn setImage:storeSelectedImage forState:UIControlStateSelected];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.topLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5f);

    CGFloat width = SCREEN_WIDTH * 0.5f  / 3.f;
    if (self.isArtist) {
        self.storeView.hidden = YES;
        self.commentView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5 + width, kBottomViewHeight);
        self.textfieldView.frame = CGRectMake(14.f, (kBottomViewHeight - kCommentTextFiledH) * 0.5, SCREEN_WIDTH * 0.5 + width - 14.f, kCommentTextFiledH);
        self.messageView.frame = CGRectMake(CGRectGetMaxX(self.commentView.frame), 0, width, kBottomViewHeight);
        self.messageBtn.frame = CGRectMake(0, 0, width, kBottomViewHeight);
        self.shareView.frame = CGRectMake(CGRectGetMaxX(self.messageView.frame), 0, width, kBottomViewHeight);
        self.shareBtn.frame = CGRectMake(0, 0, width, kBottomViewHeight);
    }else {
        self.storeView.hidden = NO;
        self.commentView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, kBottomViewHeight);
        self.textfieldView.frame = CGRectMake(14.f, (kBottomViewHeight - kCommentTextFiledH) * 0.5, SCREEN_WIDTH * 0.5 - 14.f, kCommentTextFiledH);
        self.messageView.frame = CGRectMake(CGRectGetMaxX(self.commentView.frame), 0, width, kBottomViewHeight);
        self.messageBtn.frame = CGRectMake(0, 0, width, kBottomViewHeight);

        self.storeView.frame = CGRectMake(CGRectGetMaxX(self.messageView.frame), 0, width, kBottomViewHeight);
        self.storeBtn.frame = CGRectMake(0, 0, width, kBottomViewHeight);

        self.shareView.frame = CGRectMake(CGRectGetMaxX(self.storeView.frame), 0, width, kBottomViewHeight);
        self.shareBtn.frame = CGRectMake(0, 0, width, kBottomViewHeight);
    }
    self.commentLab.frame = CGRectMake(5.f, 0,self.textfieldView.frame.size.width, kCommentTextFiledH);
}

- (void)setCommentCount:(NSString *)commentCount{
    _commentCount = commentCount;
    self.badgeView.badgeText = commentCount;
}

- (void)setIs_collect:(BOOL)is_collect{
    _is_collect = is_collect;
    self.storeBtn.selected = is_collect;
}

- (void)setIsArtist:(BOOL)isArtist {

    _isArtist = isArtist;
}

#pragma mark - Method
- (void)messageBtnClick{
    if (self.messClick) {
        self.messClick();
    }
}
- (void)shareBtnClick:(UIButton *)shareBtn{
    if (self.shareClick) {
        self.shareClick();
    }
}
- (void)storeBtnClick:(UIButton *)storeBtn{
    if (self.storeClick) {
        self.storeClick(storeBtn);
    }
}

- (void)commentClick{
    if (self.commentBlock) {
        self.commentBlock();
    }
}

- (void)dealloc{
    if (self.shareBtn) {
        [self.shareBtn removeTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.messageBtn) {
        [self.messageBtn removeTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.storeBtn) {
         [self.storeBtn removeTarget:self action:@selector(storeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.shareClick) {
        self.shareClick = nil;
    }
    
    if (self.messClick) {
        self.messClick = nil;
    }
    
    if (self.storeClick) {
        self.storeClick = nil;
    }
    
    if (self.commentBlock) {
        self.commentBlock = nil;
    }
}
@end
