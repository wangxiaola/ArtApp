//
//  BBCommentView.m
//  adquan
//
//  Created by Benbun on 15/8/5.
//  Copyright (c) 2015年 benbun. All rights reserved.
//

#import "BBCommentView.h"
#import "GeneralConfigure.h"

@interface BBCommentView ()<UITextViewDelegate>
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UILabel *titleLab;
@end

@implementation BBCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = RGBCOLOR(255, 255, 255);
    
    // 顶部view
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    
    UIView *mTopViewTopLine = [[UIView alloc] init];
    [topView addSubview:mTopViewTopLine];
    mTopViewTopLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5f);
    mTopViewTopLine.backgroundColor = [UIColor blackColor];
    mTopViewTopLine.alpha = 0.1f;
    
    UIView *mTopViewBottomLine = [[UIView alloc] init];
    [topView addSubview:mTopViewBottomLine];
    mTopViewBottomLine.frame = CGRectMake(0, 89.5, SCREEN_WIDTH, 0.5);
    mTopViewBottomLine.backgroundColor = [UIColor blackColor];
    mTopViewBottomLine.alpha = 0.1f;
    
    UITextView *textView = [[UITextView alloc] init];
    [topView addSubview:textView];
    self.textView = textView;
    textView.delegate = self;
    // 底部view
    UIView *mBottomView = [[UIView alloc] init];
    [self addSubview:mBottomView];
    mBottomView.frame = CGRectMake(0, 90, SCREEN_WIDTH, 36);
    
    UIButton *mCloseBtn = [[UIButton alloc] init];
    [mBottomView addSubview:mCloseBtn];
    [mCloseBtn setTitle:@"取消" forState:UIControlStateNormal];
    [mCloseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    mCloseBtn.frame = CGRectMake(-20, 0,100,36);
    [mCloseBtn addTarget:self action:@selector(closeCommentView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *commentBtn = [[UIButton alloc] init];
    [mBottomView addSubview:commentBtn];
    [commentBtn setTitle:@"发送" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commentBtn.frame = CGRectMake(SCREEN_WIDTH - 56, 0, 50, 36);
    self.commentBtn = commentBtn;
    commentBtn.enabled = NO;
    [commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.textView setFrame:CGRectMake(25.f, 10.f, SCREEN_WIDTH - 2 * 25, 70)];
   
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.commentBlock) {
        self.commentBlock = nil;
    }
}

- (void)closeCommentView{
    [self.textView resignFirstResponder];
}

- (void)commentBtnClick{
//    if ([self.delegate respondsToSelector:@selector(commentViewDidClickCommentBtn:textView:)]) {
//        [self.delegate commentViewDidClickCommentBtn:self textView:self.textView];
//    }
    if (self.commentBlock) {
        self.commentBlock(self.textView.text);
    }
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.commentBtn.enabled = textView.text.length;
}

#pragma mark keyboardNotification

- (void)keyboardWillShow:(NSNotification*)noti{
    NSValue *value = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    CGFloat height = rect.size.height;

            
    [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.transform = CGAffineTransformMakeTranslation(0, - (height + 126));
                             } completion:nil];

        
    
}

- (void)keyboardWillHide:(NSNotification*)notification{
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0, 0);
                     } completion:nil];
}

#pragma  mark ConvertPoint
//将坐标点y 在window和superview转化  方便和键盘的坐标比对
- (float)convertYFromWindow:(float)Y{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CGPoint o = [appDelegate.window convertPoint:CGPointMake(0, Y) toView:self.superview];
    return o.y;
}
- (float)convertYToWindow:(float)Y
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CGPoint o = [self.superview convertPoint:CGPointMake(0, Y) toView:appDelegate.window];
    return o.y;
}
- (float)getHeighOfWindow
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate.window.frame.size.height;
}


@end
