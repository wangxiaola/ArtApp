//
//  MSBInfoStoreItem.m
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBInfoStoreItem.h"
#import "GeneralConfigure.h"
#import "NSString+Extension.h"

@implementation MSBInfoStoreItem

- (void)setComment_date:(NSString *)comment_date{
    _comment_date =  [NSString distanceTimeWithBeforeTime:[comment_date doubleValue]];
}
@end


@implementation MSBInfoStoreVideoItem
- (void)setComment_date:(NSString *)comment_date{
    _comment_date =  [NSString distanceTimeWithBeforeTime:[comment_date doubleValue]];
}

- (void)setDuration:(NSString *)duration{
    float time2 = [duration floatValue];
    time2 /= 1000;
    _duration = [TimeStamp timeStampToTimeWithTimeStamp:[NSString stringWithFormat:@"%f", time2] dateFormat:@"mm:ss"];
}
@end

@implementation MSBInfoStorePhotoItem

- (void)setPics:(NSMutableArray *)pics {

    NSMutableArray * newArray = [NSMutableArray array];
    if (pics.count > 0) {
        for (int i = 0; i < pics.count; i++) {
            NSString * url = [NSString imageUrlString:pics[i]];
            [newArray addObject:url];
        }
    }
    _pics = newArray;
}

@end
