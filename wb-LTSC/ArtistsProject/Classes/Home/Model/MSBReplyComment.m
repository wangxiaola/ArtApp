//
//  MSBReplyComment.m
//  meishubao
//
//  Created by T on 17/1/5.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "MSBReplyComment.h"
#import "NSString+Extension.h"
@implementation MSBReplyComment
- (void)setComment_date:(NSString *)comment_date{
    _comment_date = [NSString formatTimeStamp:[comment_date doubleValue]];
}

@end
