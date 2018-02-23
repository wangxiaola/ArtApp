//
//  MSBUserFollowPoster.h
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSBUserFollowPoster : NSObject
@property (nonatomic, copy) NSString *post_id;
@property (nonatomic, copy) NSString *post_title;
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic, copy) NSString *comment_content;
@property (nonatomic, copy) NSString *comment_time;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *comment_date;
@property (nonatomic, assign) BOOL is_praise;
@end
