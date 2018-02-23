//
//  MSBArtistDetailModel.h
//  meishubao
//
//  Created by T on 17/1/6.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "artist_id":3,
 "name":"王大雷",
 "photo":"http://101.201.122.141/data/upload/ueditor/20161121/58329db5618e9.jpg"
 "intro":"吴冠中（1919—2010），江苏宜兴人，当代著名画家、油画家、美术教育家油画代表作有《长江三峡》、《北国风光》、《小鸟天堂》等。个人文集有《吴冠中谈艺集》等十余种"
 "lifetime":"吴冠中在50～70年代，致力于风景油画创作，并进行油画民族化的探索。他力图把欧洲油画描绘自然的直观生动性、油画色彩的丰富细腻性与中国传统艺术精神、审美理想融合到一起",
 "comment_num":10000,
 "artist_view":121,
 "work_num":121,
 "praise":1221,
 "is_praise":1,
 "is_collect":1,
 "comment_num":21,
 "artist_url":"http://dev.benbun.com/web/proj/Mobile/Artist/detail/artist_id/3",
 "artist_keyword":["中国国家","美术","教师"],
 "artist_position":["中国理事会主席","中国画院院长","内蒙古小学校长"]
 */
@interface MSBArtistDetailModel : NSObject
@property (nonatomic, copy) NSString *artist_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *lifetime;
@property (nonatomic, copy) NSString *comment_num;
@property (nonatomic, copy) NSString *artist_view;
@property (nonatomic, copy) NSString *work_num;
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic, copy) NSString *is_praise;
@property (nonatomic, copy) NSString *is_collect;
@property (nonatomic, copy) NSString *artist_url;
@property (nonatomic, strong) NSArray *artist_keyword;
@property (nonatomic, strong) NSArray *artist_position;
@end
