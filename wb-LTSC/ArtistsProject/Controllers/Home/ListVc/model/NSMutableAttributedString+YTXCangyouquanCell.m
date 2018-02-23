//
//  NSMutableAttributedString+YTXCangyouquanCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/17.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "NSMutableAttributedString+YTXCangyouquanCell.h"

@implementation NSMutableAttributedString (YTXCangyouquanCell)

- (void)appendLine {
    if ([[self.string substringFromIndex:self.length - 1] isEqualToString:@"|"]) {
        return;
    }
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:@" | "]];
}

- (void)appendIconVideo {
    NSTextAttachment *text = [[NSTextAttachment alloc] init];
    text.image = [UIImage imageNamed:@"icon_video"];
    text.bounds = CGRectMake(0, 0, 32, 32);
    [self appendAttributedString:[NSAttributedString attributedStringWithAttachment:text]];
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:@" 视频" attributes:@{NSForegroundColorAttributeName:RGB(134, 214, 185)}]];
}

@end
