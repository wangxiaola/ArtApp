//
//  MSBVideoDetaiModel.h
//  meishubao
//
//  Created by T on 17/1/9.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "video_id": "96",
 "video_title": "测试视频",
 "video": "http://7xl7n7.com2.z0.glb.qiniucdn.com/msb/2016112021071699166.mp4",
 "video_image": "http://qiniu.zgmsbw.com/meishubao/2016123009460537152.jpg",
 "video_intro": "简介啊的撒大事姐姐爱圣诞节I啊撒 啊萨达萨达啊萨达萨达撒阿斯顿阿斯顿爱谁",
 "comment_num": "122",
 "is_collect": 1,
 "video_url": "http://dev.benbun.com/web/proj/meishubao/Mobile/Video/detail/videoId/96",
 "is_praise": 1,
 "praise": 232,
 "video_keyword":["中国国家","美术","教师"]
 */

@interface MSBVideoDetaiModel : NSObject
@property (nonatomic, copy) NSString *video_id;
@property (nonatomic, copy) NSString *video_title;
@property (nonatomic, copy) NSString *video_intro;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *video_image;
@property (nonatomic, copy) NSString *comment_num;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, assign) BOOL is_collect;
@property (nonatomic, assign) BOOL is_praise;
@property (nonatomic, strong) NSArray *video_keyword;
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic,copy) NSArray * correlation;

@end
