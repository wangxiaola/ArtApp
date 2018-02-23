//
//  ArtCopyLabel.m
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/5/4.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtCopyLabel.h"

@implementation ArtCopyLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self pressAction];
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        [self pressAction];
    }
    return self;
}
// 初始化设置
- (void)pressAction {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1;
    [self addGestureRecognizer:longPress];
}
// 使label能够成为响应事件
- (BOOL)canBecomeFirstResponder {
    return YES;
}
// 控制响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(customCopy:);
}
//UIPasteboard：该类支持写入和读取数据，类似剪贴板
- (void)customCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
}
//UIMenuController：可以通过这个类实现在点击内容，或者长按内容时展示出复制、剪贴、粘贴等选择的项，每个选项都是一个UIMenuItem对象

- (void)longPressAction:(UIGestureRecognizer *)recognizer {
    [self becomeFirstResponder];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(customCopy:)];
    UIMenuItem *copyItem1 = [[UIMenuItem alloc] initWithTitle:@"剪切" action:@selector(customCopy:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem,copyItem1, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}
@end
