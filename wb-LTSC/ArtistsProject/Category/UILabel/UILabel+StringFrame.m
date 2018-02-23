//
//  UILabel+StringFrame.m
//  IMExchange
//
//  Created by RenWei on 14/11/21.
//  Copyright (c) 2014年 snailgame. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize;
   // if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        retSize = [self.text boundingRectWithSize:size
                                                 options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil].size;
    /*
    } else {
        retSize = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    */
    return retSize;
}



@end
