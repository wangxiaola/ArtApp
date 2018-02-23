//
//  MSBReplyCommentMore.h
//  meishubao
//
//  Created by benbun－mac on 17/1/5.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSBReplyCommentMore : NSObject

@property (nonatomic,copy) NSString * total;
@property (nonatomic,copy) NSString * offset;
@property (nonatomic,copy) NSString * pagesize;
@property (nonatomic,assign) BOOL hasmore;
@property (nonatomic,copy) NSArray * reply_comments;

@end
