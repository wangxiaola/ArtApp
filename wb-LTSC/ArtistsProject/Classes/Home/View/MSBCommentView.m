//
//  MSBCommentView.m
//  meishubao
//
//  Created by T on 16/11/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBCommentView.h"
#import "GeneralConfigure.h"
#import "UIImageEffects.h"

#define ANIMATE_DURATION    0.3f
#define kMarginWH           10
#define kButtonWidth        50
#define kButtonHeight       30
#define kTextFont           [UIFont systemFontOfSize:14]
#define kTextViewHeight     100
#define kSheetViewHeight    (kMarginWH * 3 + kButtonHeight + kTextViewHeight)

@interface MSBCommentView ()
@property (copy, nonatomic) SuccessBlock success;
@property (weak, nonatomic) id<MSBCommentViewDelegate> delegate;

@property (strong, nonatomic) UIView *sheetView;
@property (strong, nonatomic) UITextView *commentTextView;
@end

@implementation MSBCommentView

+ (void)commentshowInView:(UIView *)view success:(SuccessBlock)success delegate:(id <MSBCommentViewDelegate>)delegate
{
    MSBCommentView *commentView = [[MSBCommentView alloc] initWithFrame:view.bounds];
    if (commentView) {

        commentView.userInteractionEnabled = YES;
        [commentView addEventResponsors];
        commentView.success = success;
        commentView.delegate = delegate;
//        commentView.image = [UIImageEffects imageByApplyingLightEffectToImage:[commentView snapShot:view]];
        [commentView setBackgroundColor:RGBALCOLOR(0, 0, 0, 0.3)];
//         commentView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        [view addSubview:commentView];
        [view addSubview:commentView.sheetView];
        [commentView.commentTextView becomeFirstResponder];
    }
}

- (void)tapClick{
    [self cancelComment:nil];
}

#pragma mark - 外部调用
+ (void)commentshowSuccess:(SuccessBlock)success{
    [MSBCommentView commentshowInView:[UIApplication sharedApplication].keyWindow success:success delegate:nil];
}

+ (void)commentshowDelegate:(id<MSBCommentViewDelegate>)delegate{
    [MSBCommentView commentshowInView:[UIApplication sharedApplication].keyWindow success:nil delegate:delegate];
}

+ (void)commentshowInView:(UIView *)view success:(SuccessBlock)success{
    [MSBCommentView commentshowInView:view success:success delegate:nil];
}

+ (void)commentshowInView:(UIView *)view delegate:(id<MSBCommentViewDelegate>)delegate{
    [MSBCommentView commentshowInView:view success:nil delegate:delegate];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
//    self.alpha = 0;
    CGRect rect = self.bounds;
    _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height - kSheetViewHeight, rect.size.width, kSheetViewHeight)];
//    _sheetView.backgroundColor = RGBCOLOR(238, 238, 238);
    _sheetView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(kMarginWH, kMarginWH, kButtonWidth, kButtonHeight);
    cancelButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton dk_setTitleColorPicker:DKColorPickerWithRGB(0x030303, 0x989898) forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = kTextFont;
    [cancelButton addTarget:self action:@selector(cancelComment:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:cancelButton];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(_sheetView.bounds.size.width - kButtonWidth - kMarginWH, kMarginWH, kButtonWidth, kButtonHeight);
    commentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [commentButton setTitle:@"发送" forState:UIControlStateNormal];
//    [commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [commentButton dk_setTitleColorPicker:DKColorPickerWithRGB(0x030303, 0x989898) forState:UIControlStateNormal];
    commentButton.titleLabel.font = kTextFont;
    [commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:commentButton];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"写评论";
    label.frame = CGRectMake((_sheetView.bounds.size.width - kButtonWidth) / 2, kMarginWH, kButtonWidth, kButtonHeight);
     label.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
    label.font = [UIFont systemFontOfSize:16];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_sheetView addSubview:label];
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(kMarginWH, _sheetView.bounds.size.height - kMarginWH - kTextViewHeight, rect.size.width - kMarginWH * 2, kTextViewHeight)];
    _commentTextView.text = nil;
    _commentTextView.dk_textColorPicker =DKColorPickerWithRGB(0x030303, 0x989898);
    _commentTextView.layer.dk_borderColorPicker = DKColorPickerWithRGB(0xaaaaaa, 0x282828);
    [_commentTextView.layer setBorderWidth:0.5f];
    _commentTextView.dk_backgroundColorPicker =DKColorPickerWithKey(BG);
    [_commentTextView setFont:[UIFont systemFontOfSize:17]];
    if (isNightMode) {
        _commentTextView.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    [_sheetView addSubview:_commentTextView];
}

- (void)addEventResponsors
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (UIImage *)snapShot:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0f);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)cancelComment:(id)sender {
    [_sheetView endEditing:YES];
}
- (void)comment:(id)sender {
    //发送请求
    
    if (_success) {
        _success(_commentTextView.text);
    }
    if ([_delegate respondsToSelector:@selector(commentDidFinished:)]) {
        [_delegate commentDidFinished:_commentTextView.text];
    }
    [_sheetView endEditing:YES];
}

- (void)dismissCommentView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
    [_sheetView removeFromSuperview];
}

#pragma mark - Keyboard Notification Action
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGFloat keyboardHeight = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSTimeInterval animationDuration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 1;
        _sheetView.frame = CGRectMake(0, self.superview.bounds.size.height - _sheetView.bounds.size.height - keyboardHeight, _sheetView.bounds.size.width, kSheetViewHeight);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 0;
        _sheetView.frame = CGRectMake(0, self.superview.bounds.size.height, _sheetView.bounds.size.width, kSheetViewHeight);
    } completion:^(BOOL finished){
        [self dismissCommentView];
    }];
}
@end
