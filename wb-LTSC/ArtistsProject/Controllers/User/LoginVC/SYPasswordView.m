//
//  VerifyVc.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "SYPasswordView.h"

#define kDotSize CGSizeMake (20, 20) //密码点的大小
#define kDotCount 4  //密码个数
#define K_Field_Height self.frame.size.height  //每一个输入框的高度等于当前view的高度
@interface SYPasswordView ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点

@end

@implementation SYPasswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initPwdTextField];
    }
    return self;
}

- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = self.frame.size.width / kDotCount;
    
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, 0, 1, K_Field_Height)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UILabel *dotView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.textColor = [UIColor blackColor];
//        dotView.backgroundColor = [UIColor blackColor];
//        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
//        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        //NSLog(@"输入的字符个数大于6，忽略输入");
                return NO;
    } else {
        return YES;
    }
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    //NSLog(@"%@", textField.text);
    for (UILabel *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++){
        UILabel* la =   ((UILabel *)[self.dotArray objectAtIndex:i]);
        la.hidden = NO;
        la.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
    }
    if (textField.text.length == kDotCount) {
        //NSLog(@"输入完毕");
        if (self.selectBtnCilck) {
            self.selectBtnCilck(textField.text);
        }
    }
}

#pragma mark - init
-(void)popupKeyboard{
    [_textField becomeFirstResponder];
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, K_Field_Height)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textColor = [UIColor whiteColor];
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [[UIColor grayColor] CGColor];
        _textField.layer.borderWidth = 1;
       [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return _textField;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}
@end
