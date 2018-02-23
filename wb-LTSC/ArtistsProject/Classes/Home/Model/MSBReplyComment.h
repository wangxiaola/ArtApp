//
//  MSBReplyComment.h
//  meishubao
//
//  Created by T on 17/1/5.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSBReplyComment : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *to_uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *reply_nickname;
@property (nonatomic, copy) NSString *comment_content;
@property (nonatomic, copy) NSString *comment_date;
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic, copy) NSString *to_comment_id;
@property (nonatomic, assign) NSInteger anonymity;
@property (nonatomic, assign) NSInteger reply_anonymity;
@end
