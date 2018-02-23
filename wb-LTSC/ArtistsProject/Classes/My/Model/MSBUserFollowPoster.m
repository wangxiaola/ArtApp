//
//  MSBUserFollowPoster.m
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBUserFollowPoster.h"
#import "NSString+Extension.h"

@implementation MSBUserFollowPoster

- (void)setComment_time:(NSString *)comment_time{
    _comment_time = [NSString formatTimeStamp:[comment_time doubleValue]];
}

@end
