//
//  MSBReplyItem.m
//  meishubao
//
//  Created by T on 17/1/6.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "MSBReplyItem.h"
#import "MSBReplyComment.h"

@implementation MSBReplyItem
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"items":[MSBReplyComment class]};
}
@end
