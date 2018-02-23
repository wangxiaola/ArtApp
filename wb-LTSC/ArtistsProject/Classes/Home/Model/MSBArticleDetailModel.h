//
//  MSBArticleDetailModel.h
//  meishubao
//
//  Created by T on 16/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface MSBArticleDetailModel : BaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *term_id;
@property (nonatomic, copy) NSString *post_id;

@property (nonatomic, copy) NSString *post_title;
@property (nonatomic, copy) NSString *post_date;
@property (nonatomic, copy) NSString *post_content;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) BOOL is_collect;
@property (nonatomic, assign) BOOL is_praise;
@property (nonatomic, copy) NSString *post_image;
@property (nonatomic, copy) NSString *comment_num;
@property(nonatomic, strong) NSArray *post_keywords;
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic, copy) NSString *post_url;

@property (nonatomic, copy) NSString *share_url;
@property (nonatomic, copy) NSString *share_image;
@property (nonatomic, copy) NSString *share_desc;
@property (nonatomic, copy) NSString *share_title;
@property (nonatomic, copy) NSArray *smeta;

//最热展览
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *medium;

@end
