//
//  MSBArticleCommentModel.h
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSBReplyComment.h"
#import "MSBReplyItem.h"
@interface MSBArticleCommentModel : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *comment_content;
@property (nonatomic, copy) NSString *comment_date;
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic, assign) BOOL is_praise;
@property (nonatomic, assign) NSInteger anonymity;
//@property (nonatomic, assign) BOOL hasmore;
//@property (nonatomic, assign) NSInteger reply_comments_num;
@property(nonatomic,strong) MSBReplyItem *reply_comments;
//@property(nonatomic,strong) NSArray *reply_comments;
@end
