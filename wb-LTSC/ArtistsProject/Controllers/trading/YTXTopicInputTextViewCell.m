//
//  YTXTopicInputTextViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/2.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXTopicInputTextViewCell.h"

#define MARGIN          10
#define SEND_BTN_SIZE   CGSizeMake(60, 40)

@interface YTXTopicInputTextViewCell ()

@property (nonatomic, strong) NSString *replyId;

@property (nonatomic, strong) UIView *inputBackView;
@property (nonatomic, strong) UITextField *inputText;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation YTXTopicInputTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self inputText];
        [self sendButton];
    }
    return self;
}

- (UIView *)inputBackView
{
    if (!_inputBackView) {
        _inputBackView = [[UIView alloc] init];
        _inputBackView.backgroundColor = [UIColor colorWithRGB:0xf1f1f1];
        [self.contentView addSubview:_inputBackView];
        
        [_inputBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.right.mas_equalTo(self.sendButton.mas_left);
            make.top.mas_equalTo(MARGIN);
            make.bottom.mas_equalTo(-MARGIN);
        }];
    }
    return _inputBackView;
}

- (UITextField *)inputText
{
    if (!_inputText) {
        _inputText = [[UITextField alloc] init];
        _inputText.font = kFont(15);
        _inputText.placeholder = @"我也说两句...";
        [self.inputBackView addSubview:_inputText];
        
        [_inputText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.right.mas_equalTo(-MARGIN);
            make.top.and.bottom.mas_equalTo(0);
        }];
    }
    return _inputText;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.backgroundColor = [UIColor blackColor];
        _sendButton.titleLabel.font = kFont(15);
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sendButton];
        
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-MARGIN);
            make.top.mas_equalTo(MARGIN);
            make.bottom.mas_equalTo(-MARGIN);
            make.width.mas_equalTo(70);
        }];
    }
    return _sendButton;
}

- (void)becomeWithUserName:(NSString *)username replyId:(NSString *)replyId
{
    _replyId = replyId;
    
    [self.inputText becomeFirstResponder];
    self.inputText.text = [NSString stringWithFormat:@"@%@ ",username];
}

- (void)clearText
{
    [self.inputText resignFirstResponder];
    self.inputText.text = @"";
}

- (void)sendAction:(UIButton *)sender
{
    if (_sendActionBlock) {
        _sendActionBlock(self.inputText.text, _replyId);
    }
}

@end
