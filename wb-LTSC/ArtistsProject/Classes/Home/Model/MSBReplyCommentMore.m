//
//  MSBReplyCommentMore.m
//  meishubao
//
//  Created by benbun－mac on 17/1/5.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "MSBReplyCommentMore.h"
#import "MJExtension.h"
#import "MSBReplyComment.h"
@implementation MSBReplyCommentMore
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"reply_comments":[MSBReplyComment class]};
}
@end
