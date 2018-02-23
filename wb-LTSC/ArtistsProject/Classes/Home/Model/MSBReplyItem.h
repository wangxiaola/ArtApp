//
//  MSBReplyItem.h
//  meishubao
//
//  Created by T on 17/1/6.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSBReplyItem : NSObject
@property (nonatomic, assign) BOOL hasmore;
@property (nonatomic, assign) NSInteger reply_comments_num;
@property(nonatomic,strong) NSArray *items;
@end
