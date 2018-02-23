//
//  MSBInfoStoreItem.h
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSBInfoStoreItem : NSObject

@property (nonatomic, copy) NSString *post_id;
@property (nonatomic, copy) NSString *post_title;
@property (nonatomic, copy) NSString *post_image;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic, copy)  NSString *comment_date;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) BOOL is_praise;
@property (nonatomic, copy) NSString *post_url;

@property (nonatomic, copy) NSString *share_url;
@property (nonatomic, copy) NSString *share_title;
@property (nonatomic, copy) NSString *share_desc;
@property (nonatomic, copy) NSString *share_image;
@end

@interface MSBInfoStoreVideoItem : NSObject

@property (nonatomic, copy) NSString *video_id;
@property (nonatomic, copy) NSString *video_name;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *comment_date;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *video_view;


@end
//
@interface MSBInfoStorePhotoItem : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSMutableArray *pics;

@end
