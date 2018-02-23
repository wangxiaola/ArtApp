//
//  MSBArticleCommentModel.m
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBArticleCommentModel.h"
#import "MJExtension.h"
#import "NSString+Extension.h"

//@interface MSBReplyComment : NSObject
//@property (nonatomic, copy) NSString *uid;
//@property (nonatomic, copy) NSString *to_uid;
//@property (nonatomic, copy) NSString *avatar;
//@property (nonatomic, copy) NSString *nickname;
//@property (nonatomic, copy) NSString *comment_id;
//@property (nonatomic, copy) NSString *reply_nickname;
//@property (nonatomic, copy) NSString *comment_content;
//@property (nonatomic, copy) NSString *comment_date;
//@property (nonatomic, assign) NSInteger praise;
//@end
//
//@implementation MSBReplyComment
//- (void)setComment_date:(NSString *)comment_date{
//    _comment_date = [NSString formatTimeStamp:[comment_date doubleValue]];
//}
//@end


@implementation MSBArticleCommentModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"reply_comments":[MSBReplyComment class]};
}

- (void)setComment_date:(NSString *)comment_date{
    _comment_date = [NSString formatTimeStamp:[comment_date doubleValue]];
}

@end
